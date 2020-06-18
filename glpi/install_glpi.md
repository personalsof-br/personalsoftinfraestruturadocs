# dependencias
apt-get install apache2 php5 mysql-server php5-mysql php5-ldap php5-dev php5-json php5-curl php5-imap php5-gd

# glpi
cd /var/tmp
wget https://github.com/glpi-project/glpi/releases/download/9.1.1/glpi-9.1.1.tgz
tar xzf glpi-9.1.1.tgz

#
mv glpi /var/www/html/
chgrp www-data -R /var/www/html/glpi

#
/etc/init.d/apache2 restart

#
glpi/glpi para a conta do usuário administrador
tech/tech para a conta do usuário técnico
normal/normal para a conta do usuário normal
post-only/postonly para a conta do usuário postonly

#
* Configurar/notificações/Habilitar acompanhamentos por e-mail
* Configurar/notificações/Configuração de acompanhamentos por e-mail
  * Modo: SMTP+SSL
  * Servidor: smtp.gmail.com
  * Login: helpdesk@personalsoft.com.br
  * Porta: 465
  * Senha: fbfe2a335e0c
* Setup/Receivers
  * +
    * Name: helpdesk@personalsoft.com.br
    * Sever: imap.gmail.com
    * Connection options: IMAP/SSL
    * Port: 993
    * Login: helpdesk@personalsoft.com.br
    * Password: fbfe2a335e0c
* Setup/General
  * Assistance
    * Allow anonymous ticket creation: yes
* Setup/Automatic actions
  * mailgate
    * Run mode: CLI
* crontab -e
*/1 * * * * /usr/bin/php /var/www/html/glpi/front/cron.php
