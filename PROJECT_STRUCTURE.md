# ArkCase Production Deployment - File Structure

This directory contains everything you need to deploy ArkCase on RHEL with Podman.

## Directory Structure

```
/opt/arkcase/                           # Installation directory
├── docker-compose.yml                  # Main compose file (Podman compatible)
├── .env.example                        # Environment variables template
├── .env                               # Your actual environment variables (create this)
├── README.md                           # Comprehensive documentation
├── QUICKSTART.md                       # Quick installation guide
├── DEPLOYMENT_CHECKLIST.md             # Production deployment checklist
├── Makefile                            # Convenient management commands
├── arkcase.service                     # Systemd service file
├── cron-jobs.txt                       # Backup and monitoring cron jobs
│
├── nginx/                              # Nginx reverse proxy configuration
│   ├── nginx.conf                      # Main nginx config
│   └── conf.d/
│       └── arkcase.conf                # ArkCase site configuration
│
├── init-scripts/                       # Database initialization scripts
│   └── 01-init-databases.sh           # Creates multiple PostgreSQL databases
│
├── scripts/                            # Management scripts
│   ├── backup.sh                       # Automated backup script
│   └── health-check.sh                 # Service health monitoring
│
├── certs/                              # SSL certificates (you create this)
│   ├── arkcase.crt                     # SSL certificate
│   ├── arkcase.key                     # SSL private key
│   └── keystore.p12                    # Java keystore for ArkCase
│
└── arkcase-config/                     # ArkCase configuration files (you create this)
    └── (configuration files from .arkcase repo)
```

## File Descriptions

### Core Files

- **docker-compose.yml**: Main orchestration file defining all services
  - PostgreSQL database
  - Apache Solr search engine
  - Apache ActiveMQ message broker
  - Alfresco ECM (content management)
  - Pentaho Business Intelligence
  - ArkCase core application
  - Nginx reverse proxy

- **.env.example**: Template for environment variables
  - Database passwords
  - Service passwords
  - LDAP/AD configuration
  - Email settings

- **README.md**: Complete documentation including:
  - Architecture overview
  - Installation instructions
  - Configuration guide
  - Troubleshooting
  - Maintenance procedures

- **QUICKSTART.md**: Streamlined installation guide
  - Step-by-step instructions
  - Estimated time for each step
  - Common commands
  - Quick troubleshooting

- **DEPLOYMENT_CHECKLIST.md**: Production readiness checklist
  - Pre-deployment tasks
  - Configuration verification
  - Security hardening
  - Post-deployment validation
  - Go-live checklist

### Configuration Files

- **nginx/nginx.conf**: Main Nginx configuration
  - Worker processes
  - Connection settings
  - SSL/TLS settings
  - Gzip compression

- **nginx/conf.d/arkcase.conf**: ArkCase-specific Nginx config
  - HTTP to HTTPS redirect
  - SSL certificate configuration
  - Reverse proxy rules for all services
  - Security headers
  - Access restrictions

### Scripts

- **scripts/backup.sh**: Automated backup script
  - Database dumps (PostgreSQL)
  - Volume backups
  - Compression
  - Retention management
  - Logging

- **scripts/health-check.sh**: Health monitoring script
  - Service status checks
  - Port availability
  - URL accessibility
  - System resource monitoring
  - Alert notifications

### Initialization

- **init-scripts/01-init-databases.sh**: Database setup
  - Creates multiple databases on startup
  - Runs automatically via PostgreSQL container

### System Integration

- **Makefile**: Convenient command shortcuts
  - `make start` - Start all services
  - `make stop` - Stop all services
  - `make logs` - View logs
  - `make backup-db` - Backup database
  - `make health` - Check service health

- **arkcase.service**: Systemd unit file
  - Auto-start on boot
  - Restart on failure
  - Resource limits
  - Dependency management

- **cron-jobs.txt**: Scheduled task templates
  - Daily backups
  - Weekly backup verification
  - Health checks
  - Cleanup tasks

## Docker Compose Services

### Application Tier
- **arkcase-core**: Main ArkCase application (Tomcat)
- **arkcase-nginx**: Reverse proxy and SSL termination

### Content Management
- **alfresco**: ECM repository (document storage)
- **alfresco-share**: Alfresco web interface
- **transform-core-aio**: Document transformation services

### Business Intelligence
- **pentaho**: Reporting and analytics

### Infrastructure
- **postgres**: Primary database
- **solr**: Search indexing
- **activemq**: Message broker
- **config-server**: Spring Cloud Config server

## Network Configuration

- **Network**: `arkcase-network` (172.28.0.0/16)
- **HTTP Port**: 80 (redirects to HTTPS)
- **HTTPS Port**: 443
- **ArkCase Direct**: 8843 (HTTPS), 8080 (HTTP)

## Volume Mounts

All data is stored in named Docker volumes:
- `postgres-data`: PostgreSQL database files
- `solr-data`: Solr indices
- `activemq-data`: ActiveMQ message store
- `alfresco-data`: Alfresco content store
- `pentaho-data`: Pentaho configuration
- `arkcase-data`: ArkCase application data
- `arkcase-logs`: Application logs
- `nginx-logs`: Web server logs

## Resource Allocations

Default memory limits (adjust as needed):
- PostgreSQL: 2GB
- Solr: 3GB
- ActiveMQ: 3GB
- Alfresco: 4GB
- Alfresco Share: 2GB
- Pentaho: 3GB
- ArkCase Core: 6GB
- Transform Core: 1GB
- Config Server: 1GB
- Nginx: 512MB

Total: ~25GB (with some overhead)

## Security Considerations

### Passwords
- All default passwords MUST be changed
- Store passwords securely
- Use strong passwords (minimum 12 characters)

### SSL/TLS
- Self-signed certificates for testing only
- Use valid certificates for production
- Configure proper certificate chain

### Network Security
- Firewall rules for ports 80, 443
- Internal services not exposed
- Admin interfaces restricted to internal IPs

### SELinux
- Set proper contexts for /opt/arkcase
- Keep SELinux in enforcing mode for production

### Access Control
- Restrict SSH access
- Use sudo for administrative tasks
- Regular security updates

## Getting Started

1. **Download Files**: Extract all files to `/opt/arkcase`
2. **Review Documentation**: Read README.md and QUICKSTART.md
3. **Configure**: Copy .env.example to .env and customize
4. **Generate Certs**: Create SSL certificates
5. **Deploy**: Run `podman-compose up -d`
6. **Verify**: Check all services are healthy
7. **Access**: Open https://your-domain/arkcase

## Support Resources

- **Official Site**: https://www.arkcase.com
- **GitHub**: https://github.com/ArkCase/arkcase-ce
- **Documentation**: https://support.arkcase.com
- **Community**: https://github.com/ArkCase/arkcase-ce/issues

## Important Notes

1. This is designed for **Podman** on RHEL, not Docker
2. Podman Compose syntax is compatible with Docker Compose
3. All images use official or ArkCase public ECR images
4. Configuration is production-oriented with health checks
5. Resource limits are set to prevent memory issues
6. Backup scripts are included and ready to use
7. Monitoring and alerting are built-in

## Next Steps After Installation

1. Change all default passwords
2. Configure email (SMTP)
3. Set up LDAP/Active Directory
4. Enable automated backups
5. Configure monitoring
6. Test disaster recovery
7. Train users
8. Plan maintenance windows

## License

ArkCase Community Edition is licensed under GPL v3.
See https://github.com/ArkCase/arkcase-ce for details.
