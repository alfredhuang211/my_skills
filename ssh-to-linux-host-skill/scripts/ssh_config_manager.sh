#!/usr/bin/env bash
# ssh_config_manager.sh - Manage SSH host configurations
# Usage:
#   ssh_config_manager.sh list                       - List all saved hosts
#   ssh_config_manager.sh get <alias>                - Get config for a host
#   ssh_config_manager.sh save <alias> <json>        - Save/update a host config
#   ssh_config_manager.sh delete <alias>             - Delete a host config
#   ssh_config_manager.sh test <alias>               - Test connection to a host
#   ssh_config_manager.sh interactive                 - Interactive setup wizard

set -euo pipefail

# Config directory - uses XDG standard or defaults to ~/.config
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ssh-skill"
CONFIG_FILE="${CONFIG_DIR}/hosts.json"

# Ensure config directory and file exist
init_config() {
    mkdir -p "$CONFIG_DIR"
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo '{}' > "$CONFIG_FILE"
    fi
}

# List all saved host configurations
list_hosts() {
    init_config
    local hosts
    hosts=$(python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    data = json.load(f)
if not data:
    print('No saved hosts found.')
    sys.exit(0)
print(f'Found {len(data)} saved host(s):')
print('-' * 60)
for alias, cfg in data.items():
    auth = cfg.get('auth_type', 'key')
    host = cfg.get('host', 'N/A')
    port = cfg.get('port', 22)
    user = cfg.get('username', 'N/A')
    print(f'  [{alias}]')
    print(f'    Host:     {host}:{port}')
    print(f'    User:     {user}')
    print(f'    Auth:     {auth}')
    if auth == 'key':
        print(f'    Key:      {cfg.get(\"key_path\", \"~/.ssh/id_rsa\")}')
    print()
")
    echo "$hosts"
}

# Get configuration for a specific host
get_host() {
    local alias="$1"
    init_config
    python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    data = json.load(f)
if '$alias' not in data:
    print('ERROR: Host \"$alias\" not found.', file=sys.stderr)
    sys.exit(1)
print(json.dumps(data['$alias'], indent=2))
"
}

# Save or update a host configuration
# Expected JSON format:
# {
#   "host": "192.168.1.100",
#   "port": 22,
#   "username": "root",
#   "auth_type": "key|password|key_passphrase",
#   "key_path": "~/.ssh/id_rsa",         (optional, for key auth)
#   "password": "",                        (optional, stored only if user opts in)
#   "description": "My dev server"         (optional)
# }
save_host() {
    local alias="$1"
    local config_json="$2"
    init_config
    python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    data = json.load(f)
try:
    new_cfg = json.loads('''$config_json''')
except json.JSONDecodeError as e:
    print(f'ERROR: Invalid JSON: {e}', file=sys.stderr)
    sys.exit(1)
# Validate required fields
required = ['host', 'username', 'auth_type']
for field in required:
    if field not in new_cfg:
        print(f'ERROR: Missing required field: {field}', file=sys.stderr)
        sys.exit(1)
# Set defaults
new_cfg.setdefault('port', 22)
data['$alias'] = new_cfg
with open('$CONFIG_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('Host \"$alias\" saved successfully.')
"
}

# Delete a host configuration
delete_host() {
    local alias="$1"
    init_config
    python3 -c "
import json, sys
with open('$CONFIG_FILE') as f:
    data = json.load(f)
if '$alias' not in data:
    print('ERROR: Host \"$alias\" not found.', file=sys.stderr)
    sys.exit(1)
del data['$alias']
with open('$CONFIG_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('Host \"$alias\" deleted.')
"
}

# Test SSH connection to a saved host
test_connection() {
    local alias="$1"
    init_config

    local config
    config=$(get_host "$alias") || exit 1

    local host port username auth_type key_path
    host=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['host'])")
    port=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('port', 22))")
    username=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['username'])")
    auth_type=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['auth_type'])")
    key_path=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('key_path', '~/.ssh/id_rsa'))")

    echo "Testing connection to [$alias] (${username}@${host}:${port})..."

    local ssh_opts="-o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -o BatchMode=yes -p $port"

    if [[ "$auth_type" == "key" || "$auth_type" == "key_passphrase" ]]; then
        local expanded_key="${key_path/#\~/$HOME}"
        if [[ ! -f "$expanded_key" ]]; then
            echo "ERROR: Key file not found: $key_path"
            exit 1
        fi
        ssh_opts="$ssh_opts -i $expanded_key"
    fi

    if ssh $ssh_opts "${username}@${host}" "echo 'SSH connection successful'; uname -a; uptime" 2>&1; then
        echo ""
        echo "Connection test PASSED."
    else
        echo ""
        echo "Connection test FAILED."
        echo "Possible causes:"
        echo "  - Host unreachable (check IP/hostname and network)"
        echo "  - SSH service not running on target host"
        echo "  - Authentication failed (check credentials)"
        echo "  - Firewall blocking port $port"
        exit 1
    fi
}

