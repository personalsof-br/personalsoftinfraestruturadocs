#
# SERVER
##################################################

apt-get install snmp snmpd -y
cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.original


# Consultas
snmpwalk -v 2c -c public -O e localhost .1.3.6.1.2.1.25.1.1.0  # hrSystemUptime.0
