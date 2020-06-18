#
yum -y install httpd
yum -y install mod_ssl

#
vi /etc/httpd/conf.d/namevirtualhost.conf
NameVirtualHost *:80
NameVirtualHost *:443

#
vi /etc/httpd/conf.d/domain.com.conf
<VirtualHost *:80>
  ServerName domain.com
  Redirect permanent / https://domain.com
</VirtualHost>

<VirtualHost *:443>
  ServerName domain.com
  DocumentRoot /var/www/html/domain.com
  SSLEngine On
  SSLCertificateFile /var/www/ssl/domain.com/localhost.crt
  SSLCertificateKeyFile /var/www/ssl/domain.com/localhost.key
  SSLCertificateChainFile /var/www/ssl/domain.com/server-chain.crt
</VirtualHost>

#
chmod 600 /var/www/ssl/* -R
chown root.root /var/www/ssl/* -R

#
mkdir /var/www/html/domain.com

#
service httpd start

# Decriptografa a chave privada
openssl rsa -in host.key -out host.unsecure.key
