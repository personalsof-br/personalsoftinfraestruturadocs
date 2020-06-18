# Aborta o script em caso de erro
function error_trap() {
  echo "$0: line $1: exit status $2"
  exit $2
}
trap 'error_trap ${LINENO} $?' ERR

# Aborta o script em caso de variavel nao declarada
set -u

# Identifica a etapa
etapa() {
  echo ""
  echo "# $1"
}

# Codigo da atualizacao
ATUALIZACAO="pro-meta-atualizacao-01"

etapa "Criando as pastas padroes"

if [ ! -d /ps ]
then
  mkdir /ps
fi

if [ ! -d /ps/atualizacoes ]
then
  mkdir /ps/atualizacoes
fi

etapa "Verificando se a atualizacao ${ATUALIZACAO} ja foi executada"

if [ -f "/ps/atualizacoes/${ATUALIZACAO}" ]
then
  echo "A atualizacao ${ATUALIZACAO} ja foi executada"
  exit 0
fi

etapa "Verificando se a atualizacao ${ATUALIZACAO} foi interrompida"

if [ -f "/ps/atualizacoes/${ATUALIZACAO}.tmp" ]
then
  echo "A atualizacao ${ATUALIZACAO} nao foi finalizada" && false
fi

etapa "Criando um arquivo para validar o final da atualizacao"

touch /ps/atualizacoes/${ATUALIZACAO}.tmp

etapa "Instalando os pacotes adicionais"

yum -y install xinetd
/sbin/service xinetd start || true

etapa "Criando o arquivo /etc/profile.d/personalsoft_profile.sh"

touch /etc/profile.d/personalsoft_profile.sh

etapa "Registrando os aliases do shell"

echo "alias rm='rm -i'" >> /etc/profile.d/personalsoft_profile.sh
echo "" >> /etc/profile.d/personalsoft_profile.sh

etapa "Instalando o Java"

cd /opt
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/java/jre-7u21-linux-x64.gz
tar xzf jre-7u21-linux-x64.gz
rm -f jre-7u21-linux-x64.gz
chown root.root jre1.7.0_21 -R
ln -s jre1.7.0_21 java
ln -s jre1.7.0_21 jre
echo -e "export JAVA_HOME=/opt/java" >> /etc/profile.d/personalsoft_profile.sh
echo -e "export JRE_HOME=/opt/jre" >> /etc/profile.d/personalsoft_profile.sh
echo -e "" >> /etc/profile.d/personalsoft_profile.sh

/usr/sbin/alternatives --install /usr/bin/java java /opt/java/bin/java 100000 || true

etapa "Instalando o Apache Tomcat"

cd /opt
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/apache-tomcat/apache-tomcat-7.0.39.zip
unzip apache-tomcat-7.0.39.zip
rm -f apache-tomcat-7.0.39.zip
ln -s apache-tomcat-7.0.39 apache-tomcat

echo -e "export CATALINA_OPTS=\"-server -Xms256m -Xmx512m -XX:PermSize=128m -XX:MaxPermSize=256m\"" >> /etc/profile.d/personalsoft_profile.sh
echo -e "" >> /etc/profile.d/personalsoft_profile.sh

echo "" >> /etc/rc.local
echo "/opt/apache-tomcat/bin/startup.sh" >> /etc/rc.local

rm /opt/apache-tomcat/webapps/ROOT -rf
rm /opt/apache-tomcat/webapps/docs -rf
rm /opt/apache-tomcat/webapps/examples -rf

cp /opt/apache-tomcat/conf/server.xml /opt/apache-tomcat/conf/server.xml.original
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/pro-meta/apache-tomcat/server.xml -O /opt/apache-tomcat/conf/server.xml

cp /opt/apache-tomcat/conf/web.xml /opt/apache-tomcat/conf/web.xml.original
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/pro-meta/apache-tomcat/web.xml -O /opt/apache-tomcat/conf/web.xml

mkdir /opt/apache-tomcat/ssl
chmod 700 /opt/apache-tomcat/ssl
touch /opt/apache-tomcat/ssl/.keystore
chmod 600 /opt/apache-tomcat/ssl/.keystore
wget -q --no-check-certificate --user=infraestrutura --password=BG4CnidCSOv92dG https://svn.personalsoft.com.br/infraestrutura/pro-meta/apache-tomcat/wildcard.pro-meta.net.br.jks -O /opt/apache-tomcat/ssl/.keystore

chown root.root apache-tomcat-7.0.39 -R
chmod u+x /opt/apache-tomcat/bin/*.sh
chmod 600 /opt/apache-tomcat/conf/*.xml

etapa "Criando as pastas do sistema"

mkdir /ps/dados
mkdir /ps/dados/firebird

etapa "Instalando o Firebird"

cd /var/tmp
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/firebird/FirebirdCS-2.5.2.26540-0.amd64.tar.gz
tar xzf FirebirdCS-2.5.2.26540-0.amd64.tar.gz
cd FirebirdCS-2.5.2.26540-0.amd64
./install.sh -silent
ln -sf /opt/firebird/bin/fbguard /usr/bin/
ln -sf /opt/firebird/bin/fbmgr /usr/bin/
ln -sf /opt/firebird/bin/fbserver /usr/bin/
ln -sf /opt/firebird/bin/gbak /usr/bin/
ln -sf /opt/firebird/bin/gfix /usr/bin/
ln -sf /opt/firebird/bin/gsec /usr/bin/
ln -sf /opt/firebird/bin/gstat /usr/bin/
ln -sf /opt/firebird/bin/isql /usr/bin/
ln -sf /opt/firebird/bin/nbackup /usr/bin/
gsec -user sysdba -password -modify sysdba -pw km100
gsec -user sysdba -password km100 -add psillisp -pw lisppsil
cd /var/tmp
rm -rf /var/tmp/Firebird*

etapa "Criando o banco de dados"

echo 'prometa = /ps/dados/firebird/prometa.fdb' > /opt/firebird/aliases.conf
cd /var/tmp
echo "create database 'prometa' page_size 4096 default character set iso8859_1;" > script.sql
isql -i script.sql
chown firebird:firebird /ps/dados/firebird/prometa.fdb
rm -f script.sql

etapa "Instalando o PhantomJS"

cd /opt
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/phantomjs/phantomjs-1.9.0-linux-x86_64.tar.bz2
tar xjf phantomjs-1.9.0-linux-x86_64.tar.bz2
rm -f phantomjs-1.9.0-linux-x86_64.tar.bz2
ln -s phantomjs-1.9.0-linux-x86_64 phantomjs
echo -e "export PATH=\$PATH:/opt/phantomjs/bin" >> /etc/profile.d/personalsoft_profile.sh
echo "" >> /etc/profile.d/personalsoft_profile.sh

etapa "Configuranto o fuso horario"

mv /etc/localtime /etc/localtime.original
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

etapa "Configurando a linguagem"

cp /etc/sysconfig/i18n /etc/sysconfig/i18n.original
echo 'LANG="pt_BR.ISO-8859-1"' > /etc/sysconfig/i18n

etapa "Registra a atualizacao"

mv /ps/atualizacoes/${ATUALIZACAO}.tmp /ps/atualizacoes/${ATUALIZACAO}
