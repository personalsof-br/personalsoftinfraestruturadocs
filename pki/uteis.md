# Adicionar uma pass-phrase a uma chave privada
openssl rsa -in unsecure.key -out secure.key -des3

#
# REGISTRAR UM CERTIFICADO
#

# Acessa a pasta da autoridade certificadora desejada (raiz ou intermediária)
cd /var/pki/ca
# Define o nome do arquivo da chave (sem extensão)
export KEY_CN=wildcard.domain.com
# Cria a chave privada (sem passphrase)
openssl genrsa -out certs/${KEY_CN}.key 4096
# Cria uma requisição de assinatura de certificado
# O CN deve ser o nome do site ou um wildcard (www.personalsoft.com.br, *.personalsoft.com.br)
openssl req -config openssl.cnf -new -key certs/${KEY_CN}.key -out certs/${KEY_CN}.csr
# Gera e assina o certificado 
openssl ca -config openssl.cnf -policy policy_anything -out certs/${KEY_CN}.pem -infiles certs/${KEY_CN}.csr
# Cria uma chave sem a passphrase para usar em servidores web
openssl rsa -in certs/${KEY_CN}.key -out certs/${KEY_CN}.unsecure.key
