#!/usr/bin/env python3
import json
import sys
import hashlib
import os
from datetime import datetime, date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from cost_calc import calc_cost, calc_cost_by_date

SESSIONS = Path.home() / ".claude" / "sessions"
SESSIONS.mkdir(exist_ok=True)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

path       = data.get("transcript_path") or ""
session_id = data.get("session_id") or ""
last_msg   = data.get("last_assistant_message", "").strip()[:200]
if not path:
    sys.exit(0)


def extract_model(p: str) -> str:
    try:
        for line in Path(p).read_text().splitlines():
            obj = json.loads(line)
            if obj.get("type") == "assistant":
                model = obj.get("message", {}).get("model", "")
                if model:
                    return model
    except Exception:
        pass
    return "unknown"


def count_messages(p: str) -> int:
    try:
        return sum(
            1 for line in Path(p).read_text().splitlines()
            if json.loads(line).get("type") == "user"
        )
    except Exception:
        return 0


def find_llmthing_root() -> Path | None:
    cache = Path("/tmp/.llmthing_root")
    if cache.exists():
        cached = cache.read_text().strip()
        if cached and (Path(cached) / ".llmthing").exists():
            return Path(cached)
    matches = list(Path.home().glob("**/.llmthing"))
    if matches:
        root = matches[0].parent
        cache.write_text(str(root))
        return root
    return None


def extract_new_messages(p: str, from_line: int) -> tuple[list[str], int]:
    turns = []
    try:
        lines = Path(p).read_text().splitlines()
        for line in lines[from_line:]:
            obj = json.loads(line)
            role = obj.get("type")
            if role not in ("user", "assistant"):
                continue
            content = obj.get("message", {}).get("content", "")
            text = ""
            if isinstance(content, str):
                text = content.strip()
            elif isinstance(content, list):
                parts = [b["text"].strip() for b in content
                         if b.get("type") == "text" and b.get("text", "").strip()]
                text = "\n".join(parts)
            if text:
                turns.append(("U" if role == "user" else "A", text))
        return turns, len(lines)
    except Exception:
        return [], from_line


# ── Update ~/.claude/sessions/ JSON ──────────────────────────────────────────
model = extract_model(path)
cost  = calc_cost(path, model) or 0
now   = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

session_file = SESSIONS / (hashlib.md5(path.encode()).hexdigest()[:16] + ".json")
started_at   = now
if session_file.exists():
    try:
        started_at = json.loads(session_file.read_text()).get("started_at", now)
    except Exception:
        pass

costs_by_date = calc_cost_by_date(path, model)
session_file.write_text(json.dumps({
    "transcript_path": path,
    "model": model,
    "started_at": started_at,
    "updated_at": now,
    "cost_usd": cost,
    "costs_by_date": costs_by_date,
    "message_count": count_messages(path),
    "is_final": True,
}))

# ── Write joi session log (append-only, cursor-tracked) ───────────────────────
llmthing = find_llmthing_root()
if not llmthing:
    sys.exit(0)

sessions_dir = llmthing / "joi" / "logs" / "sessions"
sessions_dir.mkdir(parents=True, exist_ok=True)

cursor_file = Path(f"/tmp/session-cursor-{session_id}.txt")
cursor      = int(cursor_file.read_text()) if cursor_file.exists() else 0

new_turns, new_cursor = extract_new_messages(path, cursor)
if not new_turns and cursor > 0:
    sys.exit(0)

# find or create the session log file
existing = list(sessions_dir.glob(f"session-{session_id[:8]}-*.md"))
if existing:
    log_path = existing[0]
    # update cost in frontmatter
    content  = log_path.read_text()
    content  = "\n".join(
        f"cost: ${cost:.2f}" if line.startswith("cost:") else line
        for line in content.split("\n")
    )
    # append new turns
    if new_turns:
        new_text = "\n\n".join(f"{r}: {t}" for r, t in new_turns)
        content  = content.rstrip("\n") + f"\n\n{new_text}\n"
    log_path.write_text(content)
else:
    ts          = datetime.now().strftime("%Y-%m-%d-%H%M")
    model_short = model.replace("claude-", "").replace("-latest", "")
    relaunch    = f"claude --resume {session_id}" if session_id else path
    summary     = last_msg or f"session {ts}"
    body        = "\n\n".join(f"{r}: {t}" for r, t in new_turns)
    log_path    = sessions_dir / f"session-{session_id[:8]}-{ts}.md"
    log_path.write_text(
        f"---\n"
        f"summary: {summary}\n"
        f"date: {date.today().isoformat()}\n"
        f"relaunch: {relaunch}\n"
        f"model: {model_short}\n"
        f"cost: ${cost:.2f}\n"
        f"---\n\n"
        f"{body}\n"
    )

cursor_file.write_text(str(new_cursor))
