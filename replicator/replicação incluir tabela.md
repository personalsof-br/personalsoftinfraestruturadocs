[[toc]]

+ Inclusão de uma nova tabela no banco de dados 

++ Preparação do script de criação da tabela e da integridade referencial

[[code]]
create table teste (
  id integer not null,
  coluna1 varchar(100),
  coluna2 varchar(100));

alter table teste add constraint xpkteste primary key (id);
[[/code]]

++ Preparação do script de registro da tabela em v2$tab1

[[code]]
insert into v2$tab1 (
  tabela,
  chave_primaria,
  sequencia,
  descricao,
  descricao_plural,
  tipo )
values (
  'TESTE',
  'ID',
  'V3$SEQ1',
  'Teste',
  'Testes',
  'C' );
[[/code]]

++ Preparação do script para atualizar v2$tbc1

++ Preparação do script de configuração da replicação

Execute a consulta **S:\delphi\personal_erp\scripts\script_replicacao_incluir_objetos_atualizador_ps.sql**, informando o nome da tabela e 'S' nos demais parâmetros.

[[code]]
--Classe=br.com.personalsoft.atualizador.itens.personal_erp.replicacao.IncluirTabela
--TipoDeBanco=Todos
--Tabela=TESTE;

--Classe=br.com.personalsoft.atualizador.itens.personal_erp.replicacao.IncluirChavePrimaria
--TipoDeBanco=Todos
--Tabela=TESTE
--ChavePrimaria=ID;

--Classe=br.com.personalsoft.atualizador.itens.personal_erp.replicacao.IncluirColuna
--TipoDeBanco=Todos
--Tabela=TESTE
--Coluna=COLUNA1;
--Coluna=COLUNA2;

--Classe=br.com.personalsoft.atualizador.itens.personal_erp.replicacao.CriarTriggers
--TipoDeBanco=Todos
--Tabela=TESTE;
[[/code]]m