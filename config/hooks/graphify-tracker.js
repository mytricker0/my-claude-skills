#!/usr/bin/env node
// Tracks /graphify invocations and writes a flag file for the statusline badge.

const fs = require('fs');
const path = require('path');
const os = require('os');

const claudeDir = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
const flagPath = path.join(claudeDir, '.graphify-active');

let input = '';
process.stdin.on('data', chunk => { input += chunk; });
process.stdin.on('end', () => {
  try {
    const data = JSON.parse(input);
    const prompt = (data.prompt || '').trim();

    const deactivate = /\b(stop|off|disable|deactivate)\b.*\bgraphify\b/i.test(prompt) ||
                       /\bgraphify\b.*\b(stop|off|disable|deactivate)\b/i.test(prompt);

    const activate = /^\s*\/graphify\b/i.test(prompt);

    if (deactivate) {
      try { fs.unlinkSync(flagPath); } catch (e) {}
    } else if (activate) {
      if (!fs.existsSync(flagPath) || !fs.lstatSync(flagPath).isSymbolicLink()) {
        fs.writeFileSync(flagPath, 'active', { mode: 0o600 });
      }
    }
  } catch (e) {}
});
