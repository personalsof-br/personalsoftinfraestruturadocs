### Referências

* [Instalação no Debian](https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu)

### Dependências

* [Java 8](../java/install_java)

### Configurar repositório Ubiquiti

```bash
apt-get install dirmngr -y
cat >> /etc/apt/sources.list << EOF

# Ubiquiti UniFi updates
deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti
EOF
apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
apt-get update
```

### Instalar controlador Unifi

```bash
apt-get install unifi -y
```

### Configurar controlador Unifi

```bash
echo 'smallfiles = true' >> /etc/mongodb.conf
rm -f /var/lib/mongodb/journal/*
```

> Tem que trocar a porta do mongodb para 27117 em /etc/mongodb.conf

#### Desabilitar ipv6

```bash
echo net.ipv6.conf.all.disable_ipv6=1 > /etc/sysctl.d/disable_ipv6.conf
```

### Inicialização do controlador Unifi

```bash
/etc/init.d/mongodb restart
/etc/init.d/unifi restart
```


### Consultar logr

```bash
tail /usr/lib/unifi/logs/server.log
tail /usr/lib/unifi/logs/mongod.log
tail /var/log/daemon.log
```

> Acessar em http://localhost: