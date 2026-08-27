#!/usr/bin/env bash
# Installs one or more repository plugins into Claude Code from the local marketplace.
#
# Examples:
#   ./scripts/install-claude.sh
#   ./scripts/install-claude.sh --plugin pstack --plugin thermos
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugins=()
marketplace="agent-plugins"
marketplace_path="${repository_root}"

usage() {
  cat <<'EOF'
Usage: install-claude.sh [--plugin NAME]... [--marketplace NAME] [--marketplace-path PATH]

Plugins (default: cursor-team-kit, pstack, thermos):
  --plugin NAME            install one plugin (repeatable)

Options:
  --marketplace NAME        marketplace id (default: agent-plugins)
  --marketplace-path PATH   path to marketplace root (default: repository root)
  -h, --help                show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --plugin)
      plugins+=("${2:?--plugin requires a name}")
      shift 2
      ;;
    --marketplace)
      marketplace="${2:?--marketplace requires a name}"
      shift 2
      ;;
    --marketplace-path)
      marketplace_path="${2:?--marketplace-path requires a path}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ${#plugins[@]} -eq 0 ]]; then
  plugins=(cursor-team-kit pstack thermos)
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found. Install Claude Code first: https://code.claude.com" >&2
  exit 1
fi

marketplaces="$(claude plugin marketplace list 2>&1 || true)"
if ! grep -q "$marketplace" <<<"$marketplaces"; then
  claude plugin marketplace add "$marketplace_path"
else
  claude plugin marketplace update "$marketplace"
fi

installed="$(claude plugin list 2>&1 || true)"
for name in "${plugins[@]}"; do
  case "$name" in
    cursor-team-kit|pstack|thermos) ;;
    *)
      echo "Unknown plugin: $name" >&2
      exit 1
      ;;
  esac

  plugin_id="${name}@${marketplace}"
  if grep -q "$plugin_id" <<<"$installed"; then
    claude plugin update "$plugin_id"
  else
    claude plugin install "$plugin_id"
  fi
done

echo "Installed ${plugins[*]} from ${marketplace}."
echo "Restart Claude Code to load the new skills and agents."
