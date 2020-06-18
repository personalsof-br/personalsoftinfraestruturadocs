### Referências

* [45 ways to speed up Firebird](https://ib-aid.com/en/articles/45-ways-to-speed-up-firebird-database/)
* [Otimização do Firebird](https://ib-aid.com/en/optimized-firebird-configuration/)
* [Autenticação atual e legada](https://github.com/FirebirdSQL/jaybird/wiki/Jaybird-and-Firebird-3)

### Instalar

```bash
cd /var/tmp
wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/firebird/install_firebird_script.sh -O install_firebird_script.sh
chmod +x install_firebird_script.sh
./install_firebird_script.sh
```

### Manutenção

http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/firebird/firebird_manutencao_personal_erp.sh

### firebird.conf

```
DefaultDBCachePages = 50000 # memória em M / 2 * 256
TempBlockSize = 2M
TempCacheLimit = 256M # memória em M / 4
LockHashSlots = 30011 # acho que não precisa disso
LockMemSize = 8M
```

### Administração

```bash
sudo -i -u firebird
```

### Reiniciar

```bash
killall fbguard
fbguard -daemon
```