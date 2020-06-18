# WORDPRESS
# http://codex.wordpress.org/Installing_WordPress
# http://www.shutterstock.com

# PERFORMANCE WORDPRESS + AMAZON MICRO INSTANCE
# http://www.frameloss.org/2011/11/04/making-wordpress-stable-on-ec2-micro

# http://themeforest.net/
# http://themeforest.net/item/spark-a-responsive-onepage-html5-website/full_screen_preview/1350924

# swap
dd if=/dev/zero of=/swapfile bs=1M count=1024
mkswap /swapfile
swapon /swapfile
echo '/swapfile swap swap defaults 0 0' >> /etc/fstab

# mysql
yum -y install mysql-server
yum -y install mysql
/usr/bin/mysqladmin -u root password 'root'

# mysql - performance em ec2 micro instance
mv /etc/my.cnf /etc/my.cnf.original
cp /usr/share/mysql/my-small.cnf /etc/my.cnf
service mysqld restart

# php
yum -y install php
yum -y install php-mysql
yum -y install php-xml
yum -y install php-gd

# httpd
yum -y install httpd
yum -y install mod_ssl
service httpd start

# TODO - Arrumar aqui
editar o arquivo /etc/httpd/conf/httpd.conf
<IfModule prefork.c>
StartServers       8
MinSpareServers    8
MaxSpareServers    8
ServerLimit        8
MaxClients         8
MaxRequestsPerChild  4000
</IfModule>
service httpd restart

# Cria o banco de dados 'wordpress', o usuário 'wordpress' com a senha 'wordpresspassword' e atribui as permissões
mysql -u root -proot
create database wordpress;
GRANT ALL PRIVILEGES ON wordpress.* TO "wordpress"@"localhost" IDENTIFIED BY "wordpresspassword";
FLUSH PRIVILEGES;
exit;

# wordpress
cd /var/www
wget http://br.wordpress.org/wordpress-3.5.2-pt_BR.tar.gz
tar -xzvf wordpress-3.5.2-pt_BR.tar.gz
chown apache:apache /var/www/wordpress -R
cd wordpress
cp -p wp-config-sample.php wp-config.php

# Configura o wordpress com as informações de acesso ao banco de dados
sed -i 's/nomedoBD/wordpress/g' wp-config.php
sed -i 's/username_here/wordpress/g' wp-config.php
sed -i 's/password_here/wordpresspassword/g' wp-config.php
sed -i '82idefine('FORCE_SSL_ADMIN', true);' wp-config.php

# Instala o tema avada
cd /var/www/wordpress/wp-content/themes
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/wordpress/themeforest-2833226-avada-responsive-multipurpose-theme-wordpress_theme.zip
unzip themeforest-2833226-avada-responsive-multipurpose-theme-wordpress_theme.zip
chown apache:apache Avada -R

# Instala o certificado e a chave privada (selecionar o domínio correto)
mkdir /var/www/ssl
cd /var/www/ssl
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/ssl/certs/wildcard.pro-meta.net.br.crt -O /var/www/ssl/host.pem
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/ssl/certs/wildcard.pro-meta.net.br.key -O /var/www/ssl/host.key
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/ssl/certs/startssl-ca.pem -O /var/www/ssl/startssl-ca.pem
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/ssl/certs/startssl-sub.class2.server.ca.pem -O /var/www/ssl/startssl-sub.class2.server.ca.pem
cat startssl-ca.pem startssl-sub.class2.server.ca.pem > ca.crt
touch host.unsecure.key
chown apache:apache /var/www/ssl/* -R
chmod 600 /var/www/ssl/* -R
openssl rsa -in host.key -out host.unsecure.key

# Configura o suporte a SSL no httpd
cd /etc/httpd/conf.d
echo -e 'LoadModule ssl_module modules/mod_ssl.so
Listen 443
SSLPassPhraseDialog  builtin
SSLSessionCache         shmcb:/var/cache/mod_ssl/scache(512000)
SSLSessionCacheTimeout  300
SSLMutex default
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin' > ssl.conf

# Configura o wordpress no httpd
cd /etc/httpd/conf.d
echo -e '<VirtualHost *:80>
  DocumentRoot /var/www/wordpress
</VirtualHost>

<VirtualHost *:443>
  DocumentRoot /var/www/wordpress
  SSLEngine On
  SSLCertificateFile /var/www/ssl/host.pem
  SSLCertificateKeyFile /var/www/ssl/host.unsecure.key
  SSLCertificateChainFile /var/www/ssl/ca.crt
</VirtualHost>

<Directory /var/www/wordpress>
  DirectoryIndex index.php index.html
  AllowOverride Limit FileInfo Indexes Options
</Directory>' > wordpress.conf

# Reinicia o httpd
service httpd restart

chkconfig mysqld on
chkconfig httpd on

shutdown -r now