# Interactive setup wizard
interactive_setup() {
    echo "=== SSH Host Configuration Wizard ==="
    echo ""

    read -r -p "Enter a short alias for this host (e.g., dev-server): " alias
    if [[ -z "$alias" ]]; then
        echo "ERROR: Alias cannot be empty."
        exit 1
    fi

    read -r -p "Hostname or IP address: " host
    read -r -p "SSH port [22]: " port
    port="${port:-22}"
    read -r -p "Username: " username

    echo ""
    echo "Authentication type:"
    echo "  1) SSH Key (recommended)"
    echo "  2) Password"
    echo "  3) SSH Key with passphrase"
    read -r -p "Choose [1]: " auth_choice
    auth_choice="${auth_choice:-1}"

    local auth_type key_path password
    case "$auth_choice" in
        1)
            auth_type="key"
            read -r -p "Path to SSH private key [~/.ssh/id_rsa]: " key_path
            key_path="${key_path:-~/.ssh/id_rsa}"
            ;;
        2)
            auth_type="password"
            echo "Note: For security, the password will NOT be stored."
            echo "You will be prompted each time you connect."
            ;;
        3)
            auth_type="key_passphrase"
            read -r -p "Path to SSH private key [~/.ssh/id_rsa]: " key_path
            key_path="${key_path:-~/.ssh/id_rsa}"
            echo "Note: The passphrase will NOT be stored."
            ;;
        *)
            echo "Invalid choice."
            exit 1
            ;;
    esac

    read -r -p "Description (optional): " description

    local json
    json=$(python3 -c "
import json
cfg = {
    'host': '$host',
    'port': $port,
    'username': '$username',
    'auth_type': '$auth_type',
}
if '$auth_type' in ('key', 'key_passphrase'):
    cfg['key_path'] = '${key_path:-}'
if '${description:-}':
    cfg['description'] = '${description:-}'
print(json.dumps(cfg))
")

    save_host "$alias" "$json"
    echo ""
    echo "Configuration saved. You can now connect using: ssh_connect.sh $alias <command>"
}

# Export config file path (useful for other scripts)
export_config_path() {
    init_config
    echo "$CONFIG_FILE"
}

# Main command dispatch
case "${1:-help}" in
    list)
        list_hosts
        ;;
    get)
        [[ -z "${2:-}" ]] && { echo "Usage: $0 get <alias>"; exit 1; }
        get_host "$2"
        ;;
    save)
        [[ -z "${2:-}" || -z "${3:-}" ]] && { echo "Usage: $0 save <alias> '<json>'"; exit 1; }
        save_host "$2" "$3"
        ;;
    delete)
        [[ -z "${2:-}" ]] && { echo "Usage: $0 delete <alias>"; exit 1; }
        delete_host "$2"
        ;;
    test)
        [[ -z "${2:-}" ]] && { echo "Usage: $0 test <alias>"; exit 1; }
        test_connection "$2"
        ;;
    interactive)
        interactive_setup
        ;;
    config-path)
        export_config_path
        ;;
    help|*)
        echo "SSH Config Manager - Manage saved SSH host configurations"
        echo ""
        echo "Usage: $0 <command> [args]"
        echo ""
        echo "Commands:"
        echo "  list                  List all saved hosts"
        echo "  get <alias>           Get config for a host (JSON)"
        echo "  save <alias> <json>   Save/update a host config"
        echo "  delete <alias>        Delete a host config"
        echo "  test <alias>          Test connection to a saved host"
        echo "  interactive           Interactive setup wizard"
        echo "  config-path           Print config file path"
        echo "  help                  Show this help"
        ;;
esac
