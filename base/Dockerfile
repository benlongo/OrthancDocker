FROM ubuntu:14.04

MAINTAINER Sebastien Jodogne <s.jodogne@gmail.com>
LABEL Description="Base environment to build Orthanc" Vendor="Sebastien Jodogne, University Hospital of Liege"

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget nano build-essential unzip cmake mercurial uuid-dev libcurl4-openssl-dev liblua5.1-0-dev libgtest-dev libpng-dev libsqlite3-dev libssl-dev libjpeg-dev zlib1g-dev libdcmtk2-dev libboost-all-dev libwrap0-dev libcharls-dev libjsoncpp-dev libpugixml-dev && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libgdcm2-dev libjpeg-dev postgresql-server-dev-all libtiff-dev libopenjpeg-dev libopenslide-dev && rm -rf /var/lib/apt/lists/*


ADD ./build.sh /root/build.sh
RUN bash /root/build.sh "default"

ADD ./build-webviewer.sh /root/build-webviewer.sh
RUN bash /root/build-webviewer.sh "default"

ADD ./build-postgresql.sh /root/build-postgresql.sh
RUN bash /root/build-postgresql.sh "default"

ADD ./build-dicomweb.sh /root/build-dicomweb.sh
RUN bash /root/build-dicomweb.sh "default"

ADD ./build-wsi.sh /root/build-wsi.sh
RUN bash /root/build-wsi.sh "default"


VOLUME [ "/var/lib/orthanc/db" ]
EXPOSE 4242
EXPOSE 8042


ENTRYPOINT [ "Orthanc" ]
CMD [ "/etc/orthanc/" ]
