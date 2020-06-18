/*
Title: Instalação do Raneto
*/

## Referências

* <http://blog.canumeet.com/2017/03/05/How-Raneto-helps-knowledge-base-creation>
* <https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/setting-up-node-on-ec2-instance.html>
* <http://docs.raneto.com/install/installing-raneto>
* <https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions>
* <http://docs.raneto.com/tutorials/running-as-a-service>
* <http://pm2.keymetrics.io>
* <https://stackoverflow.com/questions/19254583/how-do-i-host-multiple-node-js-sites-on-the-same-ip-server-with-different-domain>

## Instalação

### Instalar o nvm

```bash
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
. ~/.nvm/nvm.sh
```

### Instalar o node.js

```bash
nvm install --lts
npm config set unsafe-perm=true
```

### Instalar o raneto

```bash
cd ~
wget https://github.com/gilbitron/Raneto/archive/0.15.0.tar.gz -O raneto.tar.gz
mkdir -p raneto
tar xzf raneto.tar.gz -C raneto --strip-components 1
cd raneto
npm install
nohup PORT=3000 npm start &
```

### 

```bash
git config credential.helper store
git pull origin /home/admin/raneto.wms/example/content

git clone -b master --single-branch https://ps_docs:f91d602a3f13@bitbucket.org/personalsoft/personalsoftequipedocs.git /home/admin/raneto.equipe/example/content
git clone -b master --single-branch https://ps_docs:f91d602a3f13@bitbucket.org/personalsoft/personalsofterpdocs.git /home/admin/raneto.erp/example/content
git clone -b master --single-branch https://ps_docs:f91d602a3f13@bitbucket.org/personalsoft/personalsoftgestordocs.git /home/admin/raneto.gestor/example/content
git clone -b master --single-branch https://ps_docs:f91d602a3f13@bitbucket.org/personalsoft/personalsoftwmsdocs.git /home/admin/raneto.wms/example/content

git --git-dir=/home/admin/raneto.wms/example/content/.git --work-tree=/home/admin/raneto.wms/example/content pull origin

cd ~
wget https://github.com/gilbitron/Raneto/archive/0.15.0.tar.gz -O raneto.tar.gz
mkdir -p raneto
tar xzf raneto.tar.gz -C raneto --strip-components 1
cd raneto
```
