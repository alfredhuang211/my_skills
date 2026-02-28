---
name: ssh-to-linux-host
description: This skill enables connecting to remote Linux hosts via SSH and executing commands, transferring files, and managing server configurations. This skill should be used when the user wants to:
- Connect to a remote Linux server or cloud instance
- Execute shell commands on a remote host
- Upload or download files to/from a remote server
- Manage multiple SSH host configurations
- Deploy code or check server status remotely
- Troubleshoot remote server issues
Keywords: SSH, remote, server, Linux, connect, deploy, command, upload, download, SCP, rsync, host, cloud, VPS, instance
---

# SSH to Linux Host

## Overview

This skill provides a complete workflow for connecting to remote Linux hosts via SSH: managing host configurations (save, list, test), executing commands remotely, and transferring files. It supports SSH key authentication, password authentication, and key-with-passphrase authentication. Connection configurations are persisted locally for reuse.

## Quick Start

All scripts are located in the `scripts/` directory of this skill. Set them as executable before first use:

```bash
chmod +x scripts/ssh_config_manager.sh scripts/ssh_connect.sh scripts/ssh_file_transfer.sh
```

## Workflow

### Step 1: Determine Host Configuration

Before connecting, determine if a saved configuration exists or collect connection details from the user.

**Check for saved hosts:**
```bash
bash scripts/ssh_config_manager.sh list
```

If the target host is already saved, proceed to Step 3. Otherwise, collect the following from the user:

| Parameter | Required | Default | Description |
|-----------|----------|---------|-------------|
| Host/IP | Yes | - | Server hostname or IP address |
| Port | No | 22 | SSH port number |
| Username | Yes | - | Login username |
| Auth Type | Yes | key | One of: `key`, `password`, `key_passphrase` |
| Key Path | If key auth | ~/.ssh/id_rsa | Path to SSH private key file |
| Description | No | - | Friendly description for the host |

To collect this information from the user, ask a focused question like:

> "To connect to your Linux server, I need the following information:
> 1. Hostname or IP address
> 2. Username
> 3. Authentication method (SSH key / password / key with passphrase)
> 4. SSH port (default: 22)
> 5. Path to SSH key (if using key auth, default: ~/.ssh/id_rsa)"

### Step 2: Save Host Configuration

Save the host configuration for future reuse:

```bash
bash scripts/ssh_config_manager.sh save <alias> '{"host":"<ip>","port":22,"username":"<user>","auth_type":"key","key_path":"~/.ssh/id_rsa","description":"My server"}'
```

The `alias` is a short memorable name chosen by or suggested to the user (e.g., `dev-server`, `prod-web1`).

**Supported auth_type values:**
- `key` — SSH private key authentication (recommended, most secure)
- `password` — Password authentication (prompted at connect time, never stored)
- `key_passphrase` — SSH key with passphrase (passphrase prompted at connect time)

### Step 3: Test Connection

Always test the connection before executing tasks:

```bash
bash scripts/ssh_config_manager.sh test <alias>
```

If the test fails, refer to `references/ssh_troubleshooting.md` for common issues and solutions. Read that file with:

```bash
cat references/ssh_troubleshooting.md
```

### Step 4: Execute Commands

**Single command:**
```bash
bash scripts/ssh_connect.sh <alias> "<command>"
```

**Multiple commands (pipe-delimited):**
```bash
bash scripts/ssh_connect.sh <alias> --multi "cd /var/log|tail -n 50 syslog|df -h"
```

**Run a local script on remote host:**
```bash
bash scripts/ssh_connect.sh <alias> --script /path/to/local/script.sh
```

**Direct connection (without saved config):**
```bash
bash scripts/ssh_connect.sh --direct user@host -p 22 -i ~/.ssh/id_rsa "uname -a"
```

### Step 5: Transfer Files (If Needed)

**Upload a file:**
```bash
bash scripts/ssh_file_transfer.sh upload <alias> /local/path /remote/path
```

**Download a file:**
```bash
bash scripts/ssh_file_transfer.sh download <alias> /remote/path /local/path
```

**Sync directories (requires rsync):**
```bash
bash scripts/ssh_file_transfer.sh sync-up <alias> /local/dir /remote/dir
bash scripts/ssh_file_transfer.sh sync-down <alias> /remote/dir /local/dir
```

## Host Management

**List all saved hosts:**
```bash
bash scripts/ssh_config_manager.sh list
```

**View a specific host's config:**
```bash
bash scripts/ssh_config_manager.sh get <alias>
```

**Delete a saved host:**
```bash
bash scripts/ssh_config_manager.sh delete <alias>
```

**Configuration storage location:** `~/.config/ssh-skill/hosts.json`

## Common Task Patterns

### Check server status
```bash
bash scripts/ssh_connect.sh <alias> --multi "uname -a|uptime|free -h|df -h|systemctl list-units --state=failed"
```

### View logs
```bash
bash scripts/ssh_connect.sh <alias> "tail -n 100 /var/log/syslog"
```

### Deploy code
```bash
bash scripts/ssh_file_transfer.sh sync-up <alias> ./dist /var/www/myapp
bash scripts/ssh_connect.sh <alias> "cd /var/www/myapp && npm install --production && pm2 restart all"
```

### Manage services
```bash
bash scripts/ssh_connect.sh <alias> "sudo systemctl restart nginx"
bash scripts/ssh_connect.sh <alias> "sudo systemctl status nginx"
```

### System maintenance
```bash
bash scripts/ssh_connect.sh <alias> --multi "sudo apt update|sudo apt list --upgradable"
```

## Troubleshooting

When a connection or command fails, read the troubleshooting reference:

```bash
cat references/ssh_troubleshooting.md
```

Common quick fixes:
- **Permission denied**: Verify key permissions (`chmod 600 ~/.ssh/id_rsa`) and that the public key is on the server
- **Connection refused**: Confirm SSH service is running and port is correct
- **Timeout**: Check network connectivity and firewall rules
- **Host key changed**: Run `ssh-keygen -R <hostname>` and reconnect

## Security Notes

- Passwords are **never stored** in the configuration file — they are prompted at connect time
- SSH key passphrases are **never stored** — they are prompted or handled by ssh-agent
- Configuration files are stored in `~/.config/ssh-skill/` with user-only access
- Prefer SSH key authentication over password authentication for security and automation
- The scripts use `StrictHostKeyChecking=accept-new` to auto-accept new host keys while rejecting changed keys
