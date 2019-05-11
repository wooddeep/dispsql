#  
# /bin/bash
#  author: lihan@migu.cn
#

su - postgres
export PATH=/usr/pgsql-11/bin:$PATH

cd /var/lib/pgsql
chmod 777 -R /var/lib/pgsql
initdb -D citus
echo "shared_preload_libraries = 'citus'" >> citus/postgresql.conf
echo "host    all    all    0.0.0.0/0       trust"  >> citus/pg_hba.conf
pg_ctl -D citus -o "-p 9700 -h 0.0.0.0" -l logfile start
psql -p 9700 -c "CREATE EXTENSION citus;"
tail -f logfile