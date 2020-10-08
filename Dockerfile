#metaBox Sonarr: PREVIEW
#https://www.github.com/metabox-cloud
FROM metaboxcloud/baseimage.debian:latest

LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="v1.0 - Sonarr - v3 Preview :: metaBox.cloud"

COPY root/ /

RUN echo "[apt-key] adding mono gpg key" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    install_packages mono-devel \
                     mediainfo \
                     jq \
                     curl

RUN \
 echo "**** install sonarr ****" && \
 mkdir -p /opt/NzbDrone/bin && \
 curl -o \
        /tmp/sonarr.tar.gz -L \
        "https://services.sonarr.tv/v1/download/phantom-develop/latest?version=3&os=linux" && \
 tar xf \
        /tmp/sonarr.tar.gz -C \
        /opt/NzbDrone --strip-components=1 && \
 echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${VERSION}\nPackageAuthor=metaBox.cloud" > /opt/NzbDrone/package_info && \
 rm -rf /opt/NzbDrone/Sonarr.Update && \
 echo "**** cleanup ****" && \
 rm -rf \
        /tmp/* \
        /var/tmp/* \
    /cleanup

VOLUME  ["/config"]
VOLUME  ["/mb"]

EXPOSE 8989

ENTRYPOINT ["/init"]