#!/bin/bash
DOCKER_PLATFORMS='linux/amd64,linux/arm64'
registry=''     # e.g. 'descartesresearch/'

docker run -it --rm --privileged tonistiigi/binfmt --install all
docker buildx create --use --name mybuilder
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-db" ../utilities/tools.descartes.teastore.database/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-base" ../utilities/tools.descartes.teastore.dockerbase/ --push
perl -i -pe's|.*FROM descartesresearch/|FROM '"${registry}"'|g' ../services/tools.descartes.teastore.*/Dockerfile
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-webui" ../services/tools.descartes.teastore.webui/ --push
perl -i -pe's|.*FROM '"${registry}"'|FROM descartesresearch/|g' ../services/tools.descartes.teastore.*/Dockerfile
docker buildx rm mybuilder