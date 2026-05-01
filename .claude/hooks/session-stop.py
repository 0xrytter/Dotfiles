#!/usr/bin/env python3
import json
import sys
import hashlib
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from cost_calc import calc_cost

SESSIONS = Path.home() / ".claude" / "sessions"
SESSIONS.mkdir(exist_ok=True)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

model = data.get("model", {}).get("id", "unknown")
path  = data.get("transcript_path") or ""

cost = calc_cost(path, model) or (data.get("cost") or {}).get("total_cost_usd") or 0

if not path or not cost:
    sys.exit(0)

now          = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
session_file = SESSIONS / (hashlib.md5(path.encode()).hexdigest()[:16] + ".json")
started_at   = now

if session_file.exists():
    try:
        started_at = json.loads(session_file.read_text()).get("started_at", now)
    except Exception:
        pass


def count_messages(p):
    try:
        return sum(
            1 for line in Path(p).read_text().splitlines()
            if json.loads(line).get("type") == "user"
        )
    except Exception:
        return 0


session_file.write_text(json.dumps({
    "transcript_path": path,
    "model": model,
    "started_at": started_at,
    "updated_at": now,
    "cost_usd": cost,
    "message_count": count_messages(path),
    "is_final": True,
}))
