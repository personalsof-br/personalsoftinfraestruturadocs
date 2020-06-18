# https://eclipse.org/che/docs/tutorials/maven/index.html

docker run -it eclipse/che-cli start

docker run -it --rm -v /var/run/docker.sock:/var/run/docker.sock -v <path>:/data eclipse/che-cli start
