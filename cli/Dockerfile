#
# This is the official OpenShift CLI image. It can be used to get a CLI environment
# for OpenShift.
#
# The standard name for this image is openshift/origin-cli
#
FROM pre-cli

ARG ZFS_REPO_FEDORA_REL
ARG ZFS_VERSION

RUN \
    INSTALL_PKGS="\
	btrfs-progs \
	e2fsprogs \
	git \
	openssl \
	xfsprogs \
	xz \
	" && \
    dnf install --setopt=tsflags=nodocs -y $INSTALL_PKGS && \
    dnf clean all && \
    cd /usr/bin && ln -s oc kubectl && \
    set -x ; \
    FC_REL=${ZFS_REPO_FEDORA_REL:-"27"} ; \
    ZFS_VER=${ZFS_VERSION:-0.7.9-1.fc${FC_REL}} ; \
    rpms='' ; \
    suffix="${ZFS_VER}.x86_64.rpm" ; \
    for p in zfs libnvpair1 libuutil1 libzfs2 libzpool2 ; do rpms+="http://download.zfsonlinux.org/fedora/${FC_REL}/x86_64/$p-$suffix " ; done ; \
    rpm -ihv --nodeps $rpms


LABEL \
    io.k8s.display-name="OpenShift Client" \
    io.k8s.description="OpenShift is a platform for developing, building, and deploying containerized applications." \
    io.openshift.tags="openshift,cli"
