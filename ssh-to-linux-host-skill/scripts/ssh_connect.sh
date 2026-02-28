#!/usr/bin/env bash
# ssh_connect.sh - Execute commands on remote Linux host via SSH
# Usage:
#   ssh_connect.sh <alias> <command>                    - Run command on saved host
#   ssh_connect.sh <alias> --script <script_path>       - Run a local script on remote host
#   ssh_connect.sh <alias> --interactive                 - Open interactive SSH session
#   ssh_connect.sh --direct <user@host> [-p port] [-i key] <command>  - Direct connection

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_MANAGER="$SCRIPT_DIR/ssh_config_manager.sh"

# Build SSH options from saved config
build_ssh_command() {
    local alias="$1"
    local config
    config=$("$CONFIG_MANAGER" get "$alias") || {
        echo "ERROR: Failed to get config for host '$alias'." >&2
        echo "Run 'ssh_config_manager.sh list' to see available hosts." >&2
        exit 1
    }

    local host port username auth_type key_path
    host=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['host'])")
    port=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('port', 22))")
    username=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['username'])")
    auth_type=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['auth_type'])")
    key_path=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('key_path', '~/.ssh/id_rsa'))")

    # Base SSH options
    SSH_OPTS="-o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -p $port"

    # Auth-specific options
    case "$auth_type" in
        key)
            local expanded_key="${key_path/#\~/$HOME}"
            if [[ ! -f "$expanded_key" ]]; then
                echo "ERROR: SSH key not found: $key_path" >&2
                exit 1
            fi
            SSH_OPTS="$SSH_OPTS -i $expanded_key"
            ;;
        password)
            # Password auth - will need sshpass or interactive prompt
            if command -v sshpass &>/dev/null; then
                echo "Enter SSH password for ${username}@${host}:" >&2
                read -rs SSH_PASSWORD
                export SSHPASS="$SSH_PASSWORD"
                SSH_PREFIX="sshpass -e"
            else
                # Fall back to keyboard-interactive
                SSH_OPTS="$SSH_OPTS -o BatchMode=no -o PreferredAuthentications=password,keyboard-interactive"
            fi
            ;;
        key_passphrase)
            local expanded_key="${key_path/#\~/$HOME}"
            if [[ ! -f "$expanded_key" ]]; then
                echo "ERROR: SSH key not found: $key_path" >&2
                exit 1
            fi
            SSH_OPTS="$SSH_OPTS -i $expanded_key"
            # Rely on ssh-agent or interactive passphrase prompt
            ;;
    esac

    SSH_TARGET="${username}@${host}"
}

# Execute a command on remote host
exec_remote_command() {
    local alias="$1"
    shift
    local command="$*"

    build_ssh_command "$alias"

    echo ">>> Executing on [$alias] (${SSH_TARGET}):" >&2
    echo ">>> $ $command" >&2
    echo "---" >&2

    if [[ -n "${SSH_PREFIX:-}" ]]; then
        $SSH_PREFIX ssh $SSH_OPTS "$SSH_TARGET" "$command"
    else
        ssh $SSH_OPTS "$SSH_TARGET" "$command"
    fi
    local exit_code=$?

    echo "---" >&2
    echo ">>> Exit code: $exit_code" >&2
    return $exit_code
}

# Execute a local script on remote host
exec_remote_script() {
    local alias="$1"
    local script_path="$2"

    if [[ ! -f "$script_path" ]]; then
        echo "ERROR: Script not found: $script_path" >&2
        exit 1
    fi

    build_ssh_command "$alias"

    echo ">>> Running script '$script_path' on [$alias] (${SSH_TARGET}):" >&2
    echo "---" >&2

    if [[ -n "${SSH_PREFIX:-}" ]]; then
        $SSH_PREFIX ssh $SSH_OPTS "$SSH_TARGET" 'bash -s' < "$script_path"
    else
        ssh $SSH_OPTS "$SSH_TARGET" 'bash -s' < "$script_path"
    fi
    local exit_code=$?

    echo "---" >&2
    echo ">>> Exit code: $exit_code" >&2
    return $exit_code
}

# Open interactive SSH session
open_interactive() {
    local alias="$1"
    build_ssh_command "$alias"

    echo ">>> Opening interactive session to [$alias] (${SSH_TARGET})..." >&2
    if [[ -n "${SSH_PREFIX:-}" ]]; then
        $SSH_PREFIX ssh $SSH_OPTS "$SSH_TARGET"
    else
        ssh $SSH_OPTS "$SSH_TARGET"
    fi
}

# Direct connection mode (without saved config)
direct_connect() {
    shift  # remove --direct
    local target=""
    local port="22"
    local key=""
    local command=""
    local collecting_cmd=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -p) port="$2"; shift 2 ;;
            -i) key="$2"; shift 2 ;;
            *)
                if [[ -z "$target" ]]; then
                    target="$1"
                    shift
                else
                    command="$*"
                    break
                fi
                ;;
        esac
    done

    if [[ -z "$target" ]]; then
        echo "Usage: $0 --direct <user@host> [-p port] [-i key] <command>" >&2
        exit 1
    fi

    local ssh_opts="-o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=30 -p $port"
    [[ -n "$key" ]] && ssh_opts="$ssh_opts -i $key"

    echo ">>> Executing on ${target}:" >&2
    echo ">>> $ $command" >&2
    echo "---" >&2

    ssh $ssh_opts "$target" "$command"
    local exit_code=$?

    echo "---" >&2
    echo ">>> Exit code: $exit_code" >&2
    return $exit_code
}

# Multi-command execution (pipe-delimited)
exec_multi_commands() {
    local alias="$1"
    shift
    local commands="$*"

    build_ssh_command "$alias"

    echo ">>> Executing multi-command on [$alias] (${SSH_TARGET}):" >&2
    echo "---" >&2

    # Replace pipe-delimiter with newline for heredoc
    local script
    script=$(echo "$commands" | tr '|' '\n')

    if [[ -n "${SSH_PREFIX:-}" ]]; then
        echo "$script" | $SSH_PREFIX ssh $SSH_OPTS "$SSH_TARGET" 'bash -s'
    else
        echo "$script" | ssh $SSH_OPTS "$SSH_TARGET" 'bash -s'
    fi
    local exit_code=$?

    echo "---" >&2
    echo ">>> Exit code: $exit_code" >&2
    return $exit_code
}

# Main command dispatch
case "${1:-help}" in
    --direct)
        direct_connect "$@"
        ;;
    --help|help)
        echo "SSH Connect - Execute commands on remote Linux hosts"
        echo ""
        echo "Usage:"
        echo "  $0 <alias> <command>                  Run a command on saved host"
        echo "  $0 <alias> --script <path>            Run a local script on remote host"
        echo "  $0 <alias> --multi 'cmd1|cmd2|cmd3'   Run multiple commands"
        echo "  $0 <alias> --interactive              Open interactive session"
        echo "  $0 --direct <user@host> [-p port] [-i key] <command>"
        echo "                                         Direct connection without config"
        echo "  $0 --help                              Show this help"
        ;;
    *)
        alias="$1"
        shift

        case "${1:---}" in
            --script)
                [[ -z "${2:-}" ]] && { echo "Usage: $0 <alias> --script <path>"; exit 1; }
                exec_remote_script "$alias" "$2"
                ;;
            --interactive)
                open_interactive "$alias"
                ;;
            --multi)
                shift
                exec_multi_commands "$alias" "$@"
                ;;
            *)
                exec_remote_command "$alias" "$@"
                ;;
        esac
        ;;
esac
