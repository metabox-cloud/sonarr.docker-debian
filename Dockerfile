#metaBox Sonarr
#https://www.github.com/metabox-cloud
FROM metaboxcloud/baseimage.debian:latest

LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="v1.0 - Sonarr :: metaBox.cloud"

COPY root/ /

RUN echo "[apt-key] adding mono gpg key" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "[apt-key] adding sonarr gpg key" && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    install_packages mono-devel \
                     nzbdrone \
                     mediainfo && \
    apt-get -y autoremove && \
    /cleanup

VOLUME  ["/config"]

EXPOSE 8989

ENTRYPOINT ["/init"]
