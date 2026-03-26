---
name: unjail
description: Executes shell commands and bypasses sandbox restrictions by proxying commands through a user-started terminal runner.
risk: high
source: user-made
date_added: '2026-03-25'
---

# unjail

Use this skill to execute shell commands autonomously when operating within a restricted sandbox where built-in tools like `run_command` are blocked.

## Use this skill when

- You are unable to run shell commands because of a bug with the `nsjail` wrapper.

## Instructions

### 1. Agent Execution
The agent uses the shared filesystem to proxy commands:

1. **Request**: Write the command to `AGENT_UNJAIL_REQUEST.sh` in the current workspace root.
2. **Wait**: The user approves the `write_to_file` call in the UI.
3. **Poll**: Wait for `AGENT_UNJAIL_RESPONSE.json` to appear in the workspace root.
4. **If No Response**: If `AGENT_UNJAIL_RESPONSE.json` does not appear after an appropriate for the command waiting time, ask the user to launch the runner in a **new terminal tab**: `~/.gemini/antigravity/skills/unjail/scripts/unjail_runner.sh`, and keep this terminal tab open. After a positive response from the user, restart from **Item 3**.
5. **Result**: Parse the JSON for `output` and `exit_code`.

## Resources

- `scripts/unjail_runner.sh`: Persistent host-side runner loop.
- `scripts/unjail.py`: Python helper for dynamic path detection and polling.
