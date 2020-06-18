# Concatena toda a cadeia de certificação (certificado raiz e certificados intermediários)
cat ca.pem ca1.pem > ca-all.pem

# Exporta o certificado, a chave primária e toda a cadeia de certificação para um arquivo no formato PKCS12 (*.PFX)
# A senha do arquivo PFX deve ser igual à senha que será atribuída ao keystore
# http://joewlarson.com/blog/2009/03/25/java-ssl-use-the-same-password-for-keystore-and-key
openssl pkcs12 -export -in host.pem -inkey host.key -certfile ca-all.pem -name 1 -out host.pfx

# Cria um keystore a partir de um arquivo no formato PKCS12
keytool -importkeystore -srckeystore host.pfx -srcstoretype pkcs12 -srcalias 1 -destkeystore keystore.jks -deststoretype JKS -destalias tomcat

# Copiar o arquivo ~/keystore.ImportKey para /opt/apache-tomcat/ssl/.keystore
cp keystore.jks /opt/apache-tomcat/ssl/.keystore
chmod 600 /opt/apache-tomcat/ssl -R
