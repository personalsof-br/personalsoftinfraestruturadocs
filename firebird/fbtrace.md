O Firebird 2.5 e versões posteriores possuem uma API de monitoramento (Trace API), que pode ser acessada pelo programa **fbtracemgr**.

Esta ferramenta permite registrar e analisar tempos e outros detalhes de eventos como execução de instruções SQL e outros.

## fbtrace.conf

Para utilizar o programa **fbtracemgr** é necessário, em primeiro lugar, criar um arquivo de configuração.

Neste arquivo serão informados os eventos que deverão ser monitorados.

Na pasta de instalação do Firebird existe um arquivo modelo chamado **fbtrace.conf** com todos os parâmetros de configuração documentados.

### Exemplo de configuração (arquivo fbtrace.conf)

Com esta configuração, serão registradas as execuções de instruções SQL (statement) e stored procedures que demorem mais do que 10s para serem executadas.

```
database
{
	enabled = true

	log_connections = false

	log_transactions = false

	log_statement_prepare = false
	log_statement_free = false
	log_statement_start = false
	log_statement_finish = true

	log_procedure_start = false
	log_procedure_finish = true

	log_function_start = false
	log_function_finish = false

	log_trigger_start = false
	log_trigger_finish = false

	log_context = false

	log_errors = false

	log_warnings = false

	time_threshold = 10000

	max_sql_length = 32768
}
```

## start

### local

```bash
fbtracemgr -se service_mgr -start -name trace -config fbtrace.conf
```

### remoto

```bash
fbtracemgr -se <host>:service_mgr -user sysdba -pass <senha> -start -name trace -config fbtrace.conf
```

## stop

### local

```bash
fbtracemgr -se service_mgr -stop -id <id>
```

### remoto

```bash
fbtracemgr -se <host>:service_mgr -user sysdba -pass <senha> -stop -id <id>
```
