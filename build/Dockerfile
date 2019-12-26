FROM golang:1.13-alpine as build

ENV GO111MODULE=on 
ENV GOOS=linux 
ENV GOARCH=amd64 
ENV GOARM=6 
ENV CGO_ENABLED=1

ENV TAG v0.28.2

RUN apk add --update build-base go git bash wget nodejs npm

RUN git clone -b ${TAG} https://github.com/storj/storj /root/go/src/storj.io/storj

WORKDIR /root/go/src/storj.io/storj

RUN go get -v ./cmd/...
RUN scripts/release.sh build -o release/${TAG}/storagenode_linux_amd64 storj.io/storj/cmd/storagenode && \
    mv /root/go/src/storj.io/storj/release/${TAG}/storagenode_linux_amd64 /usr/bin/storagenode
RUN scripts/release.sh build -o release/${TAG}/identity_linux_amd64 storj.io/storj/cmd/identity && \
    mv /root/go/src/storj.io/storj/release/${TAG}/identity_linux_amd64 /usr/bin/identity_linux_amd64
RUN ls /usr/bin/
RUN cp -R /root/go/src/storj.io/storj/web/storagenode /app/ && \
    cd /app  && \
    npm install && \
    npm run build

FROM alpine:latest

WORKDIR /app

RUN apk add --update ca-certificates bash

ENV AUTH_TOKEN="" ADDRESS="" WALLET="" BANDWIDTH="" STORAGE=""

COPY --from=build /usr/bin/storagenode /usr/bin/storagenode
COPY --from=build /usr/bin/identity_linux_amd64 /usr/bin/identity_linux_amd64
COPY --from=build /app/static /app/static
COPY --from=build /app/dist /app/dist
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

COPY entrypoint.sh /usr/bin/

ENTRYPOINT entrypoint.sh
