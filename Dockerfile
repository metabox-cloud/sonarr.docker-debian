#metaBox Sonarr: PREVIEW
#https://www.github.com/metabox-cloud
FROM metaboxcloud/baseimage.debian:latest

LABEL maintainer="metaBox <contact@metabox.cloud>"
LABEL build="v1.0 - Sonarr - v3 Preview :: metaBox.cloud"

COPY root/ /

RUN echo "[apt-key] adding mono gpg key" && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "[apt-key] adding sonarr gpg key" && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    install_packages mono-devel \
                     mediainfo \
					 
RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
        jq && \
 echo "**** install sonarr ****" && \
 mkdir -p /app/sonarr/bin && \
  if [ -z ${SONARR_VERSION+x} ]; then \
	SONARR_VERSION=$(curl -sX GET https://services.sonarr.tv/v1/download/${SONARR_BRANCH}?version=3 \
	| jq -r '.version'); \
 fi && \
 curl -o \
	/tmp/sonarr.tar.gz -L \
	"https://download.sonarr.tv/v3/${SONARR_BRANCH}/${SONARR_VERSION}/Sonarr.${SONARR_BRANCH}.${SONARR_VERSION}.linux.tar.gz" && \
 tar xf \
	/tmp/sonarr.tar.gz -C \
	/opt/NzbDrone/bin --strip-components=1 && \
 echo "UpdateMethod=docker\nBranch=${SONARR_BRANCH}\nPackageVersion=${VERSION}\nPackageAuthor=metaBox.cloud" > /opt/NzbDrone/package_info && \
 rm -rf /opt/NzbDrone/bin/Sonarr.Update && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/tmp/* \
    apt-get -y autoremove && \
    /cleanup

VOLUME  ["/config"]
VOLUME  ["/mb"]

EXPOSE 8989

ENTRYPOINT ["/init"]
