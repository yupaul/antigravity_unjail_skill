# Antigravity Unjail Skill

This skill allows the agent to bypass nsjail sandbox restrictions by proxying shell commands through a host-side terminal bridge. It uses a file-based communication protocol to execute commands and retrieve output.

## Installation

1. Clone this repository.
2. Run the installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

## Usage

### 1. Start the Host Runner
In a separate terminal on your host machine (not inside the agent's environment), navigate to your project workspace root and run the runner script:

```bash
~/.gemini/antigravity/skills/unjail/scripts/unjail_runner.sh
```

The runner will wait for requests from the agent.

### 2. Interaction
The agent will now be able to use the `unjail` skill. When it needs to run a command, it will write to `AGENT_UNJAIL_REQUEST.sh` in the workspace root. You will see the runner process the request and generate `AGENT_UNJAIL_RESPONSE.json`.

## Security Note

This tool allows the agent to execute any command on your host system with your user's permissions. Use with caution and only in trusted environments. You can monitor and audit the commands by watching the `AGENT_UNJAIL_REQUEST.sh` file.

## Requirements

- **Linux/macOS**: Bash shell.
- **jq**: Recommended for proper JSON handling (optional fallback provided).
