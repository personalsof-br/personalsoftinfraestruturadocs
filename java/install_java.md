### Links

* <https://adoptopenjdk.net/>
* <https://jdk.java.net/>
* <https://jdk.java.net/java-se-ri/11>
* <https://openjdk.java.net/>

### Instalar openjdk-11 (LTS) no windows

* Baixe em <http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_windows_openj9_11.0.3_7_openj9-0.14.3.zip>
	* Ou baixe em <http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_windows_hotspot_11.0.3_7.zip>
* Descompacte em "C:\Program Files\Java\jdk-11" (sistema) ou "C:\Users\<user>\Java\jdk-11" (usuário)
* Acesse "Painel de Controle\Sistema e Segurança\Sistema"
* Clique em "Configurações avançadas do sistema"
* Clique em "Variáveis de Ambiente"
* Dependendo do local de instalação (sistema ou usuário), realize as alterações abaixo nas "Variáveis do sistema" ou nas "Variáveis de usuário"
	* Adicione a variável "JAVA_HOME" apontando para a pasta de instalação do Java
		* Ex: JAVA_HOME = C:\Program Files\Java\jdk-11 ou C:\Users\usuario\Java\jdk-11
	* Edite a variável "Path", adicionando a entrada "%JAVA_HOME%\bin"

### Instalar openjdk-11 (LTS) no windows pelo instalador

* Baixe em <http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_windows_openj9_11.0.3_7_openj9-0.14.3.msi>
	* Ou baixe em <http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_windows_hotspot_11.0.3_7.msi>
* Execute o instalador

### Instalar openjdk-11 (LTS) no debian

```bash
useradd -m -s /bin/bash java
cd /var/tmp/
rm -rf /var/tmp/java
mkdir -p /var/tmp/java
# wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_linux_hotspot_11.0.3_7.tar.gz -O java.tar.gz
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK11U-jdk_x64_linux_openj9_11.0.3_7_openj9-0.14.3.tar.gz -O java.tar.gz
tar xzf java.tar.gz -C java --strip-components 1
chown -R java:java /var/tmp/java
rm -f java.tar.gz
rm -rf /opt/jdk-11
mv /var/tmp/java /opt/jdk-11
ln -nfs /opt/jdk-11 /opt/jdk
cat > /etc/profile.d/java.sh << EOF
export JAVA_HOME=/opt/jdk
export JAVA_OPTS='-Duser.language=pt -Duser.country=BR -Duser.variant=BR'
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
chown java:java /etc/profile.d/java.sh
. /etc/profile.d/java.sh
```

### Instalar openjdk-8 (LTS) no debian

```bash
# temporário (bug nesta build do OpenJDK8 afeta jasperreports)
apt-get -y install fontconfig < /dev/null
useradd -m -s /bin/bash java
cd /var/tmp/
rm -rf /var/tmp/java
mkdir -p /var/tmp/java
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/java/OpenJDK8U-jdk_x64_linux_openj9_8u212b04_openj9-0.14.2.tar.gz -O java.tar.gz
tar xzf java.tar.gz -C java --strip-components 1
chown -R java:java /var/tmp/java
rm -f java.tar.gz
rm -rf /opt/jdk-8
mv /var/tmp/java /opt/jdk-8
ln -nfs /opt/jdk-8 /opt/jdk
cat > /etc/profile.d/java.sh << EOF
export JAVA_HOME=/opt/jdk
export JAVA_OPTS='-Duser.language=pt -Duser.country=BR -Duser.variant=BR'
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
chown java:java /etc/profile.d/java.sh
. /etc/profile.d/java.sh
```

### Instalar oracle jdk-8 no debian (não recomendado)

```bash
useradd -m -s /bin/bash java
cd /var/tmp/
rm -rf /var/tmp/java
mkdir -p /var/tmp/java
wget -q http://personalsoft.com.br.s3.amazonaws.com/downloads/java/jdk-8u211-linux-x64.tar.gz -O java.tar.gz
tar xzf java.tar.gz -C java --strip-components 1
chown -R java:java /var/tmp/java
rm -f java.tar.gz
rm -rf /opt/jdk-8
mv /var/tmp/java /opt/jdk-8
ln -nfs /opt/jdk-8 /opt/jdk
cat > /etc/profile.d/java.sh << EOF
export JAVA_HOME=/opt/jdk
export JAVA_OPTS='-Duser.language=pt -Duser.country=BR -Duser.variant=BR'
export PATH=\$JAVA_HOME/bin:\$PATH
EOF
chown java:java /etc/profile.d/java.sh
. /etc/profile.d/java.sh
```

### Instalar oracle jdk-8 no windows (não recomendado)

http://personalsoft.com.br.s3.amazonaws.com/downloads/java/jdk-8u241-windows-x64.exe
