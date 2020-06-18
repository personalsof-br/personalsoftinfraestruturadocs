## Referências

* http://www.silviogarbes.com.br/sistemas/linux/asterisk-voip

* http://nerdvittles.com/?p=5060
* http://nerdvittles.com/?p=7826
* http://nerdvittles.com/?p=815

http://www.profissionaisti.com.br/2010/10/introducao-ao-asterisk-o-que-e-como-funciona-e-como-instalar
http://www.profissionaisti.com.br/2010/10/introducao-ao-asterisk-arquivos-de-configuracoes

Muito bom
http://atualidadedapedra.files.wordpress.com/2009/12/asterisk.pdf

Tutorial Asterisk + EC2
https://docs.google.com/document/d/1kSRilA91HKA-NDBNzCtsUNybm2MmZNwVgpkiZzFhwWk/edit

Esse aqui usa templates e parece que funcionou
http://www.howtoforge.com/how-to-install-asterisk-for-your-first-pbx-solution

http://www.voip-info.org/wiki/view/Asterisk+config+extensions.conf

Codec G-729
http://asterisk.hosting.lv

#
# Atualizacao do Kernel
#


yum -y install gcc make bison ncurses-devel rpm-build


cd /root
wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.4.47.tar.xz
tar -xJf linux-3.4.47.tar.xz -C /usr/src/kernels
wget https://www.kernel.org/pub/linux/kernel/projects/rt/3.4/older/patch-3.4.47-rt62.patch.bz2
bunzip2 patch-3.4.47-rt62.patch.bz2
mv patch-3.4.47-rt62.patch /usr/src/kernels/linux-3.4.47
cd /usr/src/kernels/linux-3.4.47
patch -p1 < patch-3.4.47-rt62.patch
make clean


Op��o 1
  cp /boot/config-`uname -r` .config
  make menuconfig
  General setup -> Local version - append to kernel release -> "-voip"
  Processor type and features -> Preemption Model (No Forced Preemption (Server)) -> Fully Preemptible Kernel (RT)
  Processor type and features -> Timer frequency -> �1000 HZ�
  Device Drivers -> Character Devices -> Enhanced Real Time Clock Support (legacy PC RTC driver) -> M


Op��o 2
  Copiar o arquivo .config para a pasta cd /usr/src/kernels/linux-3.4.47


make rpm # vai demorar algumas horas
rpm -ivh --force /root/rpmbuild/RPMS/x86_64/kernel-3.4.47_rt62_voip-1.x86_64.rpm
depmod 3.4.47-rt62-voip
mkinitrd -v /boot/initramfs-3.4.47-rt62-voip.img 3.4.47-rt62-voip
chmod 755 /boot/vmlinuz-3.4.47-rt62-voip


echo "title Amazon Linux 2013.03 VOIP (3.4.47-rt62-voip)" >> /boot/grub/grub.conf
echo "root (hd0)" >> /boot/grub/grub.conf
echo "kernel /boot/vmlinuz-3.4.47-rt62-voip root=LABEL=/ console=hvc0" >> /boot/grub/grub.conf
echo "initrd /boot/initramfs-3.4.47-rt62-voip.img" >> /boot/grub/grub.conf
echo "" >> /boot/grub/grub.conf
sed -i 's/default=0/default=2/g' /boot/grub/grub.conf


#
# Instalacao do Asterisk
#


rm -f /etc/localtime
cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime


echo "" >> /etc/security/limits.conf
echo "root            soft    nofile          4096" >> /etc/security/limits.conf
echo "root            hard    nofile          8196" >> /etc/security/limits.conf
echo "asterisk        soft    nofile          4096" >> /etc/security/limits.conf
echo "asterisk        hard    nofile          8196" >> /etc/security/limits.conf


yum -y install gcc gcc-c++ compat-libtermcap sqlite-devel ncurses-devel openssl-devel libxml2-devel unixODBC-devel libcurl-devel


cd /root
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-11-current.tar.gz
tar -vzxf asterisk-11-current.tar.gz
cd /root/asterisk-11.5.1/contrib/scripts
./install_prereq install


cd /root/asterisk-11.5.1
./configure
# make menuselect
make
make install
make samples
make config
make install-logrotate


echo "" >> /root/.bash_profile
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib" >> /root/.bash_profile
echo "export PATH LD_LIBRARY_PATH" >> /root/.bash_profile


echo "" >> /etc/rc.local
echo "/usr/sbin/safe_asterisk" >> /etc/rc.local


# Instalacao do Codec G.729
# http://blog.manhag.org/2010/05/installing-the-free-g729-codec-for-asterisk
# http://asterisk.hosting.lv/#bin
cd /usr/lib/asterisk/modules
wget http://asterisk.hosting.lv/bin/codec_g729-ast14-gcc4-glibc-x86_64-core2.so
mv codec_g729-ast14-gcc4-glibc-x86_64-core2.so codec_g729.so


# hostname
# vi /etc/hosts
127.0.0.1 localhost � resultadoDoHostname


# cd /etc/asterisk
# mv sip.conf sip.conf.ori
# mv extensions.conf extensions.conf.ori

# cd /etc/asterisk
# mv sip.conf sip.conf.ori
# mv extensions.conf extensions.conf.ori
<!--stackedit_data:
eyJoaXN0b3J5IjpbNTg4MjA5MDg1XX0=
-->