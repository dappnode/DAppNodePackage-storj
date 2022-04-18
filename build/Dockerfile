FROM storjlabs/storagenode:latest

ARG UPSTREAM_VERSION
ENV DOWNLOAD_URL https://github.com/storj/storj/releases/download
WORKDIR /app

RUN apk add --update ca-certificates bash wget 

ENV AUTH_TOKEN="" ADDRESS="" WALLET="" BANDWIDTH="" STORAGE=""
RUN if [ "$(arch)" == "x86_64" ];then  export ARCH="amd64";else ARCH="arm64"; fi && \
    wget $DOWNLOAD_URL/$UPSTREAM_VERSION/identity_linux_${ARCH}.zip && \
    unzip identity_linux_${ARCH}.zip && \
    mv identity /usr/local/bin/identity && \
    rm identity_linux_${ARCH}.zip && \
    wget $DOWNLOAD_URL/$UPSTREAM_VERSION/storagenode_linux_${ARCH}.zip && \
    unzip storagenode_linux_${ARCH} && \
    chmod +x storagenode

COPY entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh
