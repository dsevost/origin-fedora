# OpenShift images based on Fedora

## Build from scratch
```
$ export OPENSHIFT_VERSION=v3.9

$ oc new-project origin-images

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

#$ oc new-build \
#    --name pre-node \
#    -D $'FROM origin\nCOPY tmp/etc /etc/\nCOPY tmp/opt /opt/\nCOPY tmp/usr /usr/' \
#    --source-image=origin-node \
#    --source-image-path=/etc/cni/net.d:tmp1 \
#    --source-image-path=/opt/cni:tmp2 \
#    --source-image-path=/usr/lib/systemd/system/origin-node.service.d:tmp3

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=node \
    --name node


```
