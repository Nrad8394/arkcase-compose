# ArkCase Production Deployment with Podman Compose

This is a production-ready Podman Compose configuration for ArkCase Community Edition.

## Architecture

This deployment includes the following services:

- **ArkCase Core**: The main ArkCase application (Tomcat-based)
- **PostgreSQL**: Primary database for ArkCase and Alfresco
- **Apache Solr**: Search indexing
- **Apache ActiveMQ**: Message queue for async processing
- **Alfresco Content Services**: ECM (Enterprise Content Management) repository
- **Alfresco Share**: Web UI for Alfresco
- **Transform Core AIO**: Document transformation services
- **Pentaho**: Business Intelligence and reporting
- **Spring Cloud Config Server**: Centralized configuration
- **Nginx**: Reverse proxy and SSL termination

## Prerequisites

1. RHEL 8/9 with Podman and Podman Compose installed
2. At least 16GB RAM (24GB+ recommended)
3. 100GB+ disk space
4. Valid SSL certificates

## Quick Start

### 1. Install Podman and Podman Compose

```bash
# On RHEL 8/9
sudo dnf install -y podman podman-compose

# Enable podman socket for docker compatibility
sudo systemctl enable --now podman.socket
```

### 2. Clone/Download Configuration

Place all files in a directory, for example `/opt/arkcase`:

```bash
sudo mkdir -p /opt/arkcase
cd /opt/arkcase
# Copy all files here
```

### 3. Generate SSL Certificates

```bash
mkdir -p certs

# Generate self-signed certificate (for testing)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout certs/arkcase.key \
  -out certs/arkcase.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=arkcase.yourdomain.com"

# Generate Java keystore for ArkCase
openssl pkcs12 -export \
  -in certs/arkcase.crt \
  -inkey certs/arkcase.key \
  -out certs/keystore.p12 \
  -name arkcase \
  -passout pass:changeme
```

### 4. Configure Environment Variables

```bash
cp .env.example .env
# Edit .env and update all passwords and configuration
nano .env
```

**Important**: Change all default passwords in `.env` file!

### 5. Create ArkCase Configuration Directory

```bash
mkdir -p arkcase-config
# You'll need to populate this with ArkCase configuration files
# These can be obtained from the .arkcase repository or ArkCase installation
```

### 6. Make Init Script Executable

```bash
chmod +x init-scripts/01-init-databases.sh
```

### 7. Configure SELinux (if enabled)

```bash
# Allow containers to access mounted volumes
sudo semanage fcontext -a -t container_file_t "/opt/arkcase(/.*)?"
sudo restorecon -Rv /opt/arkcase

# Or temporarily set to permissive mode for testing
sudo setenforce 0
```

### 8. Start Services

```bash
# Pull images first
podman-compose pull

# Start all services
podman-compose up -d

# Check logs
podman-compose logs -f

# Check status
podman-compose ps
```

### 9. Monitor Startup

Services will start in dependency order. The full startup may take 5-10 minutes.

```bash
# Watch all logs
podman-compose logs -f

# Watch specific service
podman-compose logs -f arkcase-core

# Check health status
podman ps --format "table {{.Names}}\t{{.Status}}"
```

## Access URLs

Once all services are running:

- **ArkCase**: https://your-domain/arkcase
  - Default user: arkcase-admin@arkcase.org
  - Default password: @rKc@3e
  
- **Alfresco Share**: https://your-domain/share
  - Default user: admin
  - Default password: admin

- **ActiveMQ Console**: https://your-domain/admin/activemq
  - Default user: admin
  - Default password: (set in .env)

- **Solr Admin**: https://your-domain/solr (restricted to internal IPs)

## Production Considerations

### 1. Security

- Change all default passwords immediately
- Use proper SSL certificates (not self-signed)
- Restrict access to admin interfaces (ActiveMQ, Solr)
- Enable firewall rules
- Keep SELinux enforcing
- Regular security updates

