#!/usr/bin/env bash
# PermissionRequest hook — auto-approves safe tool calls for frontend setup.
# Falls through to normal permission prompt for anything not explicitly allowed.

set -euo pipefail

INPUT=$(cat)

# Parse JSON fields from stdin. Try node first, fall back to jq.
parse_field() {
  local field="$1"
  if command -v node &>/dev/null; then
    echo "$INPUT" | node -e "
      let d=''; process.stdin.on('data',c=>d+=c); process.stdin.on('end',()=>{
        try {
          const val = '$field'.split('.').reduce((o,k)=>o&&o[k], JSON.parse(d));
          process.stdout.write(String(val||''));
        } catch(e) { process.exit(1); }
      });
    " 2>/dev/null
  elif command -v jq &>/dev/null; then
    echo "$INPUT" | jq -r ".$field // empty" 2>/dev/null
  else
    return 1
  fi
}

TOOL=$(parse_field "tool_name") || exit 1
[ -z "$TOOL" ] && exit 1

approve() {
  cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow","message":"auto-approved by frontend-setup plugin"}}}
EOF
  exit 0
}

# --- Read-only tools: approve within BTNet, passthrough otherwise ---
case "$TOOL" in
  Read)
    TARGET=$(parse_field "tool_input.file_path") || true
    if [ -n "$TARGET" ] && echo "$TARGET" | grep -q "BTNet"; then approve; fi
    exit 0
    ;;
  Glob|Grep)
    TARGET=$(parse_field "tool_input.path") || true
    if [ -n "$TARGET" ] && echo "$TARGET" | grep -q "BTNet"; then approve; fi
    exit 0
    ;;
esac

# --- File writes: approve within BTNet, passthrough otherwise ---
case "$TOOL" in
  Write|Edit)
    FILE_PATH=$(parse_field "tool_input.file_path") || true
    if [ -n "$FILE_PATH" ] && echo "$FILE_PATH" | grep -q "BTNet"; then
      approve
    fi
    exit 0
    ;;
esac

# --- Bash commands ---
if [ "$TOOL" != "Bash" ]; then
  exit 0
fi

COMMAND=$(parse_field "tool_input.command") || exit 1
[ -z "$COMMAND" ] && exit 1

# --- Dangerous patterns: passthrough (let user decide) ---
if echo "$COMMAND" | grep -qE '\$\(|`'; then exit 0; fi
if echo "$COMMAND" | grep -qE '\beval\b'; then exit 0; fi
if echo "$COMMAND" | grep -qE '[><]'; then exit 0; fi
if echo "$COMMAND" | grep -qE '\\n'; then exit 0; fi

# --- Compound commands: approve known-safe patterns, passthrough the rest ---
if echo "$COMMAND" | grep -qE '[;|&]'; then
  case "$COMMAND" in
    "id -Gn | grep -q admin")                              approve ;;
    "rm -rf node_modules && pnpm install")                  approve ;;
    "pnpm run setup-btfeedauth-crossplatform && pnpm install") approve ;;
    *" | pbcopy"*) approve ;;
    *" | clip"*) approve ;;
  esac
  exit 0
fi

# --- Extract command name, stripping env var prefixes (e.g. NONINTERACTIVE=1) ---
CMD_LINE=$(echo "$COMMAND" | sed 's/^[[:space:]]*//')
while echo "$CMD_LINE" | grep -qE '^[A-Za-z_][A-Za-z_0-9]*=[^ ]* '; do
  CMD_LINE=$(echo "$CMD_LINE" | sed 's/^[A-Za-z_][A-Za-z_0-9]*=[^ ]* *//')
done
CMD_FIRST=$(echo "$CMD_LINE" | cut -d' ' -f1)

case "$CMD_FIRST" in
  # OS detection and info
  uname|sw_vers|cat|echo|printf|test|"[")
    ;;
  # File operations
  ls|pwd|cd|mkdir|cp|touch|head|tail|wc|grep)
    ;;
  # Prerequisite checks and installs
  xcode-select|brew|fnm|npm|npx|pnpm|corepack)
    ;;
  node)
    if echo "$COMMAND" | grep -qE '(^|\s)(-e|--eval)(\s|$)'; then
      exit 0
    fi
    ;;
  # Git operations
  git)
    ;;
  # System utilities
  which|command|type|printenv)
    ;;
  # Shell config
  source|.)
    ;;
  # Package installation (Mac)
  sudo)
    SUDO_CMD=$(echo "$COMMAND" | awk '{print $2}')
    case "$SUDO_CMD" in
      pnpm|corepack|chown)
        ;;
      *)
        exit 0
        ;;
    esac
    ;;
  # Network utilities
  curl|wget|lsof|netstat)
    ;;
  bash)
    if [ "$CMD_LINE" = "bash" ]; then exit 0; fi
    if echo "$CMD_LINE" | grep -qE '(^|\s)-c(\s|$)'; then exit 0; fi
    ;;
  rm)
    # Only approve rm for node_modules cleanup
    if echo "$COMMAND" | grep -qE '^rm -rf node_modules'; then
      approve
    fi
    exit 0
    ;;
  *)
    exit 0
    ;;
esac

approve
