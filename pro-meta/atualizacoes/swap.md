fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap -f /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab
