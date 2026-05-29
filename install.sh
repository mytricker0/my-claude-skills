#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

echo "Installing Claude Code config from $REPO_DIR..."

# Backup existing settings
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak"
  echo "Backed up existing settings.json"
fi

# Create dirs
mkdir -p "$CLAUDE_DIR/hooks" "$CLAUDE_DIR/skills"

# Copy config files
cp "$REPO_DIR/config/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
cp "$REPO_DIR/config/statusline-command.sh" "$CLAUDE_DIR/statusline-command.sh"
chmod +x "$CLAUDE_DIR/statusline-command.sh"
cp "$REPO_DIR/config/hooks/graphify-tracker.js" "$CLAUDE_DIR/hooks/graphify-tracker.js"

# Copy skills (if synced)
if [ -d "$REPO_DIR/skills" ] && [ "$(ls -A "$REPO_DIR/skills" 2>/dev/null)" ]; then
  cp -r "$REPO_DIR/skills/." "$CLAUDE_DIR/skills/"
  echo "Copied skills to $CLAUDE_DIR/skills/"
fi

# Generate settings.json from template
sed "s|__CLAUDE_DIR__|$CLAUDE_DIR|g" "$REPO_DIR/config/settings.template.json" > "$CLAUDE_DIR/settings.json"
echo "Generated settings.json"

# Register marketplaces
echo "Registering marketplaces..."
claude plugin marketplace add anthropics/claude-plugins-official --scope user 2>/dev/null || true
claude plugin marketplace add sickn33/antigravity-awesome-skills --scope user 2>/dev/null || true
claude plugin marketplace add JuliusBrussee/caveman --scope user 2>/dev/null || true
claude plugin marketplace add forrestchang/andrej-karpathy-skills --scope user 2>/dev/null || true

# Install plugins
echo "Installing plugins..."
claude plugin install superpowers@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install frontend-design@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install github@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install code-review@claude-plugins-official --scope user 2>/dev/null || true
claude plugin install caveman@caveman --scope user 2>/dev/null || true
claude plugin install andrej-karpathy-skills@karpathy-skills --scope user 2>/dev/null || true

# Graphify skill — manual setup required
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Graphify — install manually:"
echo ""
echo "  1. Install the CLI:"
echo "     uv tool install graphifyy"
echo "     # or: pipx install graphifyy"
echo ""
echo "  2. Install the Claude Code skill:"
echo "     graphify install"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "Done. Restart Claude Code."
