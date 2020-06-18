## Habilitar login por senha no ssh

```bash
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.coletor
sed 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.coletor > /etc/ssh/sshd_config
/etc/init.d/ssh restart
```

### Ciphers, MACs e KexAlgorithms para os coletores da Luxcar

```bash
cat >> /etc/ssh/sshd_config << EOF

Ciphers 3des-cbc,blowfish-cbc,cast128-cbc,arcfour,arcfour128,arcfour256,aes128-cbc,aes192-cbc,aes256-cbc,rijndael-cbc@lysator.liu.se,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com
MACs hmac-sha1,hmac-sha1-96,hmac-sha2-256,hmac-sha2-512,hmac-md5,hmac-md5-96,hmac-ripemd160,hmac-ripemd160@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha1-etm@openssh.com,hmac-sha1-96-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-md5-etm@openssh.com,hmac-md5-96-etm@openssh.com,hmac-ripemd160-etm@openssh.com,umac-64-etm@openssh.com,umac-128-etm@openssh.com
KexAlgorithms diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group1-sha1,curve25519-sha256@libssh.org
EOF
```

### Caso seja necessário o telnet

```bash
apt-get install inetutils-inetd -y
apt-get install telnetd
/etc/init.d/inetutils-inetd restart
```

## Criar usuário coletor

```bash
useradd -m -U -s /bin/bash coletor
passwd coletor << EOF
coletor123
coletor123
EOF

mkdir -p /home/coletor/.ssh
chmod 700 /home/coletor/.ssh
chown coletor:coletor /home/coletor/.ssh
cd /home/coletor/.ssh/
ssh-keygen -t rsa -f key -N "" -C "coletor" -q
cp key.pub authorized_keys
chmod 600 *
chown coletor:coletor *
```

### Autoexec do coletor do Move

```bash
echo "" >> /home/coletor/.profile
echo "/opt/java/bin/java -Xms64m -Xmx64m -jar coletor.jar -h localhost -d database" >> /home/coletor/.profile
```

### Autoexec do coletor do Personal ERP

```bash
ln -s /opt/java/bin/java /home/coletor/java_coletor

echo "" >> /home/coletor/.profile
echo "./java_coletor -Xms64m -Xmx64m -jar PersonalsoftColetor.jar console -h localhost -d database" >> /home/coletor/.profile
```

### IMPORTANTE - AllowGroups em sshd_config

