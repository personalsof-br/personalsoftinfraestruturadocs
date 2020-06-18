#! /bin/sh
# /etc/init.d/apache-tomcat
# chkconfig: 345 80 20
# description: Start up the Tomcat servlet engine.

### BEGIN INIT INFO
# Provides: apache-tomcat
# Required-Start: $local_fs $remote_fs $network $syslog
# Required-Stop: $local_fs $remote_fs $network $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Apache Tomcat
# Description: Apache Tomcat
### END INIT INFO

RETVAL=$?
export CATALINA_HOME="/opt/apache-tomcat"
export UMASK="0022" # permissoes dos arquivos de log

case "$1" in
  start)
    if [ -f $CATALINA_HOME/bin/startup.sh ]; then
      echo "Starting Tomcat"
      /usr/bin/sudo -i -u tomcat $CATALINA_HOME/bin/startup.sh
    fi
  ;;
  stop)
    if [ -f $CATALINA_HOME/bin/shutdown.sh ]; then
      echo "Stopping Tomcat"
      /usr/bin/sudo -i -u tomcat $CATALINA_HOME/bin/shutdown.sh
    fi
  ;;
  *)
    echo "Usage: $0 {start|stop}"
    exit 1
  ;;
esac

exit $RETVAL