# OSSOP Proxy/Certificates

This service provides a reverse proxy (Nginx) for all OSSOP services, allowing access via nice domains (e.g., `https://opensearch.localhost`) instead of ports.

## Certificates

All shared certificates are stored in `ossop/config/certs/`.

- `fullchain.pem`: The public certificate (and chain)
- `privkey.pem`: The private key

### Using Your Own Certificates
To use your own wildcard certificate (e.g., for `*.yourdomain.com`):
1. **Replace** `fullchain.pem` and `privkey.pem` in `ossop/config/certs/` with your own files.
2. **Restart** the proxy:
   ```bash
   docker compose -f apps/proxy/docker-compose.yml restart
   ```
3. **Update Hosts/DNS**: Ensure `opensearch.yourdomain.com`, `shuffle.yourdomain.com`, etc., resolve to your Docker host IP.

### Default (Self-Signed)
By default, we generate self-signed certs for `*.localhost`. You must tell your browser to trust them or click "Proceed Unsafe".
