# http://www.codeproject.com/Tips/546903/Amazon-AWS-EC2-FTP-server-using-S3-as-the-backend
# http://ubuntuforums.org/showthread.php?t=1570700

#
# Ativando usuário "ftp"
#
chown ftp:ftp /var/ftp -R
passwd ftp << EOF
ftp!@#$%
ftp!@#$%
EOF

#
# Instalando credenciais do serviço Amazon S3
#
touch /root/.passwd-s3fs
chmod 600 /root/.passwd-s3fs
echo "www.pro-meta.net.br:AKIAIB2XXWSOAZYL7CQA:gP6Es2wvlPydH+mAYui5BqVVElDxzGhQVF7ZBpa5" >> /root/.passwd-s3fs

#
# Instalando s3fs
#
yum -y install gcc
yum -y install libstdc++-devel
yum -y install gcc-c++
yum -y install fuse
yum -y install fuse-devel
yum -y install curl-devel
yum -y install libxml2-devel
yum -y install openssl-devel
#yum -y install mailcap # já instalado

cd /var/tmp
wget https://s3fs.googlecode.com/files/s3fs-1.68.tar.gz
tar xzf s3fs-1.68.tar.gz
cd s3fs-1.68
./configure --prefix=/usr
make
make install

#
# Montando o volume
#
mkdir -p /var/ftp/www.pro-meta.net.br
chown ftp:ftp /var/ftp/www.pro-meta.net.br
chmod a=rwx /var/ftp/www.pro-meta.net.br

s3fs -o allow_other -o default_acl="public-read" -o use_rrs=1 -o uid=14 -o gid=50 www.pro-meta.net.br /var/ftp/www.pro-meta.net.br

#
# Instalando o servidor VSFTPD
# - necessário liberar as portas 21 e 14000-14050
# - corrigir o ip na propriedade "pasv_address" caso seja alterado
# http://www.synergycode.com/knowledgebase/blog/item/ftp-server-on-amazon-ec2
#
yum -y install vsftpd

cd /etc/vsftpd
cp vsftpd.conf vsftpd.conf.original
echo -e "listen=YES

anonymous_enable=NO

local_enable=YES
write_enable=YES

local_umask=022

dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
chroot_local_user=YES
pam_service_name=vsftpd

pasv_enable=YES
pasv_min_port=14000
pasv_max_port=14050
pasv_address=54.232.48.69
pasv_addr_resolve=NO" > vsftpd.conf

chkconfig vsftpd on
service vsftpd start 
