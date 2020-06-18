#!/bin/bash

DATABASE=trevilub
USER=SYSDBA
PASSWORD=km100
TEMPFILE=$(mktemp)

log() {
  DH="$(date +'%d/%m/%Y %H:%M:%S')"
  echo "$DH $1"
}

function cleanup {
  if [ -n "$ASYNC" ]; then
    log "write sync"
    gfix -write sync $DATABASE -user $USER -password $PASSWORD
  fi

  if [ -n "$SHUTDOWN" ]; then
    log "online"
    gfix -online $DATABASE -user $USER -password $PASSWORD
  fi

  rm -f $TEMPFILE

  log "fim"
  log ""
}
trap cleanup EXIT

log "inicio"

log "shutdown"
gfix -shut single -force 0 $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi
SHUTDOWN=1

log "write async"
gfix -write async $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi
ASYNC=1

log "logs"
cat > $TEMPFILE << 'TERM'
execute procedure sp_replication_triggers_off('v3$logs');
delete from v3$logs where data_hora < cast((extract(year from current_date) - 1) || '-01-01' as date);
execute procedure sp_replication_triggers_on('v3$logs');
commit;
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "processa os movimentos"
cat > $TEMPFILE << 'TERM'
execute procedure s3$itens_mov_totais_processar;
commit;
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "limpa os movimentos"
cat > $TEMPFILE << 'TERM'
execute procedure s3$itens_mov_totais_limpar(current_date - 180);
commit;
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "processa as previsões"
cat > $TEMPFILE << 'TERM'
execute procedure s3$materiais_prev_tot_processar;
commit;
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "limpa as previsões"
cat > $TEMPFILE << 'TERM'
execute procedure s3$materiais_prev_tot_limpar;
commit;
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "sweep"
gfix -sweep $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi

log "statistics"
cat > $TEMPFILE << 'TERM'
set term !! ;
execute block as
declare variable index_name VARCHAR(31);
begin
  for select RDB$INDEX_NAME from RDB$INDICES into :index_name do
  execute statement 'set statistics index ' || :index_name || ';';
end !!
set term ; !!
TERM
isql -b -i $TEMPFILE $DATABASE -user $USER -password $PASSWORD
if [ $? != 0 ]; then
  exit 1
fi
