### Preparar debian 8 (jessie)

```bash
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
```

### Preparar debian 9 (stretch)

```bash
echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
```

### Preparar debian 10 (stretch)

```bash
apt-get install gnupg << 
echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
```

### Instalar versão 9.6

```bash
apt-get install postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 -y
```

### Configurar versão 9.6

```bash
cp /etc/postgresql/9.6/main/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf.original
sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /etc/postgresql/9.6/main/postgresql.conf

cp /etc/postgresql/9.6/main/pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf.original
sed -i "s/127.0.0.1\/32/0.0.0.0\/0/g" /etc/postgresql/9.6/main/pg_hba.conf
```

### Instalar versão 10

```bash
apt-get install postgresql-10 postgresql-client-10 postgresql-contrib-10 -y
```

### Configurar versão 10

```bash
cp /etc/postgresql/10/main/postgresql.conf /etc/postgresql/10/main/postgresql.conf.original
sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /etc/postgresql/10/main/postgresql.conf

cp /etc/postgresql/10/main/pg_hba.conf /etc/postgresql/10/main/pg_hba.conf.original
sed -i "s/127.0.0.1\/32/0.0.0.0\/0/g" /etc/postgresql/10/main/pg_hba.conf
```

### Instalar versão 11

```bash
apt-get install postgresql-11 postgresql-client-11 postgresql-contrib-11 -y
```

### Configurar versão 11

```bash
cp /etc/postgresql/11/main/postgresql.conf /etc/postgresql/11/main/postgresql.conf.original
sed -i "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /etc/postgresql/11/main/postgresql.conf

cp /etc/postgresql/11/main/pg_hba.conf /etc/postgresql/11/main/pg_hba.conf.original
sed -i "s/127.0.0.1\/32/0.0.0.0\/0/g" /etc/postgresql/11/main/pg_hba.conf
```

### Reiniciar

```bash
service postgresql restart
```

```bash
pg_ctlcluster 11 main stop
pg_ctlcluster 11 main start
```

## Configurar

### Criar tablespace

```bash
mkdir -p /share/postgresql/personalsoft
chown postgres:postgres /share/postgresql/personalsoft
```

```bash
su - postgres
psql
create extension adminpack;
create tablespace personalsoft location '/share/postgresql/personalsoft';
\q
```

### Criar database

```bash
su - postgres
psql
create database database tablespace personalsoft;
\c database
\q
```

### Alterar senha

```bash
su - postgres
psql
\password postgres
\q
```

### Tunar

```bash
su - postgres
psql
show data_directory; # diretório de dados
show shared_buffers; # 25% da memória
show work_mem; # 16MB
show effective_cache_size; # 50% da memória
show checkpoint_segments; # 16 (pg 9.6)
show max_wal_size; # 1GB (pg 10)
show autovacuum; # on
```

## Manutenção

### .pgpass

```bash
echo "# hostname:port:database:username:password" > ~/.pgpass
echo "*:*:*:postgres:password" >> ~/.pgpass
chmod 0600 ~/.pgpass
```

### Backup

```bash
pg_dump -h localhost -p 5432 -d wms -U postgres -Fc -v -f wms.dump
```

### Restore

```bash
pg_restore -h localhost -p 5432 -d wms -U postgres -j 8 --no-owner --no-acl -v wms.dump
```

### Conferir espaço ocupado pelas tabelas

```sql
select
  relname as "table",
  pg_size_pretty(pg_total_relation_size(relid)) as "table_size+indices",
  pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) as "table_size"
from
  pg_catalog.pg_statio_user_tables
order by
  pg_total_relation_size(relid) desc;
```

### Atualizar

```bash
# https://scottlinux.com/2015/11/14/upgrade-postgresql-on-debian-jessie-with-pg_upgradecluster
apt-get install postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 -y
pg_dropcluster --stop 9.6 main
pg_upgradecluster -v 9.6 9.4 main
```
