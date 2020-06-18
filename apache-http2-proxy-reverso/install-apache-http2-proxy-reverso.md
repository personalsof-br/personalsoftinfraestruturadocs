## Instalação

```bash
apt-get install apache2 -y
a2enmod proxy
a2enmod proxy_http
a2enmod rewrite
a2enmod headers

mv /etc/apache2/sites-available /etc/apache2/sites-available.original -R
mkdir /etc/apache2/sites-available

/etc/init.d/apache2 reload
/etc/init.d/apache2 force-reload
```

## Referências

* http://stackoverflow.com/questions/32750724/apache-rewrite-to-a-location
* http://serverfault.com/questions/529128/how-to-merge-multiple-proxypass-directives-in-apache


## Exemplo proxy reverso

```xml
<VirtualHost *:80>
  # Adiciona um trailslash
  RewriteEngine on
  RewriteRule ^(\/[\w\-\_]*)$ $1/ [R]

  <Location /wms/>
    ProxyPass http://10.0.233.230:80/
    ProxyPassReverse http://10.0.233.230:80/
    ProxyPassReverseCookiePath / /wms/
  </Location>

  <Location /trevilubweb/>
    ProxyPass http://10.0.233.233:80/TrevilubWeb/
    ProxyPassReverse http://10.0.233.233:80/TrevilubWeb/
    ProxyPassReverseCookiePath / /trevilubweb/
  </Location>

  ServerName localhost
</VirtualHost>
```
