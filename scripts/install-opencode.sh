#!/usr/bin/env bash
# Installs one or more repository plugins into OpenCode's native directories.
#
# Examples:
#   ./scripts/install-opencode.sh
#   ./scripts/install-opencode.sh --plugin pstack --scope project
#   ./scripts/install-opencode.sh --plugin cursor-team-kit --plugin thermos
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
plugins=()
scope="global"
destination=""

usage() {
  cat <<'EOF'
Usage: install-opencode.sh [--plugin NAME]... [--scope global|project] [--destination PATH]

Plugins (default: cursor-team-kit, pstack, thermos):
  --plugin NAME            install one plugin (repeatable)

Options:
  --scope global|project   global -> ~/.config/opencode (default)
                           project -> ./.opencode in the current directory
  --destination PATH       override install root
  -h, --help               show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --plugin)
      plugins+=("${2:?--plugin requires a name}")
      shift 2
      ;;
    --scope)
      scope="${2:?--scope requires global or project}"
      shift 2
      ;;
    --destination)
      destination="${2:?--destination requires a path}"
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

if [[ -z "$destination" ]]; then
  if [[ "$scope" == "project" ]]; then
    destination="$(pwd)/.opencode"
  else
    destination="${HOME}/.config/opencode"
  fi
fi

copy_plugin_directory() {
  local source_dir="$1"
  local target_dir="$2"
  local label="$3"

  if [[ ! -d "$source_dir" ]]; then
    return 0
  fi

  mkdir -p "$target_dir"
  cp -R "$source_dir"/. "$target_dir"/
  echo "Installed $label -> $target_dir"
}

for name in "${plugins[@]}"; do
  case "$name" in
    cursor-team-kit|pstack|thermos) ;;
    *)
      echo "Unknown plugin: $name" >&2
      exit 1
      ;;
  esac

  plugin_root="${repository_root}/${name}"
  if [[ ! -d "$plugin_root" ]]; then
    echo "Missing plugin directory: $plugin_root" >&2
    exit 1
  fi

  copy_plugin_directory "${plugin_root}/skills" "${destination}/skills" "${name} skills"
  copy_plugin_directory "${plugin_root}/opencode/agent" "${destination}/agents" "${name} agents"
done

echo "Installed ${plugins[*]} in ${destination}"
echo "Restart OpenCode to load the new skills and agents."
