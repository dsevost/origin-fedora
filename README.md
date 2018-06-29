# OpenShift images based on Fedora

## Base images and sripts

### OpenShift Origin (v3.9)
https://github.com/openshift/origin/tree/release-3.9/images

### Etcd
https://github.com/projectatomic/atomic-system-containers/tree/master/etcd

## Build from scratch

```
$ export OPENSHIFT_VERSION=v3.10
$ export FEDORA_RELEASE=28

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

$ oc import-image source-origin --from=docker.io/openshift/origin:${OPENSHIFT_VERSION} --confirm --scheduled

$ oc new-build \
    --name pre-cli \
    -D $'FROM base\nCOPY tmp/oc /usr/bin/' \
    --source-image=source-origin \
    --source-image-path=/usr/bin/oc:tmp

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=cli \
    --name cli \
    --build-arg=ZFS_REPO_FEDORA_REL=${FEDORA_RELEASE}

$ oc new-build \
    --name pre \
    -D $'FROM cli\nCOPY tmp/openshift /usr/bin/' \
    --source-image=source-origin \
    --source-image-path=/usr/bin/openshift:tmp

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=origin \
    --name origin

$ oc import-image source-node --from=docker.io/openshift/node:${OPENSHIFT_VERSION} --confirm --scheduled

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
	FROM source\nCOPY tmp/pod /usr/bin/
	LABEL \
	    io.k8s.display-name="OpenShift Origin Pod Infrastructure" \
	    io.k8s.description="This is a component of OpenShift Origin and holds on to the shared Linux namespaces within a Pod." \
	    io.openshift.tags="openshift,pod"
	USER 1001
	ENTRYPOINT ["/usr/bin/pod"]
	' \
    --source-image=origin-pod \
    --source-image-path=/usr/bin/pod:tmp

$ oc new-build \
    --name origin-pod \
    -D $'\
	FROM source
	COPY tmp/pod /usr/bin/
	LABEL \\
	    io.k8s.display-name="OpenShift Origin Pod Infrastructure" \\
	    io.k8s.description="This is a component of OpenShift Origin and holds on to the shared Linux namespaces within a Pod." \\
	    io.openshift.tags="openshift,pod"
	USER 1001
	ENTRYPOINT ["/usr/bin/pod"]
	' \
    --source-image=pod-origin \
    --source-image-path=/usr/bin/pod:tmp

$ oc new-build \
    --name origin-deployer \
    -D $'\
	FROM origin
	LABEL io.k8s.display-name="OpenShift Origin Deployer" \
	    io.k8s.description="This is a component of OpenShift Origin and executes the user deployment process to roll out new containers. It may be used as a base image for building your own custom deployer image." \
	    io.openshift.tags="openshift,deployer"
	USER 1001
	ENTRYPOINT ["/usr/bin/openshift-deployer"]
	'

$ oc new-build \
    --name origin-docker-builder \
    -D $'\
	FROM origin
	LABEL io.k8s.display-name="OpenShift Origin Docker Builder" \
	    io.k8s.description="This is a component of OpenShift Origin and is responsible for executing Docker image builds." \
	    io.openshift.tags="openshift,builder"
	USER 1001
	ENTRYPOINT ["/usr/bin/openshift-docker-builder"]
	'

$ oc new-build \
    --name origin-sti-builder \
    -D $'\
	FROM origin
	LABEL io.k8s.display-name="OpenShift Origin S2I Builder" \
	    io.k8s.description="This is a component of OpenShift Origin and is responsible for executing source-to-image (s2i) image builds." \
	    io.openshift.tags="openshift,sti,s2i,builder"
	USER 1001
	ENTRYPOINT ["/usr/bin/openshift-s2i-builder"]
	'

```
