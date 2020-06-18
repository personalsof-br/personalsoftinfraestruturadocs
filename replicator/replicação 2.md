+ Banco de configuração da replicação

++ Executar as replicações pendentes

Rodar ciclos de replicação até eliminar todas as replicações pendentes das filas de cada banco de dados

++ Limpar as definições das tabelas

[[code]]
delete from repl$keyfields;
delete from repl$datafields;
delete from repl$relations;

alter sequence repl$relationgen restart with 0;
[[/code]]

+ Banco matriz

++ Excluir triggers de replicação e limpar os logs de replicações

[[code]]
set term !! ;
execute block
as
  declare variable v_trigger_name varchar(100);
begin
  for select
    a.rdb$trigger_name
  from
    rdb$triggers a
  where
    a.rdb$trigger_name starting with 'REPL$'
  into
    :v_trigger_name
  do
    execute statement 'drop trigger ' || :v_trigger_name;
end !!
set term ; !!

delete from repl_log;
delete from manual_log;
[[/code]]

++ Atualizar o banco de dados

++ Atualizar as aplicações se possível

++ Fazer uma cópia do banco de dados para cada réplica

+ Atualizar as tabelas abaixo nas réplicas

* v3$banco_dados

[[code]]
update v3$banco_dados set banco_dados_uuid = (select result from sp_uuid2hex(gen_uuid()));
update v3$banco_dados set prefixo = <prefixo>;

set term !! ;
execute block
as
  declare variable v_seq integer;
  declare variable v_null integer;
begin
  select
    coalesce(max(cast(substring(tag.codigo from char_length(bd.prefixo) + 1 for 50) as integer)), 0)
  from
    v3$itens_tags tag
    cross join v3$banco_dados bd
  where
    tag.codigo starting with bd.prefixo
    and substring(tag.codigo from char_length(bd.prefixo) + 1 for 50) = (select result from sp_digits(tag.codigo))
  into
    :v_seq;

  v_null = gen_id(v3$tag_sequencia, :v_seq - gen_id(v3$tag_sequencia, 0));
end !!
set term ; !!
commit;
[[/code]]

* v2$srv1

[[code]]
update v2$srv1 set ID_LIMITE_INFERIOR = 2000000, ID_LIMITE_SUPERIOR = 3999999, TIPO = 'R';
[[/code]]

* v3$replicacoes

[[code]]
update or insert into v3$replicacoes
  (replicacao_id, servidor, porta, banco_de_dados, usuario, senha, papel, dbno, tipo_de_banco)
values
  (1, 'tecotton.dyndns.org', 3050, 'replication', 'sysdba', '13BYJ9gsijM=', NULL, 1, 'Central');
[[/code]]

++ Preparar o script de atualização da replicação

* Script: script_replicacao_incluir_objetos_atualizador_ps.sql
* Rodar o script de atualização