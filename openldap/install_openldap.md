## Referências

* <https://help.ubuntu.com/lts/serverguide/openldap-server.html>
* <https://devopsideas.com/installation-configuration-openldap-utilities-ubuntu/>
* <https://www.lisenet.com/2014/install-and-configure-an-openldap-server-with-ssl-on-debian-wheezy/>
* <https://dopensource.com/2017/04/27/installing-openldap-2-4-and-configuring-apache-ds-__-part-1/>
* <http://techpubs.spinlocksolutions.com/dklar/kerberos.html>
* <http://techpubs.spinlocksolutions.com/dklar/ldap.html>
* Tree organization
 * <https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/deployment_guide/designing_the_directory_tree-designing_directory_tree>
* Acesso por grupos (organizationalRole) - Para definir permissões sobre o diretório
 * <https://www.openldap.org/faq/data/cache/52.html>

## Instalação

### Atualizar debian

```bash
apt-get update
```

### Instalar openldap

```bash
apt-get install slapd ldap-utils ldapscripts -y
```

### Factory reset

```bash
service slapd stop
rm /var/lib/ldap/* -f
dpkg-reconfigure slapd
	Omit OpenLDAP server configuration? No
	DNS domain name: personalsoft.com.br
	Organization name? personalsoft
	Administrator password: <deixar em branco>
	Confirm password: <deixar em branco>
	Database backend to use: MDB
	Do you want the database to be removed when slapd is purged? No
```

### Verificar se o serviço está ativo

```bash
ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config
ldapsearch -Y EXTERNAL -H ldapi:/// -b cn=config dn
```

### Atribuir uma senha para o usuário cn=admin,cn=config

```bash
cd /var/tmp
export password=`slappasswd -s senha`
cat > temp.ldif << EOF
dn: olcDatabase={0}config,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $password
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Atribuir uma senha para o usuário cn=admin,dc=personalsoft,dc=com,dc=br

> Esta senha não é a mesma do dn do diretório

```bash
cd /var/tmp
export password=`slappasswd -s senha`
cat > temp.ldif << EOF
dn: olcDatabase={1}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $password
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Desabilitar acesso anônimo

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=config
changetype: modify
add: olcDisallows
olcDisallows: bind_anon
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Habilitar acesso anônimo

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=config
changetype: modify
delete: olcDisallows
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Habilitar o log

> -1 = all, 0 = disable, 256 = connections/operations/results

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: 256
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Habilita os protocolos ldapi, ldap e ldaps

```bash
nano /etc/default/slapd
SLAPD_SERVICES="ldap:/// ldaps:/// ldapi:///"
```

### Certificado auto-assinado

```bash
mkdir -p /etc/ssl/slapd
openssl genrsa -out /etc/ssl/slapd/localhost.key 4096
openssl req -new -key /etc/ssl/slapd/localhost.key -out /etc/ssl/slapd/localhost.csr
openssl x509 -req -days 3650 -in /etc/ssl/slapd/localhost.csr -signkey /etc/ssl/slapd/localhost.key -out /etc/ssl/slapd/localhost.crt
cat /etc/ssl/slapd/localhost.crt /etc/ssl/slapd/localhost.key | tee /etc/ssl/slapd/localhost.pem
chown openldap:openldap /etc/ssl/slapd -R
chmod 700 /etc/ssl/slapd
chmod 600 /etc/ssl/slapd/*
```

> Caso exista uma CA, é necessário informar a propriedade olcTLSCACertificateFile

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=config
changetype: modify
replace: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ssl/slapd/localhost.ca
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=config
changetype: modify
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ssl/slapd/localhost.crt
-
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ssl/slapd/localhost.key
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Usuário para consulta

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=search,dc=personalsoft,dc=com,dc=br
cn: search
objectClass: simpleSecurityObject
objectClass: organizationalRole
userPassword: search
EOF
ldapadd -x -D "cn=admin,cn=config" -W -H ldapi:/// -f temp.ldif
```

> Impede que o usuário "search" altere a própria senha

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: olcDatabase={1}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to dn.exact="cn=search,dc=personalsoft,dc=com,dc=br" attrs=userPassword by self read by anonymous auth by * none
EOF
ldapmodify -Y EXTERNAL -H ldapi:/// -f temp.ldif
```

### Alterar uma senha de usuário

```bash
ldappasswd -x -D cn=admin,dc=personalsoft,dc=com,dc=br -W -S uid=fabiano.bonin,ou=people,dc=personalsoft,dc=com,dc=br
```

### Alterar uma senha de usuário (usando ldif)

```bash
cd /var/tmp
export password=`slappasswd -s senha`
cat > temp.ldif << EOF
dn: uid=fabiano.bonin,ou=people,dc=personalsoft,dc=com,dc=br
changetype: modify
delete: userPassword
-
add: userPassword
userPassword: $password
EOF
ldapmodify -D cn=admin,dc=personalsoft,dc=com,dc=br -W -f temp.ldif
```

### Importar schema sudoRole

```bash
cd /var/tmp
cat > temp.ldif << EOF
dn: cn=sudo,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: sudo
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.1 NAME 'sudoUser' DESC 'User(s) who may  run sudo' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.2 NAME 'sudoHost' DESC 'Host(s) who may run sudo' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.3 NAME 'sudoCommand' DESC 'Command(s) to be executed by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.4 NAME 'sudoRunAs' DESC 'User(s) impersonated by sudo (deprecated)' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.5 NAME 'sudoOption' DESC 'Options(s) followed by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.6 NAME 'sudoRunAsUser' DESC 'User(s) impersonated by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.7 NAME 'sudoRunAsGroup' DESC 'Group(s) impersonated by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcObjectClasses: ( 1.3.6.1.4.1.15953.9.2.1 NAME 'sudoRole' SUP top STRUCTURAL DESC 'Sudoer Entries' MUST ( cn ) MAY ( sudoUser $ sudoHost $ sudoCommand $ sudoRunAs $ sudoRunAsUser $ sudoRunAsGroup $ sudoOption $ description ) )
EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f temp.ldif
```







### Trocar o RootDN

```bash
cd /etc/ldap/slapd.d/cn\=config/
sed -i "s/olcSuffix:.*/olcSuffix: dc=personalsoft,dc=com,dc=br/" olcDatabase\=\{1\}mdb.ldif
sed -i "s/olcRootDN:.*/olcRootDN: cn=admin,dc=personalsoft,dc=com,dc=br/" olcDatabase\=\{1\}mdb.ldif
```

```bash
cd /var/tmp
cat << EOF > tmp.ldif
dn: dc=personalsoft,dc=com,dc=br
objectClass: dcObject
objectClass: organization
dc: personalsoft
o: personalsoft
EOF
ldapadd -f tmp.ldif -D cn=admin,dc=personalsoft,dc=com,dc=br -w secret
```

## Disable SSLv3
#cd /var/tmp
#cat > tmp.ldif << EOF
#dn: cn=config
#add: olcTLSCipherSuite
#olcTLSCipherSuite: SECURE256:-VERS-SSL3.0
#EOF
#ldapmodify -Y EXTERNAL -H ldapi:/// -f tmp.ldif
## check: gnutls-cli-debug -p 636 localhost | head

## Guest account
#cd /var/tmp
#cat > tmp.ldif << EOF 
#dn: cn=guest,dc=root
#objectClass: simpleSecurityObject
#objectclass: organizationalRole
#description: LDAP Read-only Access
#userPassword:
#EOF
#ldapadd -x -D cn=admin,dc=root -W -f ./guest.ldif
#ldappasswd -x -D cn=admin,dc=root -W -S cn=guest,dc=root

#
#
# ACESSO ANONIMO
########################################


#
#
# Organization
########################################

# New organization (dc=personalsoft.com.br,dc=root)
cd /var/tmp
cat > tmp.ldif << EOF 
dn: dc=personalsoft.com.br,dc=root
o: personalsoft.com.br
dc: personalsoft.com.br
objectClass: dcObject
objectClass: organization
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

#
#
# Organizational units
########################################

#
cd /var/tmp
cat > tmp.ldif << EOF 
dn: ou=users,dc=personalsoft.com.br,dc=root
objectClass: organizationalUnit
ou: users
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

#
cd /var/tmp
cat > tmp.ldif << EOF 
dn: ou=groups,dc=personalsoft.com.br,dc=root
objectClass: organizationalUnit
ou: groups
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

#cat > tmp.ldif << EOF
#dn: cn=sysadmins,ou=Groups,dc=personalsoft.com.br,dc=root
#gidNumber: 1000
#objectClass: posixGroup
#cn: sysadmins
#EOF
#ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

#
#
# LINUX
########################################

# Cria um grupo linux
cd /var/tmp
cat > tmp.ldif << EOF 
dn: cn=users,ou=groups,dc=personalsoft.com.br,dc=root
cn: users
objectClass: top
objectClass: posixGroup
gidNumber: 100
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

cd /var/tmp
cat > tmp.ldif << EOF 
dn: cn=sudo,ou=groups,dc=personalsoft.com.br,dc=root
cn: sudo
objectClass: top
objectClass: posixGroup
gidNumber: 27
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

cd /var/tmp
cat > tmp.ldif << EOF 
dn: cn=tomcat,ou=groups,dc=personalsoft.com.br,dc=root
cn: tomcat
objectClass: top
objectClass: posixGroup
gidNumber: 10000
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif

# Cria um usuário linux
cd /var/tmp
cat > tmp.ldif << EOF
dn: uid=fabiano.bonin,ou=users,dc=personalsoft.com.br,dc=root
cn: fabiano.bonin
objectClass: top
objectClass: person
objectClass: posixAccount
objectClass: shadowAccount
uid: fabiano.bonin
sn: fabiano.bonin
uidNumber: 20000
gidNumber: 20000
loginShell: /bin/bash
homeDirectory: /home/fabiano.bonin
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif
ldappasswd -x -D cn=admin,dc=root -W -S uid=fabiano.bonin,ou=users,dc=personalsoft.com.br,dc=root


cd /var/tmp
cat > tmp.ldif << EOF
dn: cn=sudo,ou=groups,dc=personalsoft.com.br,dc=root
changetype: modify
add: memberUid
memberUid: fabiano.bonin
EOF
ldapadd -x -D cn=admin,dc=root -W -f tmp.ldif


#
#echo -e "dn: olcDatabase={1}mdb,cn=config
#changetype: modify
#add: olcDbIndex
#olcDbIndex: uid eq" > /var/tmp/temp.ldif
#ldapmodify -Y EXTERNAL -H ldapi:/// -f /var/tmp/temp.ldif

#
#echo -e "dn: olcDatabase={0}config,cn=config
#changetype: modify
#add: olcAccess
#olcAccess: to * by dn=\"cn=admin,dc=personalsoft,dc=com,dc=br\" write" > /var/tmp/temp.ldif
#ldapmodify -c -Y EXTERNAL -H ldapi:/// -f /var/tmp/temp.ldif

# Cria a organizational unit Group
echo -e "dn: ou=Group,dc=personalsoft,dc=com,dc=br
ou: Group
objectClass: organizationalUnit" > /var/tmp/temp.ldif
slapadd -c -v -l /var/tmp/temp.ldif

# Cria a organizational unit People
echo -e "dn: ou=People,dc=personalsoft,dc=com,dc=br
ou: People
objectClass: organizationalUnit" > /var/tmp/temp.ldif
slapadd -c -v -l /var/tmp/temp.ldif

# Cria um grupo linux
echo -e "dn: cn=fabiano.bonin,ou=Group,dc=personalsoft,dc=com,dc=br
cn: fabiano.bonin
objectClass: top
objectClass: posixGroup
gidNumber: 20000" > /var/tmp/temp.ldif
slapadd -c -v -l /var/tmp/temp.ldif

# Cria um usuário linux
echo -e "dn: uid=fabiano.bonin,ou=People,dc=personalsoft,dc=com,dc=br
cn: fabiano.bonin
objectClass: top
objectClass: person
objectClass: posixAccount
objectClass: shadowAccount
uid: fabiano.bonin
sn: fabiano.bonin
uidNumber: 20000
gidNumber: 20000
loginShell: /bin/bash
homeDirectory: /home/fabiano.bonin" > /var/tmp/temp.ldif
slapadd -c -v -l /var/tmp/temp.ldif
# ldapadd -c -x -D cn=admin,dc=personalsoft,dc=com,dc=br -W -f /var/tmp/temp.ldif

# Altera a senha do usuário
ldappasswd -x -D cn=admin,dc=personalsoft,dc=com,dc=br -W -S uid=fabiano.bonin,ou=People,dc=personalsoft,dc=com,dc=br




#
#
# SSH + PUBLIC KEY
########################################

# Schema (classe ldapPublicKey)
cd /var/tmp
cat > tmp.ldif << EOF
dn: cn=openssh-openldap,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: openssh-openldap
olcAttributeTypes: {0}( 1.3.6.1.4.1.24552.500.1.1.1.13 NAME 'sshPublicKey' DESC 'MANDATORY: OpenSSH Public key' EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.40 )
olcObjectClasses: {0}( 1.3.6.1.4.1.24552.500.1.1.2.0 NAME 'ldapPublicKey' DESC 'MANDATORY: OpenSSH LPK objectclass' SUP top AUXILIARY MUST ( sshPublicKey $ uid ) )
EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f tmp.ldif



#
#
# SUDO
########################################

# Schema (classe sudoRole)
cd /var/tmp
cat > tmp.ldif << EOF
dn: cn=sudo,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: sudo
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.1 NAME 'sudoUser' DESC 'User(s) who may  run sudo' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.2 NAME 'sudoHost' DESC 'Host(s) who may run sudo' EQUALITY caseExactIA5Match SUBSTR caseExactIA5SubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.3 NAME 'sudoCommand' DESC 'Command(s) to be executed by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.4 NAME 'sudoRunAs' DESC 'User(s) impersonated by sudo (deprecated)' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.5 NAME 'sudoOption' DESC 'Options(s) followed by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.6 NAME 'sudoRunAsUser' DESC 'User(s) impersonated by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: ( 1.3.6.1.4.1.15953.9.1.7 NAME 'sudoRunAsGroup' DESC 'Group(s) impersonated by sudo' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcObjectClasses: ( 1.3.6.1.4.1.15953.9.2.1 NAME 'sudoRole' SUP top STRUCTURAL DESC 'Sudoer Entries' MUST ( cn ) MAY ( sudoUser $ sudoHost $ sudoCommand $ sudoRunAs $ sudoRunAsUser $ sudoRunAsGroup $ sudoOption $ description ) )
EOF
ldapadd -Y EXTERNAL -H ldapi:/// -f tmp.ldif



apt-get install sudo-ldap

#
echo "dn: ou=SUDOers,dc=personalsoft,dc=com,dc=br
ou: SUDOers
objectClass: top
objectClass: organizationalUnit" > /var/tmp/sudoers.ldif
slapadd -c -v -l /var/tmp/sudoers.ldif

# Usuário SUDO
echo "dn: cn=fabiano.bonin@personalsoft.com.br,ou=SUDOers,dc=personalsoft,dc=com,dc=br
objectClass: top
objectClass: sudoRole
cn: fabiano.bonin@personalsoft.com.br
sudoUser: fabiano.bonin@personalsoft.com.br
sudoHost: ALL
sudoCommand: ALL" > /var/tmp/script.ldif
slapadd -c -v -l /var/tmp/script.ldif

#
echo "sudoers_base ou=SUDOers,dc=personalsoft,dc=com,dc=br" >> /etc/ldap/ldap.conf

#
echo "sudoers:        files ldap" >> /etc/nsswitch.conf

# Instalar kerberos

# Habilitar autenticação com senha no sshd

# adicionar um grupo e adicionar o grupo ao sudoers, para permitir sudo
