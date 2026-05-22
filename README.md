# my-claude-skills

Portable Claude Code config — plugins, skills, hooks, status line. Clone on any machine and run `./install.sh`.

## Quick setup

```bash
git clone https://github.com/mytricker0/my-claude-skills.git
cd my-claude-skills
chmod +x install.sh
./install.sh
# Restart Claude Code
```

## What's included

- **Plugins:** superpowers, caveman, frontend-design, code-review, github
- **Skills:** synced from `sickn33/antigravity-awesome-skills` (600+ skills in `skills/`)
- **Hooks:** graphify session tracker (`config/hooks/graphify-tracker.js`)
- **Status line:** model, context %, rate limits, caveman/graphify badges (`config/statusline-command.sh`)
- **CLAUDE.md:** global user instructions (`config/CLAUDE.md`)

## Marketplaces registered

| Name | Repo |
|------|------|
| claude-plugins-official | `anthropics/claude-plugins-official` |
| antigravity | `sickn33/antigravity-awesome-skills` |
| caveman | `JuliusBrussee/caveman` |

## Updating skills

GitHub Actions syncs skills every Monday 6am UTC. To sync manually:

> Actions → **Sync Skills from Upstream** → Run workflow

## Adding plugins

Edit `install.sh`, add a line:

```bash
claude plugin install <name>@<marketplace> --scope user 2>/dev/null || true
```

Also add to `config/settings.template.json` under `enabledPlugins`.