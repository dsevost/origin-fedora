FROM source

ENV VERSION=0.1 RELEASE=10 ARCH=x86_64

LABEL com.redhat.component="etcd" \
      name="$FGC/etcd" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      summary="A key-value store for shared configuration and service discovery." \
      maintainer="Giuseppe Scrivano <gscrivan@redhat.com>"

EXPOSE 4001 7001 2379 2380

CMD ["/usr/bin/etcd-env.sh", "/usr/bin/etcd"]

RUN \
    dnf --setopt=tsflags=nodocs install -y \
	etcd \
	hostname \
    && \
    dnf clean all && \
    mkdir -p /exports/hostfs/usr/local/bin && \
    cp /usr/bin/etcdctl /exports/hostfs/usr/local/bin/etcdctl && \
    mkdir -p /exports/hostfs/etc/etcd && \
    sed -e \
	"/^ETCD_DATA_DIR/d ; s|^ETCD_NAME=|#ETCD_NAME=|" \
	< /etc/etcd/etcd.conf > /exports/hostfs/etc/etcd/etcd.conf

COPY \
    etcd-env.sh \
    /usr/bin/etcd-env.sh

COPY \
    tmpfiles.template config.json.template service.template manifest.json \
    /exports/
