# OpenShift images based on Fedora

## Build from scratch
```
$ oc new-project origin-mages
$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=source \
    --name origin-source

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=base \
    --name origin-base

$ oc new-build \
    --name origin-pre \
    -D "FROM origin-base\nADD tmp/openshift /usr/bin/\nRUN chmod 755 /usr/bin/openshift" \
    --source-image=openshift/origin:${ORENSHIFT_VERSION} \
    --source-image-path=/usr/bin/openshift:tmp

$ oc new-build \
    https://github.com/dsevost/origin-fedora \
    --context-dir=origin \
    --name origin

```