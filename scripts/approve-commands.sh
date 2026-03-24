#!/usr/bin/env bash
# Auto-approve safe commands for non-technical users during frontend setup.
# This prevents them from being bombarded with permission prompts.

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool // empty')
COMMAND=$(echo "$INPUT" | jq -r '.input.command // empty')

approve() {
  echo '{"decision":"approve","reason":"auto-approved by buildertrend-frontend-setup plugin"}'
  exit 0
}

# Auto-approve read-only tools
case "$TOOL" in
  Read|Glob|Grep)
    approve
    ;;
esac

# Auto-approve safe bash commands
if [ "$TOOL" = "Bash" ] && [ -n "$COMMAND" ]; then
  # Extract the base command (first word)
  BASE_CMD=$(echo "$COMMAND" | awk '{print $1}')

  case "$BASE_CMD" in
    # OS detection and info
    uname|sw_vers|cat|echo|printf|test|"[")
      approve
      ;;
    # File operations
    ls|pwd|cd|mkdir|cp|touch|head|tail|wc)
      approve
      ;;
    # Prerequisite checks and installs
    xcode-select|brew|fnm|node|npm|npx|pnpm|corepack)
      approve
      ;;
    # Git operations
    git)
      approve
      ;;
    # System utilities
    which|command|type|env|printenv)
      approve
      ;;
    # Package installation (Mac)
    sudo)
      # Only approve sudo for specific safe commands
      SUDO_CMD=$(echo "$COMMAND" | awk '{print $2}')
      case "$SUDO_CMD" in
        pnpm|corepack|chown)
          approve
          ;;
      esac
      ;;
    # Shell config
    source|.)
      approve
      ;;
  esac

  # Approve rm only for node_modules cleanup
  if echo "$COMMAND" | grep -qE '^rm -rf node_modules'; then
    approve
  fi
fi

# Auto-approve file writes within the BTNet repo
if [ "$TOOL" = "Write" ] || [ "$TOOL" = "Edit" ]; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.input.file_path // empty')
  if echo "$FILE_PATH" | grep -q "BTNet"; then
    approve
  fi
fi

# If we get here, don't auto-approve — let the user decide
echo '{"decision":"ask_user","reason":"command not in auto-approve whitelist"}'
