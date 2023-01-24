FROM node:lts AS builder

COPY . /app

WORKDIR /app

RUN rm -rf node_modules package-lock.json && npm i

RUN rm -rf .koishi.db logs/*.log
RUN sed -i 's/host: .*/host: 0.0.0.0/g' /app/koishi.yml

FROM node:lts-alpine

RUN npm install -g npm@9.3.1

COPY --from=builder /app /app

RUN apk update && \
  apk upgrade && \
  apk add --update \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont \
  font-noto-cjk \
  ffmpeg && \
  rm -rf /var/cache/apk/*

RUN adduser -D koishi && \
  chown -R koishi /app

COPY --from=builder /root/.local/share/gocqhttp-nodejs/v1.0.0-rc4/go-cqhttp /root/.local/share/gocqhttp-nodejs/v1.0.0-rc4/go-cqhttp
COPY --from=builder /root/.local/share/gocqhttp-nodejs/v1.0.0-rc4/go-cqhttp /home/koishi/.local/share/gocqhttp-nodejs/v1.0.0-rc4/go-cqhttp

USER koishi

WORKDIR /app

ENTRYPOINT [ "npm", "start" ]
