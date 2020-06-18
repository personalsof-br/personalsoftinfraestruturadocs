apt-get update < /dev/null
apt-get install postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 -y < /dev/null

cp /etc/postgresql/9.4/main/postgresql.conf /etc/postgresql/9.4/main/postgresql.conf.original
sed "s/#listen_addresses = 'localhost'/listen_addresses='*'/g" /etc/postgresql/9.4/main/postgresql.conf.original >/etc/postgresql/9.4/main/postgresql.conf

cp /etc/postgresql/9.4/main/pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf.original
sed 's/127.0.0.1\/32/0.0.0.0\/0/g' /etc/postgresql/9.4/main/pg_hba.conf.original > /etc/postgresql/9.4/main/pg_hba.conf

# troca a senha do su
sudo -u postgres psql postgres
\password postgres
\q

# instalação da extensão adminpack
sudo -u postgres psql
CREATE EXTENSION adminpack;
\q

# acessar
# su - postgres
# psql

# reiniciar
# service postgresql stop
# service postgresql start

