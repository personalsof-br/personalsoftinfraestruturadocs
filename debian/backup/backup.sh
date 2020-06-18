#!/bin/bash

set -o pipefail
set -o errtrace

CMD="$0"
SCRIPT_DIR="$(dirname $(readlink -e $0))"
SCRIPT="$(basename $(readlink -e $0) .sh)"
CONF="${SCRIPT_DIR}/${SCRIPT}.cfg"
LOG="${SCRIPT_DIR}/${SCRIPT}.log"
LOCK="${SCRIPT_DIR}/.lock"
HOST="$(hostname)"

cleanup() {
  # Remove o lock
  rm -f "${LOCK}"
}

error() {
  local LINE="$1"
  local MESSAGE="$2"
  local CODE="${3:false}"
  log "${CMD}: linha ${LINE}: ${MESSAGE}: status ${CODE}"

  curl -G \
  --data-urlencode "identificador=suporte.servidores" \
  --data-urlencode "remetente=suporte.servidores@personalsoft.com.br" \
  --data-urlencode "destinatario=suporte.servidores@personalsoft.com.br" \
  --data-urlencode "assunto=Erro de backup em ${HOST}" \
  --data-urlencode "mensagem=${CMD}: linha ${LINE}: ${MESSAGE}: status ${CODE}" \
  https://email-services.personalsoft.com.br/email-services/mensageiro/enviar

  exit ${CODE}
}

log() {
  DH="$(date +'%d/%m/%Y %H:%M:%S')"
  echo "$DH $1" >> $LOG
  echo "$DH $1"
}

# Adquire o lock
if [ ! -f "${LOCK}" ]; then touch "${LOCK}"; else error ${LINENO} "Nao foi possivel adquirir o lock"; fi

# Trap para saida
trap '{ cleanup; }' EXIT

# Trap para interrupcoes
trap '{ exit false; }' SIGHUP SIGINT SIGTERM

# Grava uma linha em branco no log
echo >> ${LOG}

log "Iniciando o backup"

log "SCRIPT_DIR=${SCRIPT_DIR}"
log "SCRIPT=${SCRIPT}"
log "CONF=${CONF}"

# Carrega o arquivo de configuracoes
. "$CONF" 2>&1
ERR="${?}"
if [ ${ERR} != 0 ]; then
  error ${LINENO} "Erro ao carregar o arquivo ${CONF}" ${ERR}
fi

log "FIREBIRD_DIR="$FIREBIRD_DIR
log "BACKUP_DIR="$BACKUP_DIR

# Remove os flags de erro e sincronizacao
rm -f $BACKUP_DIR/.ready

# Verifica se o servidor de backup esta lendo a pasta
if [ -f $BACKUP_DIR/.reading ]; then
  error ${LINENO} "A pasta $BACKUP_DIR esta indisponivel" 1
fi

# Verifica as pastas de origem e destino
if [ ! -d "$FIREBIRD_DIR" ]; then
  error ${LINENO} "A pasta de origem $FIREBIRD_DIR nao existe" 1
fi
if [ ! -d "$BACKUP_DIR" ]; then
  error ${LINENO} "A pasta de destino $BACKUP_DIR nao existe" 1
fi

# Armazena os nomes dos bancos de dados
DBS=$(ls -1 $FIREBIRD_DIR/*.fdb)
if [ $? != 0 ]; then
  error ${LINENO} "Nenhum banco de dados encontrado em $FIREBIRD_DIR" 1
fi

# Realiza o backup de cada banco de dados
for DB in $DBS; do
  BD="$(basename $(readlink -f $DB) .fdb)"
  FBK="$BACKUP_DIR/firebird/$BD.fbk"

  log "Removendo o arquivo $FBK"
  rm -f "$FBK"

  log "Efetuando o backup de $DB"
  gbak -b "$DB" "$FBK" -user $FIREBIRD_USER -pass $FIREBIRD_PASSWORD 2>&1
  if [ $? != 0 ]; then
    error ${LINENO} "Ocorreu um erro ao efetuar o backup de $DB"
  fi

  log "Calculando o digest de $FBK"
  sha1sum "$FBK" > "$BACKUP_DIR/firebird/$BD.sha1sum"
done

log "Backup concluido"

# Registra o flag de sincronizacao
touch $BACKUP_DIR/.ready
