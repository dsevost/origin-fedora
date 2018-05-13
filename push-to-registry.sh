#!/bin/bash

VER=${IMAGE_VERSION:-v3.9}

REGISTRY_PREFIX_LOCAL=${REGISTRY_PREFIX_LOCAL:-"docker-registry.default.svc:5000/origin-images-builder"}
REGISTRY_PREFIX_REMOTE=${REGISTRY_PREFIX_REMOTE:-"quay.io/dsevosty"}

IMAGES="\
origin-pod
etcd \
cli \
origin \
origin-deployer \
origin-docker-builder \
origin-sti-builder \
origin-docker-registry \
origin-haproxy-router \
origin-nginx-router \
node \
openvswitch \
"

for i in $IMAGES ; do
    skopeo copy \
	docker://$REGISTRY_PREFIX_LOCAL/$i:$VER \
	docker://$REGISTRY_PREFIX_REMOTE/$i:$VER
done
