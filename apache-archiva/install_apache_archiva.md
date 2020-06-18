# WAR

> requer Apache Tomcat em /opt/apache-tomcat

```bash
wget http://search.maven.org/remotecontent?filepath=org/apache/derby/derby/10.1.3.1/derby-10.1.3.1.jar -O /opt/apache-tomcat/lib/derby-10.1.3.1.jar
wget http://search.maven.org/remotecontent?filepath=javax/activation/activation/1.1.1/activation-1.1.1.jar -O /opt/apache-tomcat/lib/activation-1.1.1.jar
wget http://search.maven.org/remotecontent?filepath=javax/mail/mail/1.4/mail-1.4.jar -O /opt/apache-tomcat/lib/mail-1.4.jar

mkdir -p /archiva
mkdir -p /opt/apache-tomcat/archiva
mkdir -p /opt/apache-tomcat/conf/Catalina/localhost
mkdir -p /root/.m2

cd /opt/apache-tomcat/archiva
wget http://ftp.unicamp.br/pub/apache/archiva/2.1.0/binaries/apache-archiva-2.1.0.war

nano /opt/apache-tomcat/conf/Catalina/localhost/ROOT.xml
<Context path="" docBase="${catalina.home}/archiva/apache-archiva-2.1.0.war">
  <Resource name="jdbc/users" auth="Container" type="javax.sql.DataSource"
    username="sa"
    password=""
    driverClassName="org.apache.derby.jdbc.EmbeddedDriver"
    url="jdbc:derby:/archiva/users;create=true" />
  <Resource name="mail/Session" auth="Container"
    type="javax.mail.Session"
    mail.smtp.host="localhost"/>
</Context>
```

# STANDALONE

```bash
cd /opt
wget http://ftp.unicamp.br/pub/apache/archiva/1.3.6/binaries/apache-archiva-1.3.6-bin.zip
unzip apache-archiva-1.3.6-bin.zip
ln -sf apache-archiva-1.3.6 apache-archiva
echo 'security.policy.password.expiration.enabled=false' > /opt/apache-archiva/conf/security.properties
/opt/apache-archiva/bin/archiva start
# Depois de um bom tempo, acesse o Archiva em http://host:8080/archiva e configure o usuário admin
```
