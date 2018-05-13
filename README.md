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
    -D $'FROM cli\nCOPY tmp/openshift /usr/bin/' \
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

$ oc import-image origin-pod --from=docker.io/openshift/origin-pod:${OPENSHIFT_VERSION} --confirm --scheduled

$ oc new-build \
    --name pod \
    -D $'\
	FROM source\nCOPY tmp/pod /usr/bin/\n\
	LABEL \
	    io.k8s.display-name="OpenShift Origin Pod Infrastructure" \
	    io.k8s.description="This is a component of OpenShift Origin and holds on to the shared Linux namespaces within a Pod." \
	    io.openshift.tags="openshift,pod"\n\
	USER 1001\n\
	ENTRYPOINT ["/usr/bin/pod"]\n\
	' \
    --source-image=origin-pod \
    --source-image-path=/usr/bin/pod:tmp

```
