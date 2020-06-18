### Referências

* [Inicialização do tomcat](https://www.mulesoft.com/tcat/tomcat-start)

### Instalar apache-tomcat-9 no debian 9 stretch

```bash
# melhora a performance da inicialização
apt-get -y install haveged < /dev/null

useradd -m -s /bin/bash tomcat

# baixa e descompacta
cd /var/tmp
rm -rf /var/tmp/apache-tomcat
mkdir -p /var/tmp/apache-tomcat
wget http://personalsoft.com.br.s3.amazonaws.com/downloads/apache-tomcat/apache-tomcat-9.0.21.tar.gz -O apache-tomcat.tar.gz
tar xzf apache-tomcat.tar.gz -C apache-tomcat --strip-components 1
rm -f apache-tomcat.tar.gz

# move as aplicações padrões para a pasta webapps.default
mkdir -p /var/tmp/apache-tomcat/webapps.default
mv /var/tmp/apache-tomcat/webapps/docs /var/tmp/apache-tomcat/webapps.default
mv /var/tmp/apache-tomcat/webapps/examples /var/tmp/apache-tomcat/webapps.default
mv /var/tmp/apache-tomcat/webapps/host-manager /var/tmp/apache-tomcat/webapps.default
mv /var/tmp/apache-tomcat/webapps/manager /var/tmp/apache-tomcat/webapps.default
mv /var/tmp/apache-tomcat/webapps/ROOT /var/tmp/apache-tomcat/webapps.default

# context.xml
cp -p /var/tmp/apache-tomcat/conf/context.xml /var/tmp/apache-tomcat/conf/context.xml.original
wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/apache-tomcat/context.xml -O /var/tmp/apache-tomcat/conf/context.xml

# server.xml
cp -p /var/tmp/apache-tomcat/conf/server.xml /var/tmp/apache-tomcat/conf/server.xml.original

# setenv.sh
echo -e "export CATALINA_OPTS='-server -Xms1024m -Xmx1280m -Dfile.encoding=UTF8 -Duser.language=pt -Duser.country=BR -Duser.timezone=America/Sao_Paulo'" > /var/tmp/apache-tomcat/bin/setenv.sh

#
chown -R tomcat:tomcat /var/tmp/apache-tomcat

#
rm -rf /opt/apache-tomcat-9
mv /var/tmp/apache-tomcat /opt/apache-tomcat-9
ln -nfs /opt/apache-tomcat-9 /opt/apache-tomcat

# logrotate
echo -e "/opt/apache-tomcat/logs/*.log /opt/apache-tomcat/logs/*.out /opt/apache-tomcat/logs/*.txt {\n  su root root\n  copytruncate\n  hourly\n  rotate 7\n  compress\n  missingok\n  size 5M\n}" > /etc/logrotate.d/tomcat
chown tomcat:tomcat /etc/logrotate.d/tomcat
\cp -f /etc/cron.daily/logrotate /etc/cron.hourly/

# permissoes
apt-get install -y acl < /dev/null
find /opt/apache-tomcat/* -type d -exec chmod g=+s {} +
find /opt/apache-tomcat/* -type d -exec setfacl -dm group::rwx {} +
```

### sudo para ps_tomcat

```bash
# sudo %ps_tomcat
cat /etc/sudoers | grep ps_tomcat || echo -e '\n%ps_tomcat ALL=(tomcat) NOPASSWD: ALL' >> /etc/sudoers
/etc/init.d/sudo restart
```

### iptables redirect ports 80/443

```bash
echo -e " \
iptables-persistent iptables-persistent/autosave_v4 boolean false
iptables-persistent iptables-persistent/autosave_v6 boolean false
" | debconf-set-selections
export DEBIAN_FRONTEND=noninteractive
apt-get -y install iptables-persistent < /dev/null
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
```

### Configurar auto-inicialização

```bash
wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/apache-tomcat/apache-tomcat.sh -O /etc/init.d/apache-tomcat
chmod a+x /etc/init.d/apache-tomcat
systemctl enable apache-tomcat
service apache-tomcat start
```

### Iniciar

```bash
/etc/init.d/apache-tomcat start
```

### Finalizar

```bash
/etc/init.d/apache-tomcat stop
```

### Iniciar em foreground

```bash
sudo -i -u tomcat /opt/apache-tomcat/bin/catalina.sh run
```

### Ajuste de permissões em servidores antigos

```bash
userdel -rf tomcat
useradd -m -s /bin/bash tomcat
cat >> /etc/sudoers << EOF
%ps_tomcat ALL=(tomcat) NOPASSWD: ALL
EOF
chown tomcat:tomcat /opt/apache-tomcat/ -R
```
