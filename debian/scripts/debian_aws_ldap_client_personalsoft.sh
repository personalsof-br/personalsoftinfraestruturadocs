# https://kifarunix.com/configure-openldap-client-on-debian-9-stretch/

# Instalar e configurar pacote libnss-ldap
echo -e " \
libnss-ldap libnss-ldap/binddn string cn=search,dc=personalsoft,dc=com,dc=br
libnss-ldap libnss-ldap/bindpw password -
libnss-ldap libnss-ldap/confperm boolean true
libnss-ldap libnss-ldap/dblogin boolean false
libnss-ldap libnss-ldap/dbrootlogin boolean false
libnss-ldap libnss-ldap/nsswitch string
libnss-ldap libnss-ldap/override boolean true
libnss-ldap libnss-ldap/rootbinddn string cn=admin,dc=personalsoft,dc=com,dc=br
libnss-ldap libnss-ldap/rootbindpw password -
libnss-ldap shared/ldapns/base-dn string dc=personalsoft,dc=com,dc=br
libnss-ldap shared/ldapns/ldap-server string ldaps://diretorio.personalsoft.com.br/
libnss-ldap shared/ldapns/ldap_version select 3
" | debconf-set-selections

export DEBIAN_FRONTEND=noninteractive
apt-get -y install libnss-ldap < /dev/null

# Habilitar autenticação ldap
sed -i 's/^passwd:.*$/passwd: files ldap/g' /etc/nsswitch.conf
sed -i 's/^group:.*$/group: files ldap/g' /etc/nsswitch.conf

#sed -i 's/compat$/compat ldap/g' /etc/nsswitch.conf
#sed -i 's/files$/files ldap/g' /etc/nsswitch.conf

# sshd_config
sed -i 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

cat >> /etc/ssh/sshd_config << EOF

AllowGroups admin root ps_linux
EOF
/etc/init.d/ssh restart

# ps_sudo
cat >> /etc/sudoers << EOF
%ps_sudo ALL=(ALL:ALL) NOPASSWD: ALL
EOF

# Invalidar cache
nscd --invalidate=passwd
nscd --invalidate=group

#
/etc/init.d/nscd restart
/etc/init.d/ssh restart

# Configurar pasta /home/guest
#apt-get -y install acl < /dev/null
#mkdir -p /home/guest
#chown root:ps_linux /home/guest/
#chmod u=rwx,g=rwxs,o=rx /home/guest/
#setfacl -Rdm group::rwx /home/guest/

# Solução de problemas
# getent group
# getent passwd 
