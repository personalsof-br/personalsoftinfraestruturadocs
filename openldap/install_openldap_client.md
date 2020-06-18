# novo procedimento de instalação no arquivo debian_aws_ldap_client_personalsoft.sh

### Referências

* <http://oudam.info/?p=511>

### Instalar autenticação LDAP

> No diretório, o usuário precisa estender o objeto posixAccount

```bash
apt-get install libnss-ldapd -y
# utilizar as opções padrões
# services: passwd, group, shadow

cat > /etc/nslcd.conf << EOF
uid nslcd
gid nslcd
uri ldaps://diretorio.personalsoft.com.br/
base dc=personalsoft,dc=com,dc=br
ldap_version 3
binddn cn=search,dc=personalsoft,dc=com,dc=br
bindpw search
#rootpwmoddn cn=admin,dc=example,dc=com
#ssl off
tls_reqcert try
tls_cacertfile /etc/ssl/certs/ca-certificates.crt
#scope sub
EOF
/etc/init.d/nslcd restart
```

### Habilitar autenticação por senha

```bash
sed -i 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart
```

### Configurar sudoers

Para um usuário obter permissão de sudo, basta associar este usuário a um determinado grupo do diretório (posixGroup) e conceder permissão de sudo ao grupo.

```bash
echo -e '\n%ps_sudo ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
```

> Esta permissão é muito ampla. Tentar definir grupos para determinados serviços (ex: tomcat) e liberar permissões de sudo para um determinado grupo

### Permissão de login por grupos

```bash
cat >> /etc/ssh/sshd_config << EOF

AllowGroups admin root ps_linux
EOF
/etc/init.d/ssh restart
```

### Pasta home

```bash
mkdir -p /home/guest
chown root:ps_linux /home/guest/
chmod u=rwx,g=rwxs,o=rx /home/guest/

apt-get install acl
setfacl -Rdm group::rwx /home/guest/
```

### Consultar usuários e grupos

```bash
getent passwd
getent passwd <user>
getent group
getent group <group>
```

### Debugar instalação

```bash
/etc/init.d/nscd stop
/etc/init.d/nslcd stop
nslcd -d
```

### Limpar cache

O programa `nscd` mantém um cache local de usuários e grupos. Este programa pode ser desabilitado para desativar o cache, ou o cache pode ser excluído quando necessário.

```bash
nscd --invalidate=passwd
nscd --invalidate=group
```
