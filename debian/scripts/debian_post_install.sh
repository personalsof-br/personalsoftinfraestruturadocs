# < /dev/null para não interromper a execução
apt-get update -y < /dev/null
apt-get upgrade -y < /dev/null

#
echo "alias ls='ls --color'" > /etc/profile.d/personalsoft_aliases.sh
echo "alias ll='ls -lah'" >> /etc/profile.d/personalsoft_aliases.sh
echo "alias cp='cp -i'" >> /etc/profile.d/personalsoft_aliases.sh
echo "alias mv='mv -i'" >> /etc/profile.d/personalsoft_aliases.sh
echo "alias rm='rm -i'" >> /etc/profile.d/personalsoft_aliases.sh
. /etc/profile

#
#echo "export LC_ALL=en_US.UTF-8" > /etc/profile.d/personalsoft_lang.sh
echo "export LANG=en_US.UTF-8" >> /etc/profile.d/personalsoft_lang.sh
#echo "export LANGUAGE=en_US.UTF-8" >> /etc/profile.d/personalsoft_lang.sh
. /etc/profile

#
ln -s -f /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
echo "America/Sao_Paulo" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

#
apt-get install ntp -y < /dev/null

#
apt-get install net-tools -y < /dev/null

#
apt-get install psmisc -y < /dev/null

#
apt-get autoremove -y < /dev/null

#
history -cw
