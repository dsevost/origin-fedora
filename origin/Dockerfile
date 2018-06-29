#
# This is the official OpenShift Origin image. It has as its entrypoint the OpenShift
# all-in-one binary.
#
# While this image can be used for a simple node it does not support OVS based
# SDN or storage plugins required for EBS, GCE, Gluster, Ceph, or iSCSI volume
# management. For those features please use 'openshift/node'
#
# The standard name for this image is openshift/origin
#
FROM pre

LABEL \
    io.k8s.display-name="OpenShift Origin Application Platform" \
    io.k8s.description="OpenShift Origin is a platform for developing, building, and deploying containerized applications." \
    io.openshift.tags="openshift,core"

ENV \
    HOME=/root \
    KUBECONFIG=/var/lib/origin/openshift.local.config/master/admin.kubeconfig

WORKDIR /var/lib/origin

ENTRYPOINT ["/usr/bin/openshift"]

RUN \
    set -xe ; \
    dnf install -y ceph-common && dnf clean all && \
    setcap 'cap_net_bind_service=ep' /usr/bin/openshift ; \
    cd /usr/bin ; \
    LINKS="deploy docker-build extract-image-content \
	f5-router git-clone manage-dockerfile \
	recycle router s2i-build sti-build \
     "; \
    for l in $LINKS ; do \
	ln -s openshift openshift-${l} ; \
    done
