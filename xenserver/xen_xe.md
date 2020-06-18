## dom0

### Consultar a memória

```bash
/opt/xensource/libexec/xen-cmdline --get-xen dom0_mem
```

### Expandir a memória

```bash
/opt/xensource/libexec/xen-cmdline --set-xen dom0_mem=1024M,max:1024M
```

## Templates

### Exportar um template

```bash
xe template-export template-uuid=[uuid] filename=[filename.xva]
```

### Importar um template

```bash
xe vm-import sr-uuid=[storage-uuid] filename=[filename.xva]
# remover a tag backup
xe vm-param-remove param-name=tags param-key=backup uuid=<uuid>
```

## VM

### Exibir as VMs disponíveis

```bash
xe vm-list
```

## CD

### Exibir os ISOs disponíveis

```bash
xe cd-list
```

## Diversos

### Habilitar um pool para auto-inicializar máquinas virtuais

```bash
xe pool-list
xe pool-param-set other-config:auto_poweron=true uuid=ad67fe96-65e9-ca8d-9640-88917f736b11
```

### Auto-inicializar uma vapp

```bash
echo '#!/bin/bash' > /etc/rc.d/init.d/ps_startup
echo '/usr/bin/sleep 10s' >> /etc/rc.d/init.d/ps_startup
echo '/opt/xensource/bin/xe appliance-start uuid=<uuid>' >> /etc/rc.d/init.d/ps_startup
chmod +x /etc/rc.d/init.d/ps_startup
ln -sf ../init.d/ps_startup /etc/rc3.d/S99ps_startup
```

### Habilitar uma máquina virtual para auto-inicializar

```bash
xe vm-param-set other-config:auto_poweron=true uuid=<uuid>
```

### Desabilitar uma máquina virtual para auto-inicializar

```bash
xe vm-param-remove param-name=other-config param-key=auto_poweron uuid=<uuid>
```

### Adicionar uma tag

```bash
xe vm-param-add param-name=tags param-key=<tag> uuid=<uuid>
```

### Remover uma tag

```bash
xe vm-param-remove param-name=tags param-key=<tag> uuid=<uuid>
```

### Criar um repositório de ISO’s

```bash
mkdir /mnt/iso
xe sr-create name-label=iso type=iso content-type=iso device-config:legacy_mode=true device-config:location=/mnt/iso
```

### Adicionar um disco como local storage

* Adicionar o disco fisicamente no servidor
* Identificar o disco
* Particionar o disco
	* Criar uma única partição única do tipo LVM (8e00)
* Adicionar o local storage

```bash
gdisk /dev/sdb
# 1 partição total do tipo Linux LVM (8e00)
xe sr-create host-uuid=<host-uuid> name-label=ssd1 shared=false device-config:device=/dev/sdb1 type=lvm content-type=user
```

### Remover um local storage (cuidado!)

```bash
xe sr-list
xe pbd-list sr-uuid=<sr-uuid>
xe pbd-unplug uuid=<pdb-uuid>
xe pbd-destroy uuid=<pdb-uuid>
xe sr-forget uuid=<sr-uuid>
```

### Patcher

<https://github.com/dalgibbard/citrix_xenserver_patcher/blob/master/README.md>

```bash
cd /var/tmp
wget --no-check-certificate -O patcher.py https://raw.github.com/dalgibbard/citrix_xenserver_patcher/master/patcher.py
chmod a+x patcher.py
./patcher.py
```

### Patch manual

```bash
xe patch-list
xe patch-apply uuid=<UUID of the patch> host-uuid=<UUID of the host>
```

### Discos virtuais

#### Adicionar um disco virtual em uma VM

* Criar o vdi (virtual disk) no xen chamado "temp"

```bash
xe vdi-create name-label=temp virtual-size=10GiB sr-uuid=<uuid>
# anotar o id retornado
```

* Obter o id do disco

```bash
xe vdi-list name-label=temp
# Ex: eed4a98a-d61d-9050-c4ba-368cb0473599
```

* Obter o id da VM "Control domain ..."

```bash
xe vm-list
# Ex: 80d41385-f789-4716-afd1-66aaef07ba86
```

* Criar o vdb

```bash
xe vbd-create device=0 vm-uuid=80d41385-f789-4716-afd1-66aaef07ba86 vdi-uuid=eed4a98a-d61d-9050-c4ba-368cb0473599 bootable=false mode=RW type=Disk
# Anotar o id retornado
# Ex: 202a1d1b-0617-0cb6-17ff-57c2dd31e76d
```

* Plugar o vbd

```bash
xe vbd-plug uuid=202a1d1b-0617-0cb6-17ff-57c2dd31e76d
```

* A partir deste momento, o disco virtual estará disponível na VM

```bash
fdisk -l
```

### Remover um disco virtual de uma VM

* Desmontar o volume
* Desplugar o vbd

```bash
xe vbd-unplug uuid=202a1d1b-0617-0cb6-17ff-57c2dd31e76d
```

* Destruir o vbd

```bash
xe vbd-destroy uuid=202a1d1b-0617-0cb6-17ff-57c2dd31e76d
```

* Destruir o vdi (disco virtual)

```bash
xe vdi-destroy uuid=d9a7f82c-d600-4f96-9cc1-bb16f33821d8
```

### Offline coalesce tool (reclaim free space)

> Não funcionou em um caso que testei
> Se não funcionar, converter a VM para template, transferir para outro storage, excluir o template e fazer o processo inverso

```bash
xe host-call-plugin host-uuid=<host-UUID> plugin=coalesce-leaf fn=leaf-coalesce args:vm_uuid=<VM-UUID>
```
