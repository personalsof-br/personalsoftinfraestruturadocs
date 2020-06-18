## Referências

* <http://docs.readthedocs.io/en/latest/install.html>
* <https://www.mkdocs.org/user-guide/writing-your-docs/>
* <http://ericholscher.com/blog/2016/mar/15/dont-use-markdown-for-technical-docs/>

## Instalação

### Atualizar debian

```bash
apt-get update
```

### Instalar [java](../java/install_java/)

### Instalar elasticsearch

```bash
cd /var/tmp
wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.3.8.deb
apt install ./elasticsearch-1.3.8.deb
/usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/2.3.0
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
```

### Instalar git

```bash
apt-get install git -y
```

### Instalar virtualenv

```bash
apt-get install python-virtualenv -y
```

### Instalar dependências

```bash
apt-get install build-essential -y
apt-get install python-dev python-pip python-setuptools -y
apt-get install libxml2-dev libxslt1-dev zlib1g-dev -y
apt-get install texlive texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended -y
apt-get install redis-server -y
```

### Instalar readthedocs

```bash
cd /opt
virtualenv rtd
cd rtd
source bin/activate
mkdir checkouts
cd checkouts
git clone https://github.com/rtfd/readthedocs.org.git
cd readthedocs.org
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
	admin
	admin@personalsoft.com.br
	admin
	admin
python manage.py collectstatic
	yes

cat > readthedocs/settings/local_settings.py << EOF
import os

PRODUCTION_DOMAIN = 'docs.personalsoft.com.br'

PUBLIC_API_URL = 'http://docs.personalsoft.com.br'

SLUMBER_API_HOST = 'http://127.0.0.1'
SLUMBER_USERNAME = 'admin'
SLUMBER_PASSWORD = 'admin'

ALLOW_PRIVATE_REPOS = True
EOF

nohup python manage.py runserver 0.0.0.0:80 &
```

### Reiniciar readthedocs

```bash
killall -KILL python
cd /opt/rtd
source bin/activate
cd checkouts/readthedocs.org
nohup python manage.py runserver 0.0.0.0:80 &
```
