* https://medium.freecodecamp.org/how-we-fine-tuned-haproxy-to-achieve-2-000-000-concurrent-ssl-connections-d017e61a4d27

### Instalar

```bash
apt-get install haproxy -y
```

### Certificado auto-assinado

```bash
mkdir /etc/ssl/haproxy
openssl genrsa -out /etc/ssl/haproxy/localhost.key 4096
openssl req -new -key /etc/ssl/haproxy/localhost.key -out /etc/ssl/haproxy/localhost.csr
openssl x509 -req -days 3650 -in /etc/ssl/haproxy/localhost.csr -signkey /etc/ssl/haproxy/localhost.key -out /etc/ssl/haproxy/localhost.crt
cat /etc/ssl/haproxy/localhost.crt /etc/ssl/haproxy/localhost.key | tee /etc/ssl/haproxy/localhost.pem
chmod 600 /etc/ssl/haproxy -R
chown haproxy:haproxy /etc/ssl/haproxy -R
```

### Certificado adquirido

```bash
mkdir -p /etc/ssl/haproxy
cd /etc/ssl/haproxy
# baixar os arquivos do certificado
# concatenar crt + key + ca
cat localhost.crt localhost.key localhost.ca | tee localhost.pem
chmod 600 /etc/ssl/haproxy -R
chown haproxy:haproxy /etc/ssl/haproxy -R
```

### Configurar

```bash
nano /etc/haproxy/haproxy.cfg
```

```
frontend frontend1
  bind *:80
  bind *:443 ssl crt /etc/ssl/haproxy/localhost.pem
  redirect scheme https if !{ ssl_fc }
  mode http
  stats uri /haproxy?stats
  default_backend backend1

backend backend1
  balance roundrobin
  server s1 localhost:8080 check
```

### Iniciar

```bash
/etc/init.d/haproxy start
```

### Finalizar

```bash
/etc/init.d/haproxy stop
```

### Logs

```bash
tail -f -n 100 /var/logs/haproxy.log
```
