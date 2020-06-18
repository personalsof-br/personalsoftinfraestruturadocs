## Referências

* <https://www.debian.org>
* [dicas apt-get](https://peteris.rocks/blog/quiet-and-unattended-installation-with-apt-get/)

## Instalação

* Baixar em <https://www.debian.org/CD/http-ftp/#stable>
* Instalar com as opções padrões
* Usuários
	* root, sem senha
	* personalsoft, senha personalsoft
* Particionamento manual
	* Apenas 1 partição com 8GB ocupando todo o disco, sem SWAP
* Na tela de seleção de componentes, selecionar apenas
	* SSH Server
	* System utilities

## Configuração

### Desabilita o repositório no cdrom

```bash
cp /etc/apt/sources.list /etc/apt/sources.list.original
sed -i 's/deb cdrom/# deb cdrom/g' /etc/apt/sources.list
```

### Atualiza os repositórios

```bash
apt-get -y update
```

### Atualiza os packages

```bash
apt-get -y upgrade
```

### Desabilita a resolução de nomes do sshd

```bash
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
sed -i 's/#UseDNS/UseDNS/g' /etc/ssh/sshd_config
sed -i 's/UseDNS yes/UseDNS no/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart
```

### Adiciona o usuário personalsoft no grupo sudo

```bash
sed -i 's/\%sudo\s*ALL=(ALL:ALL)\s*ALL/%sudo\tALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers
```

### Instala o Xen Tools

```bash
# xe vm-cd-insert cd-name=guest-tools.iso vm=[uuid]
mount /dev/cdrom /mnt
cd /mnt/Linux
./install.sh
y
shutdown -r now
```

### Post-install

```bash
cd /var/tmp

wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/debian/scripts/debian_post_install.sh
. debian_post_install.sh

wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/debian/scripts/debian_key_fabianobonin.sh
. debian_key_fabianobonin.sh

wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/debian/scripts/debian_swap.sh
. debian_swap.sh
```
