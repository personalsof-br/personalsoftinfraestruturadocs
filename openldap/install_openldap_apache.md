## Referências

* https://www.javacodegeeks.com/2015/09/java-to-ldap-tutorial-including-how-to-install-an-ldap-server-client.html
* http://directory.apache.org/apacheds/basic-ug/1.3-installing-and-starting.html
* 

## Instalação

### Atualizar debian

```bash
apt-get update
```

### Instalar java

```bash
apt-get install openjdk-8-jre -y
```

### Instalar 

```bash
cd /var/tmp
wget http://ftp.unicamp.br/pub/apache//directory/apacheds/dist/2.0.0-M24/apacheds-2.0.0-M24-amd64.deb
dpkg -i apacheds-2.0.0-M24-amd64.deb
systemctl enable apacheds-2.0.0-M24-default
service apacheds-2.0.0-M24-default start
```

```bash
user: uid=admin,ou=system
password: secret
```

### SSL

```bash
keytool -genkey -keyalg "RSA" -dname "cn=personalsoft, o=Personal Soft, c=BR" -alias personalsoft -keystore /var/lib/apacheds-2.0.0-M24/default/personalsoft.ks -storepass secret -validity 3650
chown apacheds:apacheds /var/lib/apacheds-2.0.0-M24/default/personalsoft.ks
chmod 600 /var/lib/apacheds-2.0.0-M24/default/personalsoft.ks
```

### Habilitar port forward das portas 389 e 636

```bash
apt-get install iptables-persistent
iptables -A PREROUTING -t nat -p tcp --dport 389 -j REDIRECT --to-port 10389
iptables -A PREROUTING -t nat -p tcp --dport 636 -j REDIRECT --to-port 10636
mkdir /etc/iptables
iptables-save > /etc/iptables/rules.v4
```

* Desabilitar "Allow Anonymous Access"
* Habilitar "Enable Access Control"
* Adicionar o atributo administrativeRole=accessControlSpecificArea em dc=personalsoft,dc=com,dc=br
* Adicionar atributos em dc=personalsoft,dc=com,dc=br
	* subentry
	* accessControlSubentry

* Permissão para usuários logados realizarem a leitura dos atributos

```ldif
dn: cn=enableSearchForAllUsers,dc=personalsoft,dc=com,dc=br
objectClass: top
objectClass: subentry
objectClass: accessControlSubentry
subtreeSpecification: {}
prescriptiveACI: 
{ 
  identificationTag "enableSearchForAllUsers",
  precedence 10,
  authenticationLevel simple,
  itemOrUserFirst userFirst: 
  { 
    userClasses { allUsers }, 
    userPermissions 
    { 
      {
          protectedItems {entry, allUserAttributeTypesAndValues}
          grantsAndDenials { grantRead, grantReturnDN, grantBrowse }
    }
  }
}
```

* Permissão para usuários logados alterarem a própria senha

```ldif
dn: cn=allowSelfAccessAndModification,dc=personalsoft,dc=com,dc=br
objectClass: top
objectClass: subentry
objectClass: accessControlSubentry
subtreeSpecification: {}
prescriptiveACI: 
{
  identificationTag "allowSelfAccessAndModification",
  precedence 14,
  authenticationLevel none,
  itemOrUserFirst userFirst: 
  {
    userClasses { thisEntry },
    userPermissions 
    { 
      { protectedItems {entry}, grantsAndDenials { grantModify, grantBrowse, grantRead } },
      { protectedItems {allAttributeValues {userPassword}}, grantsAndDenials { grantAdd, grantRemove } }
    } 
  } 
}
```

```bash
dc=personalsoft,dc=com,dc=br
	ou=people,dc=personalsoft,dc=com,dc=br
		uid=fabiano.bonin,ou=people,dc=personalsoft,dc=com,dc=br
```

IMPORTANTE
http://directory.apache.org/apacheds/basic-ug/3.2-basic-authorization.html#authorization-for-directory-operations-vs-group-membership
Default authorization behavior for directory operations
Without access controls enabled all entries are accessible and alterable by all: even anonymous users. There are however some minimal built-in rules for protecting users and groups within the server without having to turn on the ACI subsystem.
