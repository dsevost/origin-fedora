# OpenShift images based on Fedora

## Base images and sripts

### OpenShift Origin (v3.9)
https://github.com/openshift/origin/tree/release-3.9/images

### Etcd
https://github.com/projectatomic/atomic-system-containers/tree/master/etcd

## Build from scratch

```
$ export OPENSHIFT_VERSION=v3.9
$ export FEDORA_RELEASE=27

$ oc new-project origin-images

$ oc import-image fedora --from=docker.io/fedora:${FEDORA_RELEASE} --confirm --scheduled

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=source \
    --name source

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=base \
    --name base

$ oc import-image origin-origin --from=docker.io/openshift/origin:${OPENSHIFT_VERSION} --confirm --scheduled

$ oc new-build \
    --name pre-cli \
    -D $'FROM base\nCOPY tmp/oc /usr/bin/' \
    --source-image=origin-origin \
    --source-image-path=/usr/bin/oc:tmp

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=cli \
    --name cli \
    --build-arg=ZFS_REPO_FEDORA_REL=${FEDORA_RELEASE}

$ oc new-build \
    --name pre \
    -D $'FROM base\nCOPY tmp/openshift /usr/bin/\nRUN chmod 755 /usr/bin/openshift' \
    --source-image=origin-origin \
    --source-image-path=/usr/bin/openshift:tmp

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=origin \
    --name origin

$ oc import-image origin-node --from=docker.io/openshift/node:${OPENSHIFT_VERSION} --confirm --scheduled

$ oc create -f node/node-pre-bc.yaml

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=node \
    --name node

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=openvswitch \
    --name openvswitch

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=etcd \
    --name=etcd \
    --to=etcd

```
