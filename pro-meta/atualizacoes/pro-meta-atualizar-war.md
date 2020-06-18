# Aborta o script em caso de erro
function error_trap() {
  echo "$0: line $1: exit status $2"
  exit $2
}
trap 'error_trap ${LINENO} $?' ERR

/opt/apache-tomcat/bin/shutdown.sh
rm -rf /opt/apache-tomcat/webapps/ROOT*
wget http://personalsoft.com.br.s3.amazonaws.com/war/PersonalsoftMetas-1.1.1.war -O /opt/apache-tomcat/webapps/ROOT.war
/opt/apache-tomcat/bin/startup.sh
