### Referências

* <https://docs.oracle.com/javacomponents/jmc-5-5/jfr-runtime-guide/comline.htm#JFRRT183>
* <https://medium.com/@malith.jayasinghe/enabling-object-statistics-in-jfr-impact-of-applications-memory-82ba9a7a78d3>
* <http://isuru-perera.blogspot.com/2016/03/specifying-custom-event-settings-file.html>

## Coletar os dados

### Criar um profile (settings)

```bash
jmc
```

* Clique em "Window/Flight Record Template Manager"
* Selecione o template "Profiling"
* Clique em "Duplicate"
* Selecione o novo template "Profiling (1)"
* Clique em "Edit"
* Marque as opções
	* Heap Statistics
	* Class Loading
	* Allocation Profiling
* Clique em "OK"
* Clique em "Export File"

### Ativar as características comerciais

```bash
jcmd <pid> VM.unlock_commercial_features
```

### Coletar os dados por 1 minuto

```bash
jcmd <pid> JFR.start duration=1m filename=/var/tmp/file.jfr settings=/var/tmp/profile.jfc
```

### Verificar se existem gravações em execução

```bash
jcmd <pid> JFR.check
```

### Salvar uma gravação

```bash
jcmd <pid> JFR.dump recording=<n> filename=/var/tmp/file.jfr
```

### Finalizar uma gravação

```bash
jcmd <pid> JFR.stop recording=<n>
```

## Analisar os dados

### Abrir o console

jmc
jmap

### obter os pids

jps

### criar um dump da memória

jmap -dump:format=b,file=/var/tmp/dump.hprof <pid>

### Analisar com o Eclipse MAT

http://www.eclipse.org/mat

### Analisar localmente (método ainda não validado)

jhat -J-Xmx512m /var/tmp/dump.hprof
jhat -port 7401 /var/tmp/dump.hprof
