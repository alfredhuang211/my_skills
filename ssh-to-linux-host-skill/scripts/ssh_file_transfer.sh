#!/usr/bin/env bash
# ssh_file_transfer.sh - Upload/download files to/from remote host
# Usage:
#   ssh_file_transfer.sh upload <alias> <local_path> <remote_path>
#   ssh_file_transfer.sh download <alias> <remote_path> <local_path>
#   ssh_file_transfer.sh sync-up <alias> <local_dir> <remote_dir>
#   ssh_file_transfer.sh sync-down <alias> <remote_dir> <local_dir>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_MANAGER="$SCRIPT_DIR/ssh_config_manager.sh"

# Build SCP/rsync options from saved config
build_transfer_opts() {
    local alias="$1"
    local config
    config=$("$CONFIG_MANAGER" get "$alias") || {
        echo "ERROR: Failed to get config for host '$alias'." >&2
        exit 1
    }

    HOST=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['host'])")
    PORT=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('port', 22))")
    USERNAME=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['username'])")
    AUTH_TYPE=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin)['auth_type'])")
    KEY_PATH=$(echo "$config" | python3 -c "import json,sys; print(json.load(sys.stdin).get('key_path', '~/.ssh/id_rsa'))")

    SCP_OPTS="-o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -P $PORT"
    RSYNC_SSH_OPTS="-o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -p $PORT"

    if [[ "$AUTH_TYPE" == "key" || "$AUTH_TYPE" == "key_passphrase" ]]; then
        local expanded_key="${KEY_PATH/#\~/$HOME}"
        if [[ ! -f "$expanded_key" ]]; then
            echo "ERROR: SSH key not found: $KEY_PATH" >&2
            exit 1
        fi
        SCP_OPTS="$SCP_OPTS -i $expanded_key"
        RSYNC_SSH_OPTS="$RSYNC_SSH_OPTS -i $expanded_key"
    fi

    REMOTE_TARGET="${USERNAME}@${HOST}"
}

# Upload file(s) to remote host
upload_file() {
    local alias="$1"
    local local_path="$2"
    local remote_path="$3"

    build_transfer_opts "$alias"

    if [[ ! -e "$local_path" ]]; then
        echo "ERROR: Local path not found: $local_path" >&2
        exit 1
    fi

    echo ">>> Uploading '$local_path' to [$alias]:$remote_path ..." >&2

    local scp_flags="$SCP_OPTS"
    [[ -d "$local_path" ]] && scp_flags="$scp_flags -r"

    scp $scp_flags "$local_path" "${REMOTE_TARGET}:${remote_path}"
    echo ">>> Upload complete." >&2
}

# Download file(s) from remote host
download_file() {
    local alias="$1"
    local remote_path="$2"
    local local_path="$3"

    build_transfer_opts "$alias"

    echo ">>> Downloading [$alias]:$remote_path to '$local_path' ..." >&2

    # Use -r flag in case it's a directory
    scp $SCP_OPTS -r "${REMOTE_TARGET}:${remote_path}" "$local_path"
    echo ">>> Download complete." >&2
}

# Sync local directory to remote (rsync upload)
sync_upload() {
    local alias="$1"
    local local_dir="$2"
    local remote_dir="$3"

    build_transfer_opts "$alias"

    if ! command -v rsync &>/dev/null; then
        echo "ERROR: rsync is not installed. Install it or use 'upload' instead." >&2
        exit 1
    fi

    echo ">>> Syncing '$local_dir' -> [$alias]:$remote_dir ..." >&2

    rsync -avz --progress -e "ssh $RSYNC_SSH_OPTS" "$local_dir/" "${REMOTE_TARGET}:${remote_dir}/"
    echo ">>> Sync upload complete." >&2
}

# Sync remote directory to local (rsync download)
sync_download() {
    local alias="$1"
    local remote_dir="$2"
    local local_dir="$3"

    build_transfer_opts "$alias"

    if ! command -v rsync &>/dev/null; then
        echo "ERROR: rsync is not installed. Install it or use 'download' instead." >&2
        exit 1
    fi

    mkdir -p "$local_dir"
    echo ">>> Syncing [$alias]:$remote_dir -> '$local_dir' ..." >&2

    rsync -avz --progress -e "ssh $RSYNC_SSH_OPTS" "${REMOTE_TARGET}:${remote_dir}/" "$local_dir/"
    echo ">>> Sync download complete." >&2
}

# Main command dispatch
case "${1:-help}" in
    upload)
        [[ $# -lt 4 ]] && { echo "Usage: $0 upload <alias> <local_path> <remote_path>"; exit 1; }
        upload_file "$2" "$3" "$4"
        ;;
    download)
        [[ $# -lt 4 ]] && { echo "Usage: $0 download <alias> <remote_path> <local_path>"; exit 1; }
        download_file "$2" "$3" "$4"
        ;;
    sync-up)
        [[ $# -lt 4 ]] && { echo "Usage: $0 sync-up <alias> <local_dir> <remote_dir>"; exit 1; }
        sync_upload "$2" "$3" "$4"
        ;;
    sync-down)
        [[ $# -lt 4 ]] && { echo "Usage: $0 sync-down <alias> <remote_dir> <local_dir>"; exit 1; }
        sync_download "$2" "$3" "$4"
        ;;
    help|*)
        echo "SSH File Transfer - Upload/download files to/from remote hosts"
        echo ""
        echo "Usage:"
        echo "  $0 upload <alias> <local_path> <remote_path>    Upload file/dir"
        echo "  $0 download <alias> <remote_path> <local_path>  Download file/dir"
        echo "  $0 sync-up <alias> <local_dir> <remote_dir>     Rsync upload"
        echo "  $0 sync-down <alias> <remote_dir> <local_dir>   Rsync download"
        echo "  $0 help                                          Show this help"
        ;;
esac
