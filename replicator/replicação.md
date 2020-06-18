## Banco mestre

* Executar um ciclo completo de replicação (se possível)
* Excluir os registros das tabelas REPL_LOG e MANUAL_LOG
* Fazer uma cópia do banco de dados original
* Transferir a cópia do banco de dados original para o servidor replicado

## Banco réplica

* Excluir os triggers de replicação (REPL$)

[[code]]
set term !! ;
execute block
as
  declare variable v_sql varchar(2048);
begin
  for select
    'drop trigger ' || trim(a.rdb$trigger_name) || ';'
  from
    rdb$triggers a
  where
    a.rdb$trigger_name starting with 'REPL$'
  into
    :v_sql
  do
    execute statement :v_sql;
end !!
set term ; !!
[[/code]]

* Definir as propriedades:
 * v3$banco_dados.banco_dados_uuid
 * v3$banco_dados.sequencia_faixa
 * v3$banco_dados.prefixo
 * v3$replicacoes.dbno
 * v3$replicacoes.tipo_de_banco
 * v2$srv1.tipo
 * v2$srv1.id_limite_inferior
 * v2$srv1.id_limite_superior
* Gerar o script APP para incluir as tabelas de replicação
* Executar o script APP pelo Atualizador PS
* Corrigir os generators
 * v3$itens_tags_seq

[[code]]
alter trigger TRG_V3$BANCO_DADOS_B1P0 inactive;
set term !! ;
execute block
as
  declare variable prefixo varchar(10);
  declare variable sequencia_tag integer;
begin
  prefixo = 'RC';

  select
    substring(max(t.codigo) from char_length(:prefixo) + 1 for 100)
  from
    v3$itens_tags t
  where
    t.codigo starting with :prefixo
  into
    :sequencia_tag;

  sequencia_tag = gen_id(v3$itens_tags_seq, :sequencia_tag - gen_id(v3$itens_tags_seq, 0));

  update v3$banco_dados set
    banco_dados_uuid = (select result from sp_uuid2hex((select result from sp_gen_uuid))),
    sequencia_faixa = 2,
    prefixo = :prefixo;
end !!
set term ; !!
commit;
alter trigger TRG_V3$BANCO_DADOS_B1P0 active;
[[/code]]

[[code]]
update v3$replicacoes set dbno = 2, tipo_de_banco = 'Replica';
commit;
[[/code]]

[[code]]
update v2$srv1 set tipo = 'R', id_limite_inferior = 5000000, id_limite_superior = 9999999;
[[/code]]

++++ 

* Script: GESTOR_REPLICACAO_INCLUIR_TABELA.sql
* Criar o script de atualização da replicação
* Excluir as tabelas do schema {{delete from REPL$RELATIONS where replno = 2}}
* Rodar o script de atualização
* 