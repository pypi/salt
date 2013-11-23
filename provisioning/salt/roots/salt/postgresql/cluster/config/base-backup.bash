#!/bin/bash
psql -c "SELECT pg_start_backup('replbackup');"
tar cfP /var/lib/pgsql/9.3/backups/master_base_backup-$(date +"%s").tar /var/lib/pgsql/9.3/data \
  --exclude=/var/lib/pgsql/9.3/data/postgresql.conf \
  --exclude=/var/lib/pgsql/9.3/data/recovery.conf \
  --exclude=/var/lib/pgsql/9.3/data/recovery.done
psql -c "SELECT pg_stop_backup();"
