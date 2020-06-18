/*
Title: Instalação do OpenNMS
*/

## Referências

* <https://www.opennms.org/en:

## Instalação do servidor

### Instalar dependências

```bash
apt-get install curl -y
cd /var/tmp/
curl -L https://github.com/opennms-forge/opennms-install/archive/1.1.tar.gz | tar xz
cd opennms-install-1.1
bash bootstrap-debian.sh
# YES
# database username: postgres
# database password: pg100100
```

### Alterar senha do postgres

```bash
sudo -u postgres psql
alter user postgres password 'pg100100';
\q
```

### Inicializar banco de dados

```bash
/usr/share/opennms/bin/install -dis
```

### Iniciar serviço

```bash
systemctl start opennms
```

### Acessar

* http://localhost:8980
* user: admin
* password: admin

### Configurar discovery

## Instalação do cliente

* <https://support.atera.com/hc/en-us/articles/220109447-How-To-Monitor-Linux-Servers-Using-SNMP>

```bash
apt-get install snmpd -y
cp /etc/snmp/snmpd.conf{,.bak}
echo "rocommunity personalsoft" > /etc/snmp/snmpd.conf
echo "disk /" >> /etc/snmp/snmpd.conf
systemctl restart snmpd
```
