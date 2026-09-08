#!/usr/bin/env python3
"""Merge an OpenCode JSON template into dest without clobbering secrets."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


def load(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def is_placeholder_key(value: Any) -> bool:
    if not isinstance(value, str):
        return True
    stripped = value.strip()
    return stripped == "" or stripped.startswith("{env:")


def merge_provider(dest: dict[str, Any], template: dict[str, Any]) -> dict[str, Any]:
    merged = dict(dest)
    for provider_id, t_prov in template.items():
        if not isinstance(t_prov, dict):
            merged[provider_id] = t_prov
            continue
        d_prov = dest.get(provider_id)
        if not isinstance(d_prov, dict):
            merged[provider_id] = t_prov
            continue
        out = dict(t_prov)
        d_opts = d_prov.get("options") if isinstance(d_prov.get("options"), dict) else {}
        t_opts = t_prov.get("options") if isinstance(t_prov.get("options"), dict) else {}
        opts = dict(t_opts)
        dest_key = d_opts.get("apiKey")
        if dest_key and not is_placeholder_key(dest_key):
            opts["apiKey"] = dest_key
        if d_opts.get("baseURL") and not t_opts.get("baseURL"):
            opts["baseURL"] = d_opts["baseURL"]
        out["options"] = opts
        d_models = d_prov.get("models") if isinstance(d_prov.get("models"), dict) else {}
        t_models = t_prov.get("models") if isinstance(t_prov.get("models"), dict) else {}
        models = dict(d_models)
        models.update(t_models)
        if models:
            out["models"] = models
        merged[provider_id] = out
    return merged


def merge(dest: dict[str, Any], template: dict[str, Any]) -> dict[str, Any]:
    out = dict(dest)
    for key, value in template.items():
        if key == "provider":
            out["provider"] = merge_provider(
                dest.get("provider") if isinstance(dest.get("provider"), dict) else {},
                value if isinstance(value, dict) else {},
            )
            continue
        if key == "agent":
            agents = dict(dest.get("agent") if isinstance(dest.get("agent"), dict) else {})
            if isinstance(value, dict):
                for agent_id, template_agent in value.items():
                    existing_agent = agents.get(agent_id)
                    if isinstance(existing_agent, dict) and isinstance(template_agent, dict):
                        merged_agent = dict(existing_agent)
                        merged_agent.update(template_agent)
                        agents[agent_id] = merged_agent
                    else:
                        agents[agent_id] = template_agent
            out["agent"] = agents
            continue
        if key == "instructions":
            existing = dest.get("instructions") if isinstance(dest.get("instructions"), list) else []
            extra = value if isinstance(value, list) else []
            seen: list[str] = []
            for item in list(extra) + list(existing):
                if item not in seen:
                    seen.append(item)
            out["instructions"] = seen
            continue
        out[key] = value
    return out


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: merge-opencode-json.py TEMPLATE DEST", file=sys.stderr)
        return 2
    template_path = Path(sys.argv[1])
    dest_path = Path(sys.argv[2])
    template = load(template_path)
    if dest_path.exists():
        dest = load(dest_path)
        merged = merge(dest, template)
    else:
        merged = template
        dest_path.parent.mkdir(parents=True, exist_ok=True)
    dest_path.write_text(json.dumps(merged, indent=2) + "\n", encoding="utf-8")
    print(f"Merged {template_path} -> {dest_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
