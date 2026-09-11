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
stale_agents=(coding-agent.md review-agent.md)

usage() {
  cat <<'EOF'
Usage: install-opencode.sh [--plugin NAME]... [--scope global|project] [--destination PATH]

Plugins (default: cursor-team-kit, pstack, thermos, opencode-workflow):
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

case "$scope" in
  global|project) ;;
  *)
    echo "Invalid scope: $scope. Expected global or project." >&2
    exit 1
    ;;
esac

if [[ ${#plugins[@]} -eq 0 ]]; then
  plugins=(cursor-team-kit pstack thermos opencode-workflow)
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

python_bin=""
if command -v python >/dev/null 2>&1; then
  python_bin="python"
elif command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
fi

for name in "${plugins[@]}"; do
  case "$name" in
    cursor-team-kit|pstack|thermos|opencode-workflow) ;;
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
  copy_plugin_directory "${plugin_root}/opencode/command" "${destination}/commands" "${name} commands"

  if [[ -f "${plugin_root}/WORKFLOW.md" ]]; then
    mkdir -p "$destination"
    cp "${plugin_root}/WORKFLOW.md" "${destination}/WORKFLOW.md"
    echo "Installed ${name} WORKFLOW.md -> ${destination}/WORKFLOW.md"
  fi

  if [[ -f "${plugin_root}/opencode.json.template" ]]; then
    if [[ -z "$python_bin" ]]; then
      echo "python is required to merge opencode.json.template" >&2
      exit 1
    fi
    "$python_bin" "${repository_root}/scripts/merge-opencode-json.py" \
      "${plugin_root}/opencode.json.template" \
      "${destination}/opencode.json"
  fi

  if [[ "$scope" == "global" && -f "${plugin_root}/models.conf.example" ]]; then
    models_dest="${HOME}/.pstack/models.conf"
    if [[ ! -f "$models_dest" ]]; then
      mkdir -p "${HOME}/.pstack"
      cp "${plugin_root}/models.conf.example" "$models_dest"
      echo "Installed pstack models.conf -> $models_dest"
    fi
  fi
done

if [[ -d "${destination}/agents" ]]; then
  for stale in "${stale_agents[@]}"; do
    if [[ -f "${destination}/agents/${stale}" ]]; then
      rm -f "${destination}/agents/${stale}"
      echo "Removed stale agent ${stale}"
    fi
  done
fi

echo "Installed ${plugins[*]} in ${destination}"
if [[ " ${plugins[*]} " == *" opencode-workflow "* ]]; then
  echo "Configure your provider and run /setup-pstack to select models for workflow roles."
fi
echo "Restart OpenCode to load the new skills, agents, and commands."
