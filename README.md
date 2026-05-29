# my-claude-skills

Auto-synced Claude Code skills, plugins, hooks, and status line. Clone on any machine and run `./install.sh` to get your full setup.

## Quick start

```bash
git clone https://github.com/mytricker0/my-claude-skills.git
cd my-claude-skills
chmod +x install.sh
./install.sh
# Restart Claude Code
```

## What gets installed

### Plugins

| Plugin | Source | What it does |
|--------|--------|--------------|
| `superpowers` | claude-plugins-official | Skill invocation system, plan mode, parallel agents |
| `caveman` | caveman | Terse caveman response mode (`/caveman`) |
| `frontend-design` | claude-plugins-official | UI/UX design patterns |
| `code-review` | claude-plugins-official | Inline PR review comments |
| `github` | claude-plugins-official | GitHub automation |
| `andrej-karpathy-skills` | forrestchang/andrej-karpathy-skills | Karpathy-style AI/ML guidelines |

### Skills

~1455 skills synced weekly from [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) into `skills/`. Covers AI engineering, frontend, backend, DevOps, security, SEO, and more.

### Hooks

| Hook | File | What it does |
|------|------|--------------|
| Graphify tracker | `config/hooks/graphify-tracker.js` | Writes flag file when `/graphify` is active — powers the statusline badge |

> **Graphify setup (manual):** The hook is installed automatically but the skill and CLI must be set up by hand:
> ```bash
> uv tool install graphifyy   # or: pipx install graphifyy
> graphify install
> ```

### Status line

`config/statusline-command.sh` — shows model, context %, rate limits, caveman mode badge, and graphify badge in the Claude Code status bar.

### Config

- `config/CLAUDE.md` → `~/.claude/CLAUDE.md` — global user instructions
- `config/settings.template.json` → `~/.claude/settings.json` — permissions, hooks, enabled plugins

## Marketplaces registered

| Name | GitHub repo |
|------|-------------|
| claude-plugins-official | `anthropics/claude-plugins-official` |
| antigravity | `sickn33/antigravity-awesome-skills` |
| caveman | `JuliusBrussee/caveman` |
| andrej-karpathy-skills | `forrestchang/andrej-karpathy-skills` |

## Keeping skills up to date

GitHub Actions syncs skills from antigravity every Monday at 6am UTC.

Manual sync: **Actions → Sync Skills from Upstream → Run workflow**

## Adding plugins

1. Edit `install.sh`, add:

```bash
claude plugin install <name>@<marketplace> --scope user 2>/dev/null || true
```

2. Add to `config/settings.template.json` under `enabledPlugins`.

## Adding your own skills

Drop a folder into `skills/<skill-name>/` with a `SKILL.md` inside. It will be copied to `~/.claude/skills/` on install.

```
skills/
  my-skill/
    SKILL.md
```

## Personal / private config

This repo is public — keep personal API keys, custom instructions, or private skills in a separate private repo. See [GitHub docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories#about-repository-visibility) — GitHub does not support private branches in public repos.
