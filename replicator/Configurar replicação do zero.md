[[toc]]

++ Preparação dos bancos de dados

* Faça uma cópia do banco de dados a replicar para cada réplica necessária
 * Ex: Para replicar um banco de dados da matriz para duas filiais, devem ser criadas duas cópias do banco de dados da matriz
* Defina qual será o banco de dados central
 * Normalmente será o banco de dados da matriz
* Os demais bancos de dados serão as réplicas

++ Criação dos usuários para replicação

* Crie o usuário **REPL** em todos os servidores envolvidos na replicação
 * Utilize a senha temporária **repl** para todos eles
* No servidor do banco de dados central, crie um usuário para cada réplica registrada, cujo nome deverá ser **REPL_<DBNO>**, onde <DBNO> é o número da réplica armazenado anteriormente
 * Utilize a senha temporária **repl** para todos eles

[[code]]
gsec -user sysdba -password masterkey -database 127.0.0.1:security2 -add repl -pw repl
[[/code]]

++ Criação do banco de dados de configuração

* Faça o download do banco de dados de configuração v2.5 pré-carregado com as licenças em:
 * http://personalsoft.com.br.s3.amazonaws.com/downloads/replication.25.fdb
* Clique em **Iniciar/Programas/IBReplicator/Replication Manager**
* Clique me **File/Open configuration**
* Preencha os campos necessários
* Clique em **Open**
* Avance para o tópico **Criação das tabelas de replicação nos bancos de dados**

++ Registro dos bancos de dados

* Clique na guia **Databases**
* **Database/Add**
* Selecione o tipo **Firebird**
* Informe os dados da conexão ao banco de dados
* No campo **Priority**, preencha com
 * **Highest** se o banco de dados for o banco de dados central
 * **8** se o banco de dados for uma réplica
* Preencha o campo **Administrative user name** com **SYSDBA**
* Clique em **Database/Test connection**
* Clique em **Database/Save**
* Repita este procedimento para cada banco de dados envolvido na replicação

++ Anotação dos números de identificação (DBNO) dos bancos de dados

* Conecte-se no banco de dados de configuração
* Execute a instrução SQL:
[[code]]
select dbno, dbname, dbpath from repl$databases;
[[/code]]
* Anote o **DBNO** de cada banco de dados

++ Criação do schema (esquema) de replicação Central->Réplicas

+++ Criação do schema

* Clique na guia **Replications**
* Clique em **Replication/Schema/New**
 * Preencha a propriedade **Schema name** com o nome do esquema
  * Ex: "1->*"
 * Clique na guia **Connection**
 * Selecione o banco de dados central no campo **Registered database**
 * Preencha o campo **Replication username** com **REPL**
 * Preencha o campo **Replication password** com a senha do usuário REPL
 * Preencha o campo **Replication role** com **publico**
 * Clique em **Test connection**
 * Clique em **OK**

+++ Inclusão das réplicas

Para cada réplica registrada, realize a seguinte operação:

* Selecione o esquema recém criado clicando sobre ele
* Clique em **Replication/Target/Add**
 * Selecione a réplica desejada no campo **Registered database**
 * Preencha o campo **Replication username** com **REPL**
 * Preencha o campo **Replication password** com a senha do usuário REPL
 * Preencha o campo **Replication role** com **publico**
 * Clique na guia **Settings**
 * Preencha o campo **Periodic commit after records** com **25**

++ Criação dos schemas (esquemas) de replicação Réplica->Central

Para cada réplica registrada, realize as seguintes operações de criação do schema e de inclusão do banco de dados central:

+++ Criação do schema

* Clique na guia **Replications**
* Clique em **Replication/Schema/New**
 * Preencha a propriedade **Schema name** com o nome do esquema
  * Ex: "2->1"
 * Clique na guia **Connection**
 * Selecione a réplica desejada no campo **Registered database**
 * Preencha o campo **Replication username** com **REPL**
 * Preencha o campo **Replication password** com a senha do usuário REPL
 * Preencha o campo **Replication role** com **publico**
 * Clique em **Test connection**
 * Clique em **OK**

+++ Inclusão do banco de dados central

* Selecione o esquema recém criado clicando sobre ele
* Clique em **Replication/Target/Add**
 * Selecione o banco de dados central no campo **Registered database**
 * Preencha o campo **Replication username** com **REPL_<DBNO>**
  * Substitua **<DBNO>** pelo DBNO da réplica selecionada
  * Ex: REPL_2
 * Preencha o campo **Replication password** com a senha do usuário REPL_<DBNO>
 * Preencha o campo **Replication role** com **publico**
 * Clique na guia **Settings**
 * Preencha o campo **Periodic commit after records** com **25**

++ Criação das tabelas de replicação nos bancos de dados

* Acesse cada banco de dados e crie (apenas) um registro na tabela __v3$replicacoes__, preenchendo todos os campos do registro

[[code]]
insert into v3$replicacoes (replicacao_id, servidor, porta, banco_de_dados, usuario, senha, papel, dbno, tipo_de_banco) values (1, 'servidor.dyndns.org', 3050, 'replication', 'sysdba', 'masterkey', null, 1, 'Central');

insert into v3$replicacoes (replicacao_id, servidor, porta, banco_de_dados, usuario, senha, papel, dbno, tipo_de_banco) values (1, 'servidor.dyndns.org', 3050, 'replication', 'sysdba', 'masterkey', null, 2, 'Replica');
[[/code]]

* Rode o script **script_replicacao_recriar_objetos_v2.5.sql** nos bancos de dados central e replicas

* Altere os intervalos de generators na tabela v2$srv1
 * Pode ocorrer um erro ao rodar pelo isql. Neste caso, rode pelo IBExpert

[[code]]
update or insert into v2$srv1 (numv2$srv1, codigo, descricao, tipo, id_limite_inferior, id_limite_superior) values (1, 'default', null, 'C', 0, 4999999);

update or insert into v2$srv1 (numv2$srv1, codigo, descricao, tipo, id_limite_inferior, id_limite_superior) values (1, 'default', null, 'R', 4999999, 9999999);
[[/code]]

++ Configuração do banco de dados de configuração

* Rode o script **script_replicacao_incluir_objetos_atualizador_ps.sql** no banco de dados central
* Copie o resultado do script e grave em um arquivo do tipo **.app**
* Processe o script com o programa **App2Aps** para gerar o arquivo do tipo **.aps**
* Rode o script **.aps** em todos os bancos de dados envolvidos na replicação utilizando o **AtualizadorPS**

[[code]]
melhorar?
[[/code]]

++ Permissões

[[code]]
central
grant publico to repl;
grant publico to repl_2;
grant publico to repl_3;
replica
grant publico to repl;
[[/code]]