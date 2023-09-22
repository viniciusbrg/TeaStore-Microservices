#!/bin/bash
DOCKER_PLATFORMS='linux/amd64,linux/arm64'
registry='ghcr.io/viniciusbrg/teastore-otel/'     # e.g. 'descartesresearch/'

docker run -it --rm --privileged tonistiigi/binfmt --install all
docker buildx create --use --name mybuilder
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-db" ../utilities/tools.descartes.teastore.database/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-kieker-rabbitmq" ../utilities/tools.descartes.teastore.kieker.rabbitmq/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-base" ../utilities/tools.descartes.teastore.dockerbase/ --push
perl -i -pe's|.*FROM descartesresearch/|FROM '"${registry}"'|g' ../services/tools.descartes.teastore.*/Dockerfile
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-registry" ../services/tools.descartes.teastore.registry/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-persistence" ../services/tools.descartes.teastore.persistence/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-image" ../services/tools.descartes.teastore.image/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-webui" ../services/tools.descartes.teastore.webui/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-auth" ../services/tools.descartes.teastore.auth/ --push
docker buildx build --platform ${DOCKER_PLATFORMS} -t "${registry}teastore-recommender" ../services/tools.descartes.teastore.recommender/ --push
perl -i -pe's|.*FROM '"${registry}"'|FROM descartesresearch/|g' ../services/tools.descartes.teastore.*/Dockerfile
docker buildx rm mybuilder
