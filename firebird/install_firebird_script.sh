apt-get update

useradd -m -s /bin/bash firebird

#apt-get install -y libicu57 < /dev/null
#apt-get install -y libicu63 < /dev/null
apt-get install -y libtommath-dev < /dev/null

#ln -sf /usr/lib/x86_64-linux-gnu/libtommath.so.1.0.0 /usr/lib/x86_64-linux-gnu/libtommath.so.0
ln -sf libtommath.so /usr/lib/x86_64-linux-gnu/libtommath.so.0
ln -sf libncurses.so.6 /usr/lib/x86_64-linux-gnu/libncurses.so.5

cd /var/tmp
rm /var/tmp/firebird-latest -rf
mkdir -p /var/tmp/firebird-latest
wget http://personalsoft.com.br.s3.amazonaws.com/downloads/firebird/Firebird-3.0.5.33220-0.amd64.tar.gz -O firebird.tar.gz
tar xzf firebird.tar.gz -C firebird-latest --strip-components 1
cd firebird-latest
./install.sh -silent
rm /tmp/firebird/ -rf

ln -sf /opt/firebird/bin/fbguard /usr/bin/
ln -sf /opt/firebird/bin/fbsvcmgr /usr/bin/
ln -sf /opt/firebird/bin/fbtracemgr /usr/bin/
ln -sf /opt/firebird/bin/firebird /usr/bin/
ln -sf /opt/firebird/bin/gbak /usr/bin/
ln -sf /opt/firebird/bin/gfix /usr/bin/
ln -sf /opt/firebird/bin/gstat /usr/bin/
ln -sf /opt/firebird/bin/isql /usr/bin/
ln -sf /opt/firebird/bin/nbackup /usr/bin/

killall fbguard

cp /opt/firebird/firebird.conf /opt/firebird/firebird.conf.original
wget http://docs.personalsoft.com.br/docs/infraestrutura/pt/latest/firebird/firebird3.conf -O /opt/firebird/firebird.conf

chown firebird:firebird /opt/firebird/ -R

isql employee << EOF
alter user sysdba password 'km100' using plugin Srp;
alter user sysdba password 'km100' using plugin Legacy_UserManager;
create user psillisp password 'lisppsil' using plugin Srp;
create user psillisp password 'lisppsil' using plugin Legacy_UserManager;
exit;
EOF

#service firebird-superserver start
fbguard -daemon

mkdir -p /share/firebird
mkdir -p /share/firebird/backup
chown firebird:firebird /share/firebird -R

# sudo %ps_firebird
cat /etc/sudoers | grep ps_firebird || echo -e '\n%ps_firebird ALL=(firebird) NOPASSWD: ALL' >> /etc/sudoers
/etc/init.d/sudo restart
