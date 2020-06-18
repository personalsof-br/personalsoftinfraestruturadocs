apt-get -y install xinetd
cd /var/tmp
rm /var/tmp/firebird-latest -rf
mkdir -p /var/tmp/firebird-latest
wget http://personalsoft.com.br.s3.amazonaws.com/downloads/firebird/FirebirdCS-2.5.7.27050-0.amd64.tar.gz -O firebird.tar.gz
tar xzf firebird.tar.gz -C firebird-latest --strip-components 1
cd firebird-latest
./install.sh -silent
ln -sf /opt/firebird/bin/fbguard /usr/bin/
ln -sf /opt/firebird/bin/fbmgr /usr/bin/
ln -sf /opt/firebird/bin/fbserver /usr/bin/
ln -sf /opt/firebird/bin/gbak /usr/bin/
ln -sf /opt/firebird/bin/gfix /usr/bin/
ln -sf /opt/firebird/bin/gsec /usr/bin/
ln -sf /opt/firebird/bin/gstat /usr/bin/
ln -sf /opt/firebird/bin/isql /usr/bin/
ln -sf /opt/firebird/bin/nbackup /usr/bin/
gsec -user sysdba -password -modify sysdba -pw km100
gsec -user sysdba -password km100 -add psillisp -pw lisppsil
mkdir -p /share/firebird
mkdir -p /share/firebird/backup
chown firebird:firebird /share/firebird -R

https://ib-aid.com/en/articles/45-ways-to-speed-up-firebird-database/
nano /opt/firebird/firebird.conf
DefaultDbCachePages = 128
TempCacheLimit = 16777216
DummyPacketInterval = 30
