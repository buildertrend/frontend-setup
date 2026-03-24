#!/usr/bin/env bash
# Detect OS and install prerequisites for BTNet frontend development.
# Designed to be called by Claude during the setup flow.

set -e

OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
  OS="windows"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Check for WSL
  if grep -qEi "(microsoft|wsl)" /proc/version 2>/dev/null; then
    OS="windows"
  else
    OS="linux"
  fi
fi

echo "OS=$OS"

# Check admin privileges on Mac
if [ "$OS" = "mac" ]; then
  if id -Gn | grep -q admin; then
    echo "ADMIN: yes"
  else
    echo "ADMIN: no"
  fi
fi

# Check each prerequisite
check() {
  local name="$1"
  local cmd="$2"
  if command -v "$cmd" &>/dev/null; then
    echo "FOUND: $name ($($cmd --version 2>&1 | head -1))"
    return 0
  else
    echo "MISSING: $name"
    return 1
  fi
}

if [ "$OS" = "mac" ]; then
  # Xcode CLI tools
  if xcode-select -p &>/dev/null; then
    echo "FOUND: Xcode Command Line Tools"
  else
    echo "MISSING: Xcode Command Line Tools"
  fi
fi

check "Git" "git" || true
check "Homebrew" "brew" || true
check "fnm" "fnm" || true
check "Node.js" "node" || true
check "pnpm" "pnpm" || true
