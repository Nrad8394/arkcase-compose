# ArkCase Production Deployment Checklist

## Pre-Deployment

### System Requirements
- [ ] RHEL 8/9 server provisioned
- [ ] Minimum 16GB RAM (24GB+ recommended)
- [ ] 100GB+ disk space available
- [ ] CPU: 4+ cores (8+ recommended)
- [ ] Network connectivity verified
- [ ] Firewall rules configured

### Software Prerequisites
- [ ] Podman installed (`sudo dnf install podman`)
- [ ] Podman Compose installed (`sudo dnf install podman-compose`)
- [ ] Git installed (optional, for cloning)
- [ ] OpenSSL installed (for certificate generation)

### Security Setup
- [ ] SELinux configured (enforcing or permissive mode set)
- [ ] Firewall rules created for ports 80, 443
- [ ] SSL certificates obtained (production certificates, not self-signed)
- [ ] SSH access configured and secured
- [ ] sudo access configured for deployment user

## Configuration

### Files and Directories
- [ ] All compose files copied to `/opt/arkcase`
- [ ] `.env` file created from `.env.example`
- [ ] All passwords changed in `.env` file
- [ ] SSL certificates placed in `certs/` directory
- [ ] Java keystore generated (`certs/keystore.p12`)
- [ ] Nginx configuration reviewed and customized
- [ ] ArkCase configuration directory created (`arkcase-config/`)
- [ ] Init scripts made executable (`chmod +x init-scripts/*.sh`)

### Environment Variables (.env)
- [ ] DB_PASSWORD - strong password set
- [ ] ACTIVEMQ_PASSWORD - strong password set
- [ ] KEYSTORE_PASSWORD - strong password set
- [ ] ARKCASE_HOST - correct domain name set
- [ ] SMTP settings configured (if email needed)
- [ ] LDAP/AD settings configured (if using external auth)

### SELinux Configuration
- [ ] SELinux contexts set for `/opt/arkcase`
- [ ] File permissions verified
- [ ] Or SELinux set to permissive for testing

```bash
sudo semanage fcontext -a -t container_file_t "/opt/arkcase(/.*)?"
sudo restorecon -Rv /opt/arkcase
```

## Deployment

### Initial Setup
- [ ] Directory ownership verified
- [ ] Configuration files validated
- [ ] Images pulled (`podman-compose pull`)
- [ ] Volumes created successfully

### Service Startup
- [ ] All services started (`podman-compose up -d`)
- [ ] No error messages in logs
- [ ] Health checks passing for all services
- [ ] Database initialized successfully
- [ ] Solr cores created
- [ ] Alfresco started successfully
- [ ] ArkCase core application started

### Verification
```bash
# Check all services are running
podman-compose ps

# Check health status
podman ps --format "table {{.Names}}\t{{.Status}}"

# Monitor logs
podman-compose logs -f
```

## Post-Deployment

### Access Verification
- [ ] HTTPS redirect working (HTTP → HTTPS)
- [ ] ArkCase UI accessible (https://domain/arkcase)
- [ ] Login with default credentials successful
- [ ] Alfresco Share accessible (https://domain/share)
- [ ] Pentaho accessible (https://domain/pentaho)
- [ ] SSL certificate valid and trusted

### Initial Configuration
- [ ] Default admin password changed
- [ ] Email configuration tested
- [ ] LDAP/AD authentication configured (if using)
- [ ] First test user created
- [ ] User able to receive password reset email
- [ ] Document upload/download tested
- [ ] Search functionality tested
- [ ] Reporting tested

### Security Hardening
- [ ] All default passwords changed
- [ ] Admin interfaces restricted (ActiveMQ, Solr)
- [ ] Firewall rules verified and active
- [ ] SELinux in enforcing mode
- [ ] SSL certificates valid and not self-signed
- [ ] Unnecessary ports closed
- [ ] Regular security updates scheduled

### Backup Configuration
- [ ] Database backup script created
- [ ] Volume backup locations identified
- [ ] Backup schedule configured
- [ ] Backup restoration tested
- [ ] Off-site backup configured

### Monitoring Setup
- [ ] Log aggregation configured
- [ ] Resource monitoring enabled
- [ ] Alert thresholds defined
- [ ] Health check monitoring configured
- [ ] Uptime monitoring enabled

### Documentation
- [ ] Deployment notes documented
- [ ] Customizations documented
- [ ] Admin credentials securely stored
- [ ] Backup procedures documented
- [ ] Recovery procedures documented
- [ ] Runbook created for common operations

## Production Readiness

### Performance Testing
- [ ] Load testing completed
- [ ] Response times acceptable
- [ ] Resource usage within limits
- [ ] Database performance verified
- [ ] Search performance verified

### High Availability (Optional)
- [ ] Load balancer configured
- [ ] Multiple ArkCase instances deployed
- [ ] Database replication configured
- [ ] Shared storage configured for Alfresco
- [ ] Failover tested

### Systemd Integration
- [ ] Systemd service file installed
- [ ] Auto-start on boot enabled
- [ ] Service restart policies configured
- [ ] Boot sequence tested

```bash
sudo cp arkcase.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable arkcase.service
sudo systemctl start arkcase.service
```

### Maintenance Planning
- [ ] Update schedule defined
- [ ] Maintenance windows scheduled
- [ ] Change management process defined
- [ ] Rollback procedures documented
- [ ] Support contacts identified

## Go-Live

### Final Checks
- [ ] All services healthy
- [ ] All tests passing
- [ ] Backups verified
- [ ] Monitoring active
- [ ] Documentation complete
- [ ] Support team notified
- [ ] Users notified

### Launch
- [ ] DNS updated (if needed)
- [ ] SSL certificates deployed
- [ ] Users can access system
- [ ] Login working for all users
- [ ] Core functionality verified
- [ ] No critical errors in logs

## Post-Launch

### First Week
- [ ] Daily log reviews
- [ ] Monitor resource usage
- [ ] User feedback collected
- [ ] Issues tracked and resolved
- [ ] Performance metrics reviewed

### Ongoing
- [ ] Weekly backup verification
- [ ] Monthly security updates
- [ ] Quarterly disaster recovery testing
- [ ] Regular performance reviews
- [ ] Capacity planning updates

## Troubleshooting Commands

```bash
# Check service status
podman-compose ps
podman ps --format "table {{.Names}}\t{{.Status}}"

# View logs
podman-compose logs -f
podman-compose logs -f arkcase-core
podman logs arkcase-postgres

# Check resources
podman stats
df -h
free -h

# Restart services
podman-compose restart
podman-compose restart arkcase-core

# Database access
podman exec -it arkcase-postgres psql -U arkcase arkcase

# Container shell access
podman exec -it arkcase-core /bin/bash

# Network debugging
podman network inspect arkcase_arkcase-network
podman exec arkcase-core ping postgres
```

## Emergency Procedures

### Service Down
1. Check logs: `podman-compose logs [service]`
2. Check resources: `podman stats`
3. Restart service: `podman-compose restart [service]`
4. If persistent, check configuration
5. Contact support if needed

### Database Issues
1. Check logs: `podman logs arkcase-postgres`
2. Verify connectivity: `podman exec arkcase-postgres psql -U arkcase -c "SELECT 1"`
3. Check disk space: `df -h`
4. Restore from backup if corrupted

### Complete Outage
1. Stop all services: `podman-compose down`
2. Check system resources: `free -h`, `df -h`
3. Review logs for errors
4. Restart services: `podman-compose up -d`
5. Monitor startup sequence
6. Verify all health checks pass

## Sign-Off

- [ ] Technical Lead: __________________ Date: __________
- [ ] Security Team: __________________ Date: __________
- [ ] Operations Team: ________________ Date: __________
- [ ] Management: ____________________ Date: __________
