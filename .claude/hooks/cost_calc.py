"""Shared cost calculation — pricing.json + transcript token counts."""
import json
from pathlib import Path

PRICING_FILE = Path.home() / ".claude" / "pricing.json"


def get_prices(model_id):
    try:
        pricing = json.loads(PRICING_FILE.read_text())
    except Exception:
        return None
    if model_id in pricing:
        return pricing[model_id]
    for key, val in pricing.items():
        if key.startswith("_"):
            continue
        if model_id.startswith(key) or key.startswith(model_id):
            return val
    return None


def _iter_turns(transcript_path):
    """Yield unique (inp, c5m, c1h, cr, out) tuples from assistant messages."""
    p = Path(transcript_path)
    if not p.exists():
        return
    seen = set()
    for line in p.read_text().splitlines():
        try:
            obj = json.loads(line)
            if obj.get("type") != "assistant":
                continue
            usage = obj.get("message", {}).get("usage", {})
            if not usage or "output_tokens" not in usage:
                continue
            cc = usage.get("cache_creation", {})
            key = (
                usage.get("input_tokens", 0),
                cc.get("ephemeral_5m_input_tokens", 0),
                cc.get("ephemeral_1h_input_tokens", 0),
                usage.get("cache_read_input_tokens", 0),
                usage.get("output_tokens", 0),
            )
            if key in seen:
                continue
            seen.add(key)
            yield key
        except Exception:
            continue


def calc_cost(transcript_path, model_id):
    """Calculate session cost from transcript token counts + pricing.json.
    Returns None if transcript is unreadable or model has no pricing entry."""
    prices = get_prices(model_id)
    if not prices or not transcript_path:
        return None

    total_in = total_5m = total_1h = total_cr = total_out = 0
    for inp, c5m, c1h, cr, out in _iter_turns(transcript_path):
        total_in  += inp
        total_5m  += c5m
        total_1h  += c1h
        total_cr  += cr
        total_out += out

    m = 1_000_000
    return (
        total_in  * prices["input"]          / m +
        total_5m  * prices["cache_write_5m"] / m +
        total_1h  * prices["cache_write_1h"] / m +
        total_cr  * prices["cache_read"]     / m +
        total_out * prices["output"]         / m
    )



