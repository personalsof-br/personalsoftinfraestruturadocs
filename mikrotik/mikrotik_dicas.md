## Referências

* [Os maiores equívocos cometidos por usuários ROS](https://mum.mikrotik.com/presentations/BR17/presentation_4716_1510575938.pdf)

## Ferramentas para diagnóstico

### Uso de CPU

```bash
/tool profile
```

## Diversos

### Bloqueio de site/serviço com L7

```bash
/ip firewall layer7-protocol add name=youtube regexp="^.+(youtube).*\$"
/ip firewall mangle add action=mark-connection chain=prerouting protocol=udp dst-port=53 connection-mark=no-mark layer7-protocol=youtube new-connection-mark=youtube_conn passthrough=yes
/ip firewall mangle add action=mark-packet chain=prerouting connection-mark=youtube_conn new-packet-mark=youtube_packet passthrough=no
/ip firewall filter add action=drop chain=forward packet-mark=youtube_packet
/ip firewall filter add action=drop chain=input packet-mark=youtube_packet
```
