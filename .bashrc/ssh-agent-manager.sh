#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
##=============================================================================
## SSH Agent Manager
##
## Author:        Paul PERRIER <paul@perrier.dev>
## Created:       2025-07-26
## Version:       1.0.0
##
## Description:
##   Provides lazy-loaded SSH agent management for Git Bash (Windows) or Unix.
##   Ensures a single persistent agent per session, with helper functions to
##   start, restart, and manage keys.
##
## Usage:
##   - Source this script in ~/.bashrc:
##         source /path/to/ssh-agent-manager.sh
##
## Notes:
##   - Compatible with Git Bash and most Unix shells.
##   - Kills unmanaged ssh-agent processes.
##   - Stores agent environment in ~/.ssh/agent.env for reuse across tabs.
##
## Tips:
##   - To persist SSH keys, add "AddKeysToAgent yes" in ~/.ssh/config
##     under each desired keys (or under "Host *").
##     Example:
##         Host github.com
##           PreferredAuthentications publickey
##           IdentityFile ~/.ssh/id_my_private_key
##           AddKeysToAgent yes
##   - On Windows, prefer using wincred as credential manager for git:
##         git config --global credential.helper wincred
##
## Modifications:
##   - 2025-07-29 (v1.0.0): Paul PERRIER <paul@perrier.dev>
##       Initial release.
##
## Copyright (c) 2025 Paul PERRIER <paul@perrier.dev>
## Licensed under the Apache License, Version 2.0.
## See LICENSE file or http://www.apache.org/licenses/LICENSE-2.0 for details.
##==============================================================================

AGENT_FILE="$HOME/.ssh/agent.env"

# Starts a managed instance
_ssh-agent-manager_start() {
  ssh-agent-manager_stop-unmanaged
  echo "[SSH Agent] starting agent..."
  eval "$(ssh-agent -s)" > /dev/null
  echo "[SSH Agent] started agent (PID: $SSH_AGENT_PID)"
  echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > "$AGENT_FILE"
  echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> "$AGENT_FILE"
  chmod 600 "$AGENT_FILE"
}

# Checks if a managed instance exists
ssh-agent-manager_is-alive() {
  [ -n "$SSH_AUTH_SOCK" ] && ps -p "$SSH_AGENT_PID" >/dev/null 2>&1
}

# Ensures a managed instance exists
ssh-agent-manager_ensure() {
  if ! ssh-agent-manager_is-alive; then
    if [ -f "$AGENT_FILE" ]; then
      . "$AGENT_FILE" >/dev/null
      if ! ssh-agent-manager_is-alive; then
        _ssh-agent-manager_start
      else
        echo "[SSH Agent] reusing existing agent (PID: $SSH_AGENT_PID)"
      fi
    else
      _ssh-agent-manager_start
    fi
  else
    echo "[SSH Agent] reusing existing agent (PID: $SSH_AGENT_PID)"
  fi
}

# Stops the managed instance
ssh-agent-manager_stop() {
  if [ -f "$AGENT_FILE" ]; then
    . "$AGENT_FILE" >/dev/null
    if ps -p "$SSH_AGENT_PID" >/dev/null 2>&1; then
      echo "[SSH Agent] stopping (PID: $SSH_AGENT_PID)..."
      kill "$SSH_AGENT_PID"
    fi
    rm -f "$AGENT_FILE"
  fi
}

# Stops all unmanaged instances
ssh-agent-manager_stop-unmanaged() {
  ps -ef | grep [s]sh-agent | awk '{print $2}' | while read -r pid; do
    if [ "$pid" != "$SSH_AGENT_PID" ]; then
      echo "[SSH Agent] killing unmanaged agent (PID: $pid)..."
      kill "$pid"
    fi
  done
}

# Restarts a managed instance
ssh-agent-manager_restart() {
  ssh-agent-manager_stop
  ssh-agent-manager_ensure
}

alias ssh="ssh-agent-manager_ensure; ssh"
alias git="ssh-agent-manager_ensure; git"