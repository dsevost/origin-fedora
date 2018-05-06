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
FROM origin-pre

COPY \
    system-container/system-container-wrapper.sh \
    /usr/local/bin/

COPY \
    system-container/config.json.template \
    system-container/manifest.json \
    system-container/service.template \
    system-container/tmpfiles.template \
    /exports/

#
# openshift executable mustbe copied form openshift/origin docker image via OpenShift build feature like:
# oc new-build \
#	--name origin-pre \
#	-D "FROM origin-base\nADD tmp/openshift /usr/bin/\nRUN chmod 755 /usr/bin/openshift" \
#	--source-image=openshift/origin:${ORENSHIFT_VERSION} \
#	--source-image-path=/usr/bin/openshift:tmp
#

RUN 
    setcap 'cap_net_bind_service=ep' /usr/bin/openshift

LABEL io.k8s.display-name="OpenShift Origin Application Platform" \
      io.k8s.description="OpenShift Origin is a platform for developing, building, and deploying containerized applications." \
      io.openshift.tags="openshift,core"

ENV \
    HOME=/root \
    OPENSHIFT_CONTAINERIZED=true \
    KUBECONFIG=/var/lib/origin/openshift.local.config/master/admin.kubeconfig

WORKDIR /var/lib/origin

EXPOSE 8443 53

ENTRYPOINT ["/usr/bin/openshift"]
