# Preparando para integração com o git
mkdir -p /opt/repositories/git
chown bitnami:daemon /opt/repositories/git

#
cd /opt/repositories/git
git clone --mirror https://ps_fabiano@bitbucket.org/personalsoft/personalsoftwms.git
