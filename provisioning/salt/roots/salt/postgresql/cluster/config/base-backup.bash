su - postgres
psql -c "SELECT pg_start_backup('replbackup');"
tar cfP /tmp/master_base_backup.tar /var/lib/pgsql/9.3/data
psql -c "SELECT pg_stop_backup();"
