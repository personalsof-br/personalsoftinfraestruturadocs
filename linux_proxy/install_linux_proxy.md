# VPN

## Preparação do servidor

### Habilitar IPV4 IP forward

```bash
echo 1 > /proc/sys/net/ipv4/ip_forward
```

### Habilitar NAT

```bash
iptables -t nat -s 10.199.124.0/24 -A POSTROUTING -o eth0 -j MASQUERADE
```

## PPTP

```bash
apt-get install pptpd -y
systemctl enable pptpd
nano /etc/pptpd.conf
  localip 192.168.1.5
  remoteip 192.168.1.234-238,192.168.1.245
nano /etc/ppp/pptpd-options
```

```bash
nano /etc/ppp/chap-secrets
  usuario * senha *
service pptpd restart
```

## IPSEC

## L2TP

## OPENVPN
