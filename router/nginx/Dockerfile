#
# This is the NGINX router for OpenShift Origin.
#
# The standard name for this image is openshift/origin-nginx-router
#
FROM origin

LABEL \
    io.k8s.display-name="OpenShift Origin NGINX Router" \
    io.k8s.description="This is a component of OpenShift Origin and contains an NGINX instance that automatically exposes services within the cluster through routes, and offers TLS termination, reencryption, or SNI-passthrough on ports 80 and 443."

EXPOSE 80 443

WORKDIR /var/lib/nginx/conf

ENV \
    TEMPLATE_FILE=/var/lib/nginx/conf/nginx-config.template \
    RELOAD_SCRIPT=/var/lib/nginx/reload-nginx

ENTRYPOINT ["/usr/bin/openshift-router"]

RUN \
    INSTALL_PKGS="nginx" && \
    dnf install -y $INSTALL_PKGS && \
    dnf clean all && \
    mkdir -p /var/lib/nginx/router/{certs,cacerts} /var/lib/haproxy/router && \
    mkdir -p /var/lib/nginx/{conf,run,bin,log,logs} && \
    touch /var/lib/nginx/conf/{{os_http_be,os_edge_http_be,os_tcp_be,os_sni_passthrough,os_reencrypt,os_route_http_expose,os_route_http_redirect,cert_config,os_wildcard_domain}.map,nginx.config} && \
    setcap 'cap_net_bind_service=ep' /usr/sbin/nginx && \
    chown -R :0 /var/lib/nginx /var/lib/haproxy/router && \
    chown -R :0 /var/log/nginx && \
    chmod -R 777 /var/log/nginx && \
    chmod -R 777 /var/lib/nginx /var/lib/haproxy/router

COPY . /var/lib/nginx/

USER 1001
