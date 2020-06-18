#
apt-get update
apt-get install curl -y

#
curl -sSL https://get.docker.com | sh

#
/etc/init.d/docker start



#
docker pull debian:8.7

# Executar interativo com terminal e shell
docker run -i -t debian:8.7 /bin/bash

# Criar imagem
docker commit <container_id>

# Excluir imagem
docker rmi <image_id>

# Exibir containers
docker ps -a

#
docker diff <id>

# Conectar a um container
docker attach <id>

CTRL+P+Q - sai sem terminar o container
docker commit c02f61dadb6b teste:1.0
docker images

http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html

docker run -i -t debian:8.7 /bin/bash
