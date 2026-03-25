# unjail.py
# Use this helper to send commands through the unjail runner.
import os
import time
import json

# Detects workspace root dynamically
def get_workspace_root():
    # Primary: use the current working directory (usually the workspace root)
    return os.getcwd()

def run_via_unjail(cmd_str, timeout=30):
    root = get_workspace_root()
    request_path = os.path.join(root, "AGENT_UNJAIL_REQUEST.sh")
    response_path = os.path.join(root, "AGENT_UNJAIL_RESPONSE.json")

    # Ensure unjail is clear
    if os.path.exists(response_path):
        os.remove(response_path)
        
    # Write request
    with open(request_path, "w") as f:
        f.write("#!/bin/bash\n")
        f.write(cmd_str + "\n")
        
    # Poll for response
    start_time = time.time()
    while time.time() - start_time < timeout:
        if os.path.exists(response_path):
            try:
                with open(response_path, "r") as f:
                    return json.load(f)
            except json.JSONDecodeError:
                pass # Still writing?
        time.sleep(0.5)
    
    return {"error": "Timeout waiting for unjail response", "exit_code": -1}

if __name__ == "__main__":
    # Self-test
    res = run_via_unjail("whoami && pwd")
    print(json.dumps(res, indent=2))
