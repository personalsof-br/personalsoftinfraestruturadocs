[[toc]]

+ Instalação do firebird

* Acesse o site [[[*http://www.firebirdsql.org/]]]
* Vá em downloads
* Em server Packages selecione a versão do firebird de acordo com o banco de dados do sistema (normalmente a última versão, mas verifique antes)
* Baixe o executável de acordo com a versão do sistema operacional
* Após baixar execute o arquivo
* Selecione o idioma e clique em **OK**
* Clique em **Next**
* Na tela seguinte selecione **I accept the agreement** e clique em **Next**
* Na tela seguinte clique em **Next**
* Clique em **Next** novamente
* Clique em **Next** novamente
* Na tela "Select Components", selecione a opção **Minimum client install - no server, no tools**
* Clique em **Next**
* Clique em **Next** novamente
* Clique em **Install**
* Após instalar, clique em **Next**
* Clique em **Finish**

+ Instalação e configuração do IBReplicator

++ Instalação do IBReplicator

Faça o download do IBReplicator versão 2.5.1 
* Clique com o botão direito sobre o link [http://personalsoft.com.br.s3.amazonaws.com/downloads/IBReplicationServer-2.5.1-Win32.exe IBReplicador 2.5.1]
* Salve o arquivo em seu computador

Descompacte o arquivo **IBReplicationServer-2.5.1-Win32.zip**

Execute o arquivo **IBReplicationServer-2.5.1-Win32.exe**

* Na tela Setup - This will install IBReplication Server for Firebird and InterBase. Do you wish to continue? Clique em **Sim**.
* Na tela Welcome to the IBReplication Server for Firebird and Interbase Setup Wizard, clique em **Next >**
* Na tela License Agreement, marque a opção I accept the agreement e clique em Next >
* Na tela Information, clique em **Next >**
* Na tela Select Destination Directory, clique em **Next >**
* Na tela Select Components, escolha a opção Full installation of server, management tools and documentation e clique em **Next >**
* Na tela Select Start Menu Folder, clique em **Next >**
* Na tela Select Additional Tasks, desmarque a opção Install replicator service, clique em **Next >**
* Na tela Ready to Install, clique em **Install**
* Na tela Information, clique em **Next >**
* Na tela Completing the IBReplication Server for Firebird and Interbase Setup Wizard, clique em **Finish**

++ Configuração do IBReplicator

Execute o programa Replication Manager localizado em **Iniciar\Todos os programas\IBReplicator\Replication Manager**

* No menu, clique em **File\Open configuration**
* Na tela Select Configuration Database, preencha os campos com as seguintes informações:
 * Server name: 192.168.0.1
 * Protocol: TCP/IP
 * Database file: replication
 * User name: SYSDBA
 * Password: keymaster - utilize (km100)
* Clique em Open
* No menu, clique em **Configuration\Set as default**
* No menu, clique em **File\Exit**

++ Executando a Replicação

Execute o programa Replication Server localizado em **Iniciar\Todos os programas\IBReplication**

No Replication Server, clique na **seta azul** para iniciar ou parar a replicação.

++ Windows 7

Caso a replicação não funcione no windows 7, será preciso editar o arquivo host:
* Acesse **Computador \ C: \ Windows \ System 32 \ drivers \ etc \ hosts**
* Clique em abrir e execute o arquivo no bloco de notas
* Siga para a última linha e dê enter
* Na linha seguinte informe o IP do servidor, espaço e informe o host
 * Ex.: **192.168.0.1 xxxx.dyndns.org**
* Salve o arquivo na área de trabalho
* Renomeie o arquivo para excluir a extensão **.txt**
* Copie e cole o arquivo na pasta **etc** para substituir o arquivo hosts
* Inicie a replicação

++ Observações

Nos bancos de dados replicados existe uma tabela chamada "v3$replicacoes".
Esta tabela possui 1 registro com todas as informações do banco de dados de replicação (host, nome do banco, senha, etc...), essas informações são utilizadas na configuração do IBReplicator.