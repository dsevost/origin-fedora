#
# This is the integrated OpenShift Origin Docker registry. It is configured to
# publish metadata to OpenShift to provide automatic management of images on push.
#
# The standard name for this image is openshift/origin-docker-registry
#
FROM pre-registry

EXPOSE 5000

VOLUME /registry

ENV REGISTRY_CONFIGURATION_PATH=/config.yml

CMD /usr/bin/dockerregistry ${REGISTRY_CONFIGURATION_PATH}

COPY config.yml ${REGISTRY_CONFIGURATION_PATH}

LABEL \
    io.k8s.display-name="OpenShift Container Platform Image Registry" \
    io.k8s.description="This is a component of OpenShift Container Platform and exposes a Docker registry that is integrated with the cluster for authentication and management." \
    io.openshift.tags="openshift,docker,registry"

# The registry doesn't require a root user.
USER 1001
