#
# This is an OpenShift Origin node image with integrated OpenvSwitch SDN
# If you do not require OVS SDN use the openshift/origin image instead.
#
# This image expects to have a volume mounted at /etc/origin/node that contains
# a KUBECONFIG file giving the node permission to talk to the master and a
# node configuration file.
#
# The standard name for this image is openshift/node
#
FROM pre-node

LABEL io.k8s.display-name="OpenShift Origin Node" \
      io.k8s.description="This is a component of OpenShift Origin and contains the software for individual nodes when using SDN." \
      io.openshift.tags="openshift,node"

ENV \
    OPENSHIFT_CONTAINERIZED=true \
    KUBECONFIG=/etc/origin/node/node.kubeconfig

ENTRYPOINT [ "/usr/local/bin/origin-node-run.sh" ]

RUN \
    INSTALL_PKGS="\
	binutils \
	bridge-utils \
	btrfs-progs \
	conntrack-tools \
	dbus \
	device-mapper-libs \
	e2fsprogs \
	ethtool \
	iproute \
	iptables \
	kmod \
	kmod-libs \
	iscsi-initiator-utils bind-utils \
	libmnl \
	libnfnetlink \
	libnetfilter_conntrack \
	openssl \
	openvswitch \
	procps-ng \
	xfsprogs \
	xz \
	" && \
    dnf install --setopt=tsflags=nodocs -y $INSTALL_PKGS && \
    mkdir -p \
	/usr/lib/systemd/system/{docker,origin-node}.service.d

# Copy the cni plugins to the host file system when they are present, so that they can be shared with cri-o
RUN \
    if [ -d /opt/cni/bin ] ; then \
	mkdir -p /exports/hostfs/opt/cni/bin && \
	cp -r /opt/cni/bin/* /exports/hostfs/opt/cni/bin ; \
    fi

COPY \
    scripts/* \
    /usr/local/bin/

COPY \
    system-container/system-container-wrapper.sh \
    /usr/local/bin/

COPY \
    system-container/manifest.json \
    system-container/config.json.template \
    system-container/service.template \
    system-container/tmpfiles.template \
    /exports/

VOLUME /etc/origin/node
