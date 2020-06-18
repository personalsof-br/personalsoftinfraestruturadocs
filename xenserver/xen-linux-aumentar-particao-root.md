# https://serverfault.com/questions/48879/how-can-i-convert-a-logical-partition-to-a-primary-partition
# sfdisk -d /dev/sda > partitions.txt
# sfdisk --force /dev/sda < partitions.txt

* Desligar a VM
* Aumentar a capacidade do storage
* Iniciar a VM
* fdisk /dev/xvda
  * Excluir a partição antiga
  * Adicionar a partição nova, utilizando todo o espaço disponível
* Reiniciar a VM
* resize2fs /dev/xvda1
