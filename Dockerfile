FROM node:lts

RUN TEMP=$(mktemp) && \
  curl -o $TEMP https://github.com/Mrs4s/go-cqhttp/releases/download/v1.0.0-rc4/go-cqhttp_linux_amd64.tar.gz && \
  tar zxvf $TEMP
