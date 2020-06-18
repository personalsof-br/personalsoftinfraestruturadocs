## Ambiente

Debian Linux

## Instalar git

```bash
apt-get install git -y
```

## Instalar easy-rsa

```bash
apt-get install easy-rsa -y
cp /usr/share/easy-rsa/openssl-1.0.0.cnf /usr/share/easy-rsa/openssl.cnf
```

> Copiei o arquivo openssl.cnf pois aparentemente a versão atual do easy-rsa não é compatível com o openssl-1.1.0 do debian

## Instalar openvpn

```bash
cd /opt
git clone https://github.com/redgeoff/openvpn-server-vagrant
cd openvpn-server-vagrant
cp config-default.sh config.sh
nano config.sh
```

## Configurar

```bash
cd /root
/opt/openvpn-server-vagrant/ubuntu.sh
/opt/openvpn-server-vagrant/openvpn.sh
nano /etc/openvpn/server.conf
  push "route 10.199.0.0 255.255.0.0"
```

## Iniciar

```bash
systemctl restart openvpn@server
```

## Adicionar cliente

```bash
/opt/openvpn-server-vagrant/add-client.sh client@domain
```

> O arquivo de configuração do cliente será gravado em
> ~/client-configs/files/client@domain.ovpn

## Referências

https://hackernoon.com/using-a-vpn-server-to-connect-to-your-aws-vpc-for-just-the-cost-of-an-ec2-nano-instance-3c81269c71c2

## Observações

* Para um cliente mikrotik, a opção tls-auth deve ser desabilitada
* Para um cliente mikrotik, é necessário criar uma cópia de serve.conf para server2.conf, habilitar TCP, iniciar com "systemctl restart openvpn@server2.service"
<!--stackedit_data:
eyJoaXN0b3J5IjpbMzg2NTk2MjEyLDQ4OTg1MTI3OCwtMTY1Mz
Y2NzI2MiwtMjkwNjYzNDM4LDc4NjExNzgxMywtMTk5Mzk1Mjg4
NywxNzkwNzkyMTE1LC0xMjgyODM1NjNdfQ==
-->