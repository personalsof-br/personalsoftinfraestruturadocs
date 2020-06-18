### Criar um certificado auto-assinado

```bash
openssl genrsa -out private.key 2048 # chave privada
openssl req -new -key private.key -out request.csr # csr
openssl x509 -req -days 365 -in request.csr -signkey private.key -out certificate.crt # certificado
cat certificate.crt private.key > certificate.pem # bundle
```
