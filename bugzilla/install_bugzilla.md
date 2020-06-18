# BUGZILLA
# http://www.thegeekstuff.com/2010/05/install-bugzilla-on-linux

#
# Instalação
# Linux Debian 7.5 64 bits
#

#
# diversos
#########################
apt-get install chkconfig

#
# gcc/make
#########################
apt-get -y install gcc
apt-get -y install make

#
# apache2
#########################
apt-get -y install apache2
# apache2 - ativação do suporte a ssl
a2ensite default-ssl
a2enmod ssl

mkdir /etc/apache2/ssl
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt

service apache2 restart

#
# mysql
#########################
apt-get -y install mysql-server # usar a senha 'root'
apt-get -y install mysql-client
service mysql restart

# cria o banco de dados
mysql -u root -proot -e "create database bugs default character set utf8"
# cria o usuário 'bugs', senha em branco, e atribui as permissões
mysql -u root -proot -e "GRANT SELECT, INSERT, UPDATE, DELETE, INDEX, ALTER, CREATE, LOCK TABLES, CREATE TEMPORARY TABLES, DROP, REFERENCES ON bugs.* TO bugs@localhost IDENTIFIED BY '';FLUSH PRIVILEGES;"

#
# bugzilla
#########################
cd /opt
wget http://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-LATEST.tar.gz
tar xzf bugzilla-LATEST.tar.gz
mv bugzilla-4.5.4 bugzilla
chown www-data:www-data bugzilla -R
cd bugzilla

# suporte a SMTP com SSL (isto pode ser opcional em futuras versões do debian ou em outras distribuições)
apt-get install libnet-smtp-ssl-perl

# instala as dependências do perl
perl install-module.pl --all

# suporte a SMTP com SSL (talvez já tenha sido instalado acima)
perl install-module.pl Net::SMTP::SSL

# verifica os módulos
./checksetup.pl --check-modules

# cria o arquivo de configurações
./checksetup.pl

# cria o banco de dados
./checksetup.pl

echo "<VirtualHost *:80>
  ServerName bugzilla.personalsoft.com.br
  DocumentRoot /opt/bugzilla

  Redirect permanent / https://bugzilla.personalsoft.com.br
</VirtualHost>

<VirtualHost *:443>
  ServerName bugzilla.personalsoft.com.br
  DocumentRoot /opt/bugzilla

  SSLEngine On
  SSLCertificateFile /etc/apache2/ssl/apache.crt
  SSLCertificateKeyFile /etc/apache2/ssl/apache.key
</VirtualHost>

<Directory /opt/bugzilla>
  AddHandler cgi-script .cgi
  Options +ExecCGI
  DirectoryIndex index.cgi index.html
  AllowOverride Limit FileInfo Indexes Options
</Directory>" > /etc/apache2/conf.d/bugzilla.conf

service apache2 restart

#
# Atualização
# Linux Debian 7.5 64 bits
#

# backup do banco de dados
mysqldump -u root -proot bugs > /var/tmp/bugs.sql

# atualização do bugzilla

cd /opt
wget http://ftp.mozilla.org/pub/mozilla.org/webtools/bugzilla-LATEST.tar.gz
tar xzf bugzilla-LATEST.tar.gz
cd bugzilla-x.y.z
cp ../bugzilla/localconfig* .
cp -r ../bugzilla/data .
cd ..
bugzilla bugzilla.old
bugzilla-x.y.z bugzilla
cd bugzilla
./checksetup.pl

# DIVERSOS

# Importação de uma instalação anterior do Bugzilla
mysql -u root -proot -e "create database bugs default character set utf8"
mysql -u root -proot bugs < ./bugzilla-backup.sql
cd /opt/bugzilla
./checksetup.pl

# Configuração do SMTP do Bugzilla
mailfrom: mailrelay@personalsoft.com.br
smtpserver: smtp.gmail.com:465
smtp_username: mailrelay@personalsoft.com.br
smtp_password: ?
smtp_ssl: on
