# Zabbix

<https://www.zabbix.com/documentation/3.0/manual/installation/install_from_packages/repository_installation>
<https://www.zabbix.com/documentation/3.2/manual/installation/install_from_packages/server_installation_with_postgresql>

## Instalação do server

* Preparar um servidor debian
* Instalar o postgresql

```sh
cd /var/tmp
wget http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+jessie_all.deb
dpkg -i zabbix-release_3.2-1+jessie_all.deb
apt-get update

apt-get install zabbix-server-pgsql zabbix-frontend-php -y

su - postgres
psql postgres
create extension adminpack;
create database zabbix;
create user zabbix;
alter user zabbix encrypted password 'zabbix';
\q
zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | psql -h localhost zabbix zabbix

nano /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<username_password>

nano /etc/zabbix/apache.conf
php_value date.timezone America/Sao_Paulo

service apache2 restart
```

<http://localhost/zabbix>

* Terminal a configuração

## Acesso

* <http://localhost/zabbix>
* User: Admin
* Password: zabbix

## Instalação do cliente

```sh
cd /tmp
wget http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+jessie_all.deb
dpkg -i zabbix-release_3.2-1+jessie_all.deb
apt-get update
apt-get install zabbix-agent zabbix-get zabbix-sender -y

cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.original
sed 's/=127.0.0.1/=zabbix.trevilub.com.br/g' /etc/zabbix/zabbix_agentd.conf.original > /var/tmp/zabbix
sed 's/Hostname=Zabbix server/Hostname='$(hostname)'/g' /var/tmp/zabbix > /etc/zabbix/zabbix_agentd.conf

echo '10.0.1.10 zabbix.trevilub.com.br' >> /etc/hosts

service zabbix-agent restart
```
