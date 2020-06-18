echo "" >> /etc/sysctl.conf
echo "vm.swappiness = 20" >> /etc/sysctl.conf
sysctl -w vm.swappiness=20

touch /var/swap1.img
chmod 600 /var/swap1.img
dd if=/dev/zero of=/var/swap1.img bs=1024k count=500
mkswap /var/swap1.img
swapon /var/swap1.img
echo "/var/swap1.img none swap sw 0 0" >> /etc/fstab

touch /var/swap2.img
chmod 600 /var/swap2.img
dd if=/dev/zero of=/var/swap2.img bs=1024k count=500
mkswap /var/swap2.img
swapon /var/swap2.img
echo "/var/swap2.img none swap sw 0 0" >> /etc/fstab
