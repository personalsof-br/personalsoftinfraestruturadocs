## PKI

### Referências

* (https://wiki.mikrotik.com/wiki/Manual:Create_Certificates)

### Certificado raiz

```bash
/certificate add name=template country=BR key-size=4096 days-valid=3650 key-usage=crl-sign,key-cert-sign
/certificate sign template name=root
/certificate set root trusted=yes
```

### Certificado do servidor

> O common-name ou subject-alt-name tem que bater com o nome do host

```bash
/certificate add name=template country=BR common-name=host.domain key-size=4096 days-valid=3650 key-usage=data-encipherment,digital-signature,key-encipherment,data-encipherment,tls-client,tls-server
/certificate sign template ca=root name=host.domain
/certificate set host.domain trusted=yes
```

### Certificado do servidor com wildcard

> O common-name ou subject-alt-name tem que bater com o nome do host

```bash
/certificate add name=template country=BR common-name=pop3.personalsoft.com.br subject-alt-name=DNS:*.personalsoft.com.br key-size=4096 days-valid=3650 key-usage=data-encipherment,digital-signature,key-encipherment,data-encipherment,tls-client,tls-server
/certificate sign template ca=ca name=server
/certificate set server trusted=yes
```

### Certificado do cliente

```bash
/certificate add name=client-template common-name=client days-valid=3650 key-size=4096
/certificate sign client-template ca=ca name=client
/certificate set client trusted=yes
```

### Exportar certificado

```bash
/certificate export-certificate server
```
