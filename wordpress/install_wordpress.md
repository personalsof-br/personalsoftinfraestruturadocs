# Instalar o wordpress da bitnami
# SSH user: bitnami
# Wordpress user: user
# Wordpress password: system log (aws console ou /var/log/boot.log)

# Adicionar esta configuração acima da linha /* That's all, stop editing...
nano /opt/bitnami/apps/wordpress/htdocs/wp-config.php
/** SSL admin */
define('FORCE_SSL_ADMIN', true);

# Certificados em /opt/bitnami/apache2/conf
# server-ca.crt
# server.crt
# server.key
nano /opt/bitnami/apache2/conf/extra/httpd-ssl.conf

# Desabilitar banner
/opt/bitnami/apps/wordpress/bnconfig --disable_banner 1

# após
# require_once(ABSPATH . 'wp-settings.php');
nano /opt/bitnami/apps/wordpress/htdocs/wp-config.php
/* workaround from bitnami */
add_filter('https_ssl_verify', '__return_false');
add_filter('https_local_ssl_verify', '__return_false');

# Reiniciar os serviços
/etc/init.d/bitnami restart
