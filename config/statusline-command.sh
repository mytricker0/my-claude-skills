#!/bin/sh
# Claude Code statusLine command
# Derived from ~/.bashrc PS1: \[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
rl5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

# Build optional context info
ctx=""
if [ -n "$used" ]; then
  ctx=" ctx:$(printf '%.0f' "$used")%"
fi

# Build rate limit info
rl=""
if [ -n "$rl5h" ] && [ -n "$rl7d" ]; then
  rl=$(printf ' | 5h:%d%% 7d:%d%%' "$rl5h" "$rl7d")
elif [ -n "$rl5h" ]; then
  rl=$(printf ' | 5h:%d%%' "$rl5h")
elif [ -n "$rl7d" ]; then
  rl=$(printf ' | 7d:%d%%' "$rl7d")
fi

# Build optional model info
mdl=""
if [ -n "$model" ]; then
  mdl="$model"
fi

# Caveman badge — read flag file directly (avoids version-hash path dependency)
caveman_badge=""
CAVEMAN_FLAG="${CLAUDE_DIR}/.caveman-active"
if [ -f "$CAVEMAN_FLAG" ] && [ ! -L "$CAVEMAN_FLAG" ]; then
  MODE=$(head -c 64 "$CAVEMAN_FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
  MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
  case "$MODE" in
    off|lite|full|ultra|wenyan-lite|wenyan|wenyan-full|wenyan-ultra|commit|review|compress)
      if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
        caveman_badge=$(printf ' \033[38;5;172m[CAVEMAN]\033[0m')
      else
        SUFFIX=$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')
        caveman_badge=$(printf ' \033[38;5;172m[CAVEMAN:%s]\033[0m' "$SUFFIX")
      fi
      ;;
  esac
fi

# Graphify badge
graphify_badge=""
GRAPHIFY_FLAG="${CLAUDE_DIR}/.graphify-active"
if [ -f "$GRAPHIFY_FLAG" ] && [ ! -L "$GRAPHIFY_FLAG" ]; then
  graphify_badge=$(printf ' \033[38;5;75m[GRAPHIFY]\033[0m')
fi

printf '%s%s%s%s%s\n' "$mdl" "$ctx" "$rl" "$caveman_badge" "$graphify_badge"
