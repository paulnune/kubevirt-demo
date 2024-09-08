#! /usr/bin/bash

# Nome do contêiner a ser criado
CONTAINER_NAME=local-repo

# Diretório local onde as imagens estão armazenadas
NGINX_IMAGE_DIR=`pwd`/images

# Diretório local onde os arquivos de configuração do Nginx estão armazenados
NGINX_CONF_DIR=`pwd`/nginx-conf.d

# Verifica se o contêiner com o nome especificado está em execução
if [ ! "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    # Se o contêiner não estiver rodando, ele será iniciado
    docker run -d --rm --name $CONTAINER_NAME -p 8080:80 \
    -v $NGINX_IMAGE_DIR:/srv/images \  # Monta o diretório local de imagens no contêiner
    -v $NGINX_CONF_DIR:/etc/nginx/conf.d/ \  # Monta o diretório local de configuração do Nginx
    --network kind nginx  # Coloca o contêiner na rede 'kind' e executa a imagem do Nginx
fi
