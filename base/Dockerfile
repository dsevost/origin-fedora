#
# This is the base image from which all OpenShift Origin images inherit. Only packages
# common to all downstream images should be here.
#
# The standard name for this image is openshift/origin-base
#

#
#	docker build -t origin-base .
#

FROM source

RUN \
    INSTALL_PKGS=" \
	bind-utils \
	findutils \
	hostname \
	iptables \
	lsof \
	socat \
	tar \
	tree \
	util-linux \
	which \
      " ; \
    dnf install --setopt=tsflags=nodocs -y ${INSTALL_PKGS} && \
    dnf clean all && \
    mkdir -p /var/lib/origin

LABEL io.k8s.display-name="OpenShift Origin Fedora Base" \
      io.k8s.description="This is the base image from which all OpenShift Origin images inherit." \
      io.openshift.tags="openshift,base"
