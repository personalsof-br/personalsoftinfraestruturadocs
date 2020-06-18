# Certificados em /opt/bitnami/apache2/conf
# Configuração em /opt/bitnami/apache2/conf/extra/httpd-ssl.conf

# remover o logo
/opt/bitnami/apps/redmine/bnconfig --disable_banner 1

# configurar e-mail
nano /opt/bitnami/apps/redmine/htdocs/config/configuration.yml

# configurações AWS
  email_delivery:
    delivery_method: :smtp
    smtp_settings:
      address: email-smtp.us-east-1.amazonaws.com
      port: 465
      ssl: true
      enable_starttls_auto: true
      domain: personalsoft.com.br
      authentication: :login
      user_name: <key>
      password: <smtp password>

# theme
mkdir /opt/bitnami/apps/redmine/htdocs/public/themes/my-theme
mkdir /opt/bitnami/apps/redmine/htdocs/public/themes/my-theme/stylesheets
touch /opt/bitnami/apps/redmine/htdocs/public/themes/my-theme/stylesheets/application.css
chown bitnami:daemon /opt/bitnami/apps/redmine/htdocs/public/themes/my-theme -R

# application.css
@import url(../../../stylesheets/application.css);

#top-menu {
  background: #e01000;
}

#header {
  background-color: white;
  background-image: url(http://personalsoft.com.br/wp-content/uploads/2017/02/personal-soft-marca.png);
  background-position: 0.5em 0.5em;
  background-repeat: no-repeat;
  background-size: auto 50%;
  color: transparent;
}

#header a {
  color: white;
}

#main-menu li a {
  background-color: white;
  color: #ef7c00;
}

#main-menu li a.new-object {
  background-color: white;
  color: #ef7c00;
}

#a, a:link, a:visited {
  color: #ef7c00;
}
