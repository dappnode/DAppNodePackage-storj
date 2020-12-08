FROM storjlabs/storagenode:latest

ARG UPSTREAM_VERSION
ENV DOWNLOAD_URL https://github.com/storj/storj/releases/download
WORKDIR /app

RUN apk add --update ca-certificates bash wget 

ENV AUTH_TOKEN="" ADDRESS="" WALLET="" BANDWIDTH="" STORAGE=""
RUN if [ "$(arch)" == "x86_64" ];then  export ARCH="amd64";else ARCH="arm64"; fi && \
    wget $DOWNLOAD_URL/$UPSTREAM_VERSION/identity_linux_${ARCH}.zip && \
    unzip identity_linux_${ARCH}.zip && \
    cp identity /usr/bin/identity

#ADD https://raw.githubusercontent.com/storj/storj/master/resources/certs.pem /etc/ssl/certs/ca-certificates.crt
#ADD https://raw.githubusercontent.com/storj/storj/master/cmd/storagenode/dashboard.sh /app/dashboard.sh
COPY entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh
