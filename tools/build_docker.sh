#!/bin/bash
#DOCKER_PLATFORMS='linux/amd64,linux/arm64'
registry='ghcr.io/viniciusbrg/teastore-otel/'     # e.g. 'descartesresearch/'


docker  build -t "${registry}teastore-db" ../utilities/tools.descartes.teastore.database/ 
docker  build -t "${registry}teastore-kieker-rabbitmq" ../utilities/tools.descartes.teastore.kieker.rabbitmq/ 
docker  build -t "${registry}teastore-base" ../utilities/tools.descartes.teastore.dockerbase/ 
perl -i -pe's|.*FROM descartesresearch/|FROM '"${registry}"'|g' ../services/tools.descartes.teastore.*/Dockerfile
docker  build -t "${registry}teastore-registry" ../services/tools.descartes.teastore.registry/ 
docker  build -t "${registry}teastore-persistence" ../services/tools.descartes.teastore.persistence/ 
docker  build -t "${registry}teastore-image" ../services/tools.descartes.teastore.image/ 
docker  build -t "${registry}teastore-webui" ../services/tools.descartes.teastore.webui/ 
docker  build -t "${registry}teastore-auth" ../services/tools.descartes.teastore.auth/ 
docker  build -t "${registry}teastore-recommender" ../services/tools.descartes.teastore.recommender/ 
perl -i -pe's|.*FROM '"${registry}"'|FROM descartesresearch/|g' ../services/tools.descartes.teastore.*/Dockerfile
