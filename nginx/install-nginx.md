# https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms

VAADIN + PUSH + NGINX
https://vaadin.com/forum#!/thread/11538752

sudo -i

apt-get update
apt-get install nginx -y

# Backup da configuração padrão
cd /etc/nginx
cp sites-available sites-available.original -R

# Certificado auto-assinado
cd /etc/nginx
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/cert.key -out /etc/nginx/cert.crt
chmod 600 cert.*

# Certificado existente (private key criptografada)
cd /etc/nginx
wget ... -o ca.crt
wget ... -o cert.crt
wget ... -o cert.key
# Descriptografa a private key
openssl rsa -in cert.key -out cert.key
chmod 600 ca.*
chmod 600 cert.*

# Certificado obtido por CSR
cd /etc/nginx
openssl genrsa -out cert.key 2048
openssl req -new -sha256 -key cert.key -out cert.csr
# Enviar o CSR para um certificate provider
wget ... -o cert.crt
chmod 600 cert.*

# Reverse proxy (alterar o donínio de acordo com o certificado)
cat > /etc/nginx/sites-available/default << 'EOL'
#server {
#  listen 80;
#
#  location / {
#    proxy_pass http://localhost/;
#    proxy_set_header X-Real-IP $remote_addr;
#    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#    proxy_buffering off;
#  }
#
#  location /path/ {
#    proxy_pass http://localhost:80/;
#    proxy_set_header X-Real-IP $remote_addr;
#    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
#    proxy_buffering off;
#  }
#
#  access_log /var/log/nginx/access.log;
#  client_max_body_size 150m;
#}

server {
  listen 443;

  ssl_trusted_certificate /etc/nginx/ca.crt;
  ssl_certificate /etc/nginx/cert.crt;
  ssl_certificate_key /etc/nginx/cert.key;
    
  ssl on;
  ssl_session_cache builtin:1000 shared:SSL:10m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers HIGH:!aNULL:!eNULL:!EXPORT:!CAMELLIA:!DES:!MD5:!PSK:!RC4;
  ssl_prefer_server_ciphers on;

  location / {
    proxy_pass http://localhost/;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_buffering off;
  }

  access_log /var/log/nginx/access.log;
  client_max_body_size 150m;
}
EOL
