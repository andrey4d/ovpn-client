#!/bin/sh

VERSION="v0.0.1"
IMAGE_NAME="registry.home.local/openvpn-client"

docker build  --platform linux/arm64 --network host -t ${IMAGE_NAME}:${VERSION}-arm64 build
docker build  --platform linux/amd64 --network host -t ${IMAGE_NAME}:${VERSION}-amd64 build

docker push ${IMAGE_NAME}:${VERSION}-arm64 
docker push ${IMAGE_NAME}:${VERSION}-amd64

docker manifest create ${IMAGE_NAME}:${VERSION} --amend ${IMAGE_NAME}:${VERSION}-arm64 --amend ${IMAGE_NAME}:${VERSION}-amd64
docker manifest push ${IMAGE_NAME}:${VERSION}