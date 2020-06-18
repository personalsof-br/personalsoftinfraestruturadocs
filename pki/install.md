## PKI

### Referências

* http://pki-tutorial.readthedocs.io/en/latest/simple/

### Criar diretório raiz

```bash
mkdir -p /opt/pki
cd /opt/pki
mkdir etc
```

### Criar root-ca

```bash
cd /opt/pki
mkdir -p ca/root-ca/private ca/root-ca/db crl certs
chmod 700 ca/root-ca/private

cp /dev/null ca/root-ca/db/root-ca.db
cp /dev/null ca/root-ca/db/root-ca.db.attr
echo 01 > ca/root-ca/db/root-ca.crt.srl
echo 01 > ca/root-ca/db/root-ca.crl.srl
```

#### root-ca.conf

[root-ca.conf]

```bash
openssl req -new -config etc/root-ca.conf -out ca/root-ca.csr -keyout ca/root-ca/private/root-ca.key
```

> a2ed9b102d4daefd

```
openssl ca -selfsign -config etc/root-ca.conf -in ca/root-ca.csr -out ca/root-ca.crt -extensions root_ca_ext
```

### Criar signing-ca

```
cd /opt/pki
mkdir -p ca/signing-ca/private ca/signing-ca/db crl certs
chmod 700 ca/signing-ca/private

cp /dev/null ca/signing-ca/db/signing-ca.db
cp /dev/null ca/signing-ca/db/signing-ca.db.attr
echo 01 > ca/signing-ca/db/signing-ca.crt.srl
echo 01 > ca/signing-ca/db/signing-ca.crl.srl
```

#### signing-ca.conf

[signing-ca.conf]

```
openssl req -new -config etc/signing-ca.conf -out ca/signing-ca.csr -keyout ca/signing-ca/private/signing-ca.key
```

> a11aa610c60f2181

```
openssl ca -config etc/root-ca.conf -in ca/signing-ca.csr -out ca/signing-ca.crt -extensions signing_ca_ext
```

### Criar server

```bash
SAN=DNS:diretorio.personalsoft.com.br \
openssl req -new -config etc/server.conf -out certs/diretorio.personalsoft.com.br.csr -keyout certs/diretorio.personalsoft.com.br.key
```


mkdir /var/pki
mkdir /var/pki/ca
cd /var/pki/ca
mkdir certs
mkdir crl
mkdir newcerts
mkdir private
touch index.txt
echo 01 > serial
wget http://personalsoft.com.br.s3.amazonaws.com/infraestrutura/pki/openssl.cnf -O openssl.cnf

# Cria um certificado de autoridade certificadora raiz
# Common Name (eg, your name or your server's hostname) []:Personal Soft AC Raiz
# Email Address []:ac@personalsoft.com.br
# Cria uma chave privada
openssl genrsa -des3 -out private/ca.key 4096
# Cria um certificado auto-assinado válido por 10 anos
openssl req -config openssl.cnf -new -x509 -nodes -sha1 -days 3650 -key private/ca.key -out ca.pem
# Cria uma cópia do certificado convertida para o formato .crt (que será importado nos navegadores)
openssl x509 -in ca.pem -out ca.crt

#
# AUTORIDADE CERTIFICADORA INTERMEDIARIA (OPCIONAL)
#

cd /var/pki/ca
mkdir ca-intermediaria
cd ca-intermediaria
mkdir certs
mkdir crl
mkdir newcerts
mkdir private
touch index.txt
echo 01 > serial
wget http://personalsoft.com.br.s3.amazonaws.com/infraestrutura/pki/openssl.cnf -O openssl.cnf

# Cria um certificado de autoridade certificadora intermediaria
# Common Name (eg, your name or your server's hostname) []:Personal Soft AC Raiz
# Email Address []:ac@personalsoft.com.br
# Cria uma chave privada
openssl genrsa -des3 -out private/ca.key 4096
# Cria uma requisição de assinatura
openssl req -new -sha1 -key private/ca.key -out ca.csr
# Cria um certificado auto-assinado válido por 10 ano
cd ..
openssl ca -config openssl.cnf -extensions v3_ca -days 3650 -in ca-intermediaria/ca.csr -out ca-intermediaria/ca.pem
# Cria uma cópia do certificado convertida para o formato .crt (que será importado nos navegadores)
openssl x509 -in ca-intermediaria/ca.pem -out ca-intermediaria/ca.crt

#
# CERTIFICADO
#

# Acessar a pasta da autoridade certificadora desejada (raiz ou intermediária)
cd /var/pki/ca

# Cria a chave privada (sem passphrase)
openssl genrsa -out certs/wildcard.personalsoft.com.br.key 4096
# Cria uma requisição de assinatura de certificado com validade de 3 anos
# O CN deve ser o nome do site ou um wildcard - www.personalsoft.com.br ou *.personalsoft.com.br
openssl req -config openssl.cnf -new -key certs/wildcard.personalsoft.com.br.key -out certs/wildcard.personalsoft.com.br.csr
# Gera e assina o certificado 
openssl ca -config openssl.cnf -policy policy_anything -out certs/wildcard.personalsoft.com.br.pem -infiles certs/wildcard.personalsoft.com.br.csr
# Cria uma chave sem a passphrase para usar em servidores web
openssl rsa -in certs/wildcard.personalsoft.com.br.key -out certs/wildcard.personalsoft.com.br.unsecure.key

#
# CERTIFICADOS REVOGADOS
#

# Gera a lista de certificados revogados
openssl ca -gencrl -config openssl.cnf -out crl/ca.crl

#
# SEGURANÇA
#
chmod 600 /var/pki/ca -R

#
# PUBLICAÇÃO
#

cd /var/pki/ca
mkdir /var/www/html/ac.personalsoft.com.br
cp ca.crt /var/www/html/ac.personalsoft.com.br/personalsoft.crt
cp crl/ca.crl /var/www/html/ac.personalsoft.com.br/personalsoft.crl
chmod 600 /var/www/html/ac.personalsoft.com.br/* -R
chown apache.apache /var/www/html/ac.personalsoft.com.br/* -R



# Instalação do certificado no httpd
mv /etc/pki/tls/certs/localhost.crt /etc/pki/tls/certs/localhost.original
mv /etc/pki/tls/private/localhost.key /etc/pki/tls/private/localhost.key.original
cp newcert.pem /etc/pki/tls/certs/localhost.crt
cp wwwkeyunsecure.pem /etc/pki/tls/private/localhost.key
chmod 600 /etc/pki/tls/certs/localhost.crt
chmod 600 /etc/pki/tls/private/localhost.key



mkdir /var/www/ssl
cp /var/pki/ca/certs/wildcard.personalsoft.com.br.pem /var/www/ssl
cp /var/pki/ca/certs/wildcard.personalsoft.com.br.unsecure.key /var/www/ssl
chown apache.apache /var/www/ssl -R
chmod 600 /var/www/ssl -R
