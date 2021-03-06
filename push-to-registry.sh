#!/bin/bash

VER=${IMAGE_VERSION:-v3.10.0}

BUILD_PREFIX=${BUILD_PREFIX:-"fc-28-"}
PUSH_PREFIX=${PUSH_PREFIX:-$BUILD_PREFIX}

REGISTRY_PREFIX_LOCAL=${REGISTRY_PREFIX_LOCAL:-"docker-registry.default.svc:5000/origin-images-builder"}
REGISTRY_PREFIX_REMOTE=${REGISTRY_PREFIX_REMOTE:-"quay.io/dsevosty"}

IMAGES="\
etcd \
origin-cli \
origin-control-plane \
origin-hyperkube \
origin-hypershift \
origin-node \
origin-pod \
origin-deployer \
origin-docker-builder \
origin-sti-builder \
origin-docker-registry \
origin-nginx-router \
origin-haproxy-router \
origin-recycler \
"
for i in $IMAGES ; do
    echo "Uploading image: $i:$VER"
    skopeo copy \
	docker://$REGISTRY_PREFIX_LOCAL/${BUILD_PREFIX}$i:$VER \
	docker://$REGISTRY_PREFIX_REMOTE/${PUSH_PREFIX}$i:$VER
done
