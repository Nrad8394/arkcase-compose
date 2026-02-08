#!/bin/bash
#
# ArkCase Backup Script
# This script backs up the PostgreSQL database and key volumes
#

set -e

# Configuration
BACKUP_DIR="/opt/arkcase-backups"
RETENTION_DAYS=30
DATE=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="arkcase-postgres"
DB_USER="arkcase"
DB_NAME="arkcase"

# Create backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}/database"
mkdir -p "${BACKUP_DIR}/volumes"
mkdir -p "${BACKUP_DIR}/logs"

# Log file
LOG_FILE="${BACKUP_DIR}/logs/backup_${DATE}.log"

# Functions
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "${LOG_FILE}"
}

error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1" | tee -a "${LOG_FILE}" >&2
}

# Start backup
log "Starting ArkCase backup process"

# Check if PostgreSQL container is running
if ! podman ps | grep -q "${CONTAINER_NAME}"; then
    error "PostgreSQL container is not running!"
    exit 1
fi

# Backup PostgreSQL database
log "Backing up PostgreSQL database: ${DB_NAME}"
if podman exec "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" "${DB_NAME}" > "${BACKUP_DIR}/database/arkcase_${DATE}.sql"; then
    log "Database backup completed: arkcase_${DATE}.sql"
    
    # Compress the backup
    log "Compressing database backup..."
    gzip "${BACKUP_DIR}/database/arkcase_${DATE}.sql"
    log "Database backup compressed: arkcase_${DATE}.sql.gz"
else
    error "Database backup failed!"
    exit 1
fi

# Backup Alfresco database
log "Backing up Alfresco database"
if podman exec "${CONTAINER_NAME}" pg_dump -U "${DB_USER}" "alfresco" > "${BACKUP_DIR}/database/alfresco_${DATE}.sql"; then
    log "Alfresco database backup completed: alfresco_${DATE}.sql"
    gzip "${BACKUP_DIR}/database/alfresco_${DATE}.sql"
    log "Alfresco database backup compressed: alfresco_${DATE}.sql.gz"
else
    error "Alfresco database backup failed!"
    exit 1
fi

# Backup volumes
log "Creating volume snapshots..."

# Get volume mount points
POSTGRES_VOLUME=$(podman volume inspect arkcase_postgres-data --format '{{.Mountpoint}}')
ALFRESCO_VOLUME=$(podman volume inspect arkcase_alfresco-data --format '{{.Mountpoint}}')
ARKCASE_VOLUME=$(podman volume inspect arkcase_arkcase-data --format '{{.Mountpoint}}')

# Create tar archives of volumes
log "Backing up PostgreSQL data volume..."
if [ -d "${POSTGRES_VOLUME}" ]; then
    tar -czf "${BACKUP_DIR}/volumes/postgres-data_${DATE}.tar.gz" -C "$(dirname ${POSTGRES_VOLUME})" "$(basename ${POSTGRES_VOLUME})"
    log "PostgreSQL volume backed up: postgres-data_${DATE}.tar.gz"
else
    error "PostgreSQL volume directory not found: ${POSTGRES_VOLUME}"
fi

log "Backing up Alfresco data volume..."
if [ -d "${ALFRESCO_VOLUME}" ]; then
    tar -czf "${BACKUP_DIR}/volumes/alfresco-data_${DATE}.tar.gz" -C "$(dirname ${ALFRESCO_VOLUME})" "$(basename ${ALFRESCO_VOLUME})"
    log "Alfresco volume backed up: alfresco-data_${DATE}.tar.gz"
else
    error "Alfresco volume directory not found: ${ALFRESCO_VOLUME}"
fi

log "Backing up ArkCase data volume..."
if [ -d "${ARKCASE_VOLUME}" ]; then
    tar -czf "${BACKUP_DIR}/volumes/arkcase-data_${DATE}.tar.gz" -C "$(dirname ${ARKCASE_VOLUME})" "$(basename ${ARKCASE_VOLUME})"
    log "ArkCase volume backed up: arkcase-data_${DATE}.tar.gz"
else
    error "ArkCase volume directory not found: ${ARKCASE_VOLUME}"
fi

# Create a manifest file
MANIFEST_FILE="${BACKUP_DIR}/backup_manifest_${DATE}.txt"
cat > "${MANIFEST_FILE}" <<EOF
ArkCase Backup Manifest
Date: ${DATE}
Hostname: $(hostname)
Podman Version: $(podman --version)

Database Backups:
$(ls -lh ${BACKUP_DIR}/database/*${DATE}* 2>/dev/null || echo "No database backups found")

Volume Backups:
$(ls -lh ${BACKUP_DIR}/volumes/*${DATE}* 2>/dev/null || echo "No volume backups found")

Docker Compose Configuration:
$(cat /opt/arkcase/docker-compose.yml 2>/dev/null | head -20 || echo "Compose file not found")

Environment:
$(grep -v "PASSWORD" /opt/arkcase/.env 2>/dev/null || echo ".env file not found")
EOF

log "Manifest created: ${MANIFEST_FILE}"

# Cleanup old backups
log "Cleaning up backups older than ${RETENTION_DAYS} days..."
find "${BACKUP_DIR}/database" -name "*.sql.gz" -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_DIR}/volumes" -name "*.tar.gz" -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_DIR}/logs" -name "backup_*.log" -mtime +${RETENTION_DAYS} -delete
find "${BACKUP_DIR}" -name "backup_manifest_*.txt" -mtime +${RETENTION_DAYS} -delete
log "Cleanup completed"

# Calculate backup sizes
DB_SIZE=$(du -sh "${BACKUP_DIR}/database" | cut -f1)
VOL_SIZE=$(du -sh "${BACKUP_DIR}/volumes" | cut -f1)
TOTAL_SIZE=$(du -sh "${BACKUP_DIR}" | cut -f1)

log "Backup completed successfully!"
log "Database backups size: ${DB_SIZE}"
log "Volume backups size: ${VOL_SIZE}"
log "Total backup size: ${TOTAL_SIZE}"

# Optional: Send notification (uncomment and configure)
# mail -s "ArkCase Backup Completed - ${DATE}" admin@yourdomain.com < "${LOG_FILE}"

exit 0
