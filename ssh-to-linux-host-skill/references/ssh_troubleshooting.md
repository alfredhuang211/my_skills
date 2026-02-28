# SSH Troubleshooting Reference

## Common Connection Issues

### 1. Permission denied (publickey)
- Verify the key file exists and has correct permissions: `chmod 600 ~/.ssh/id_rsa`
- Ensure the public key is in the remote `~/.ssh/authorized_keys`
- Check key type compatibility (prefer ed25519 or RSA 4096-bit)

### 2. Connection refused
- Verify the SSH service is running: `systemctl status sshd`
- Check the port number matches: `ss -tlnp | grep ssh`
- Confirm firewall allows SSH traffic: `ufw status` or `iptables -L`

### 3. Connection timed out
- Verify the host IP/hostname is correct
- Check network connectivity: `ping <host>`
- Verify no firewall is blocking the connection
- Try a different port if port 22 is blocked

### 4. Host key verification failed
- Remove the old key: `ssh-keygen -R <hostname>`
- Reconnect to accept the new key

### 5. Too many authentication failures
- Specify the correct key: `ssh -i ~/.ssh/specific_key user@host`
- Limit auth methods: `ssh -o PreferredAuthentications=publickey user@host`

## Key Generation

```bash
# Generate ed25519 key (recommended)
ssh-keygen -t ed25519 -C "your-email@example.com"

# Generate RSA 4096-bit key (wider compatibility)
ssh-keygen -t rsa -b 4096 -C "your-email@example.com"

# Copy key to remote host
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@host
```

## SSH Config Optimization

Add to `~/.ssh/config` for connection reuse and performance:

```
Host *
    ServerAliveInterval 30
    ServerAliveCountMax 3
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
    Compression yes
```

Create the sockets directory: `mkdir -p ~/.ssh/sockets`

## Security Best Practices

1. **Use SSH keys instead of passwords** - Keys are more secure and automatable
2. **Disable root login** - Set `PermitRootLogin no` in `/etc/ssh/sshd_config`
3. **Use a non-standard port** - Change from 22 to reduce brute-force attempts
4. **Enable fail2ban** - Auto-blocks IPs with too many failed attempts
5. **Keep SSH updated** - Regularly update OpenSSH for security patches
6. **Audit access** - Review `~/.ssh/authorized_keys` periodically