```bash
# Update all containers
podman-compose pull
podman-compose up -d
```

### 2. Backups

Create backup scripts for:

```bash
# Database backup
podman exec arkcase-postgres pg_dump -U arkcase arkcase > backup_$(date +%Y%m%d).sql

# Volume backups
podman volume inspect arkcase_postgres-data
# Back up the mount point
```

### 3. Resource Limits

The compose file includes resource limits. Adjust based on your needs:

- Minimum: 16GB RAM, 4 CPU cores
- Recommended: 24GB RAM, 8 CPU cores
- Production: 32GB+ RAM, 16+ CPU cores

### 4. Persistent Storage

All data is stored in named volumes. For production:

```bash
# List volumes
podman volume ls

# Inspect volume location
podman volume inspect arkcase_postgres-data

# Consider using dedicated mount points
# Edit docker-compose.yml to use bind mounts instead:
volumes:
  - /data/arkcase/postgres:/var/lib/postgresql/data
```

### 5. Monitoring

Set up monitoring for:
- Container health status
- Resource usage (CPU, memory, disk)
- Application logs
- Database performance
- Network connectivity

```bash
# Monitor resource usage
podman stats

# View logs
podman-compose logs --tail=100 -f arkcase-core
```

### 6. High Availability

For HA deployment:
- Use external PostgreSQL cluster
- Deploy multiple ArkCase instances behind load balancer
- Use shared storage (NFS/GlusterFS) for Alfresco content
- Configure Solr Cloud for distributed search
- Use external ActiveMQ cluster

### 7. Systemd Integration

Create a systemd service to auto-start on boot:

```bash
sudo nano /etc/systemd/system/arkcase.service
```

```ini
[Unit]
Description=ArkCase Application Stack
Requires=podman.service
After=podman.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/arkcase
ExecStart=/usr/bin/podman-compose up -d
ExecStop=/usr/bin/podman-compose down
TimeoutStartSec=600

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable arkcase.service
sudo systemctl start arkcase.service
```

## Troubleshooting

### Services won't start

```bash
# Check logs
podman-compose logs

# Check specific service
podman logs arkcase-postgres

# Check resource usage
podman stats
```

### Out of memory

- Increase system RAM
- Reduce JAVA_OPTS memory allocations in docker-compose.yml
- Scale down non-essential services

### Permission denied errors

```bash
# Fix SELinux contexts
sudo restorecon -Rv /opt/arkcase

# Check volume permissions
podman exec arkcase-core ls -la /opt/arkcase
```

### Network connectivity issues

```bash
# Check network
podman network ls
podman network inspect arkcase_arkcase-network

# Restart networking
podman-compose down
podman-compose up -d
```

### Database connection errors

```bash
# Check PostgreSQL logs
podman logs arkcase-postgres

# Test connection
podman exec arkcase-postgres psql -U arkcase -c "SELECT 1"
```

## Maintenance

### Updates

```bash
# Pull latest images
podman-compose pull

# Restart with new images
podman-compose up -d

# Clean old images
podman image prune -a
```

### Cleanup

```bash
# Stop all services
podman-compose down

# Remove volumes (WARNING: deletes all data!)
podman-compose down -v

# Clean everything
podman system prune -a --volumes
```

## Building Custom Images

If you need to build custom ArkCase images:

```bash
# Clone ArkCase repositories
git clone https://github.com/ArkCase/ark_core.git
cd ark_core

# Build image
podman build -t localhost/arkcase/core:custom .

# Update docker-compose.yml to use your image
# image: localhost/arkcase/core:custom
```

## Support

For issues and questions:
- ArkCase Community: https://github.com/ArkCase/arkcase-ce
- Documentation: https://www.arkcase.com
- GitHub Issues: https://github.com/ArkCase/arkcase-ce/issues

## License

ArkCase Community Edition is licensed under the GPL v3 license.
