# OpenShift images based on Fedora

## Base images and sripts

### OpenShift Origin (v3.10)
https://github.com/openshift/origin/tree/release-3.10/images

### Etcd
https://github.com/projectatomic/atomic-system-containers/tree/master/etcd

## Build from template

```
$ oc new-project origin-images
$ oc create -f jenkins-openshift-images-builder-template.yaml
$ oc new-app jenkins-openshift-images-builder

```
