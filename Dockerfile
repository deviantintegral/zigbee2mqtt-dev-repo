FROM alpine:3.18.4 AS base

RUN apk add --no-cache tzdata eudev tini nodejs
RUN apk add --no-cache make gcc g++ python3 linux-headers git npm

ENV NODE_ENV=development
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN npm install -g pnpm

WORKDIR /app

COPY package.json ./
COPY .npmrc ./
COPY pnpm-workspace.yaml ./
COPY zigbee-herdsman ./zigbee-herdsman
COPY zigbee-herdsman-converters ./zigbee-herdsman-converters
COPY zigbee2mqtt ./zigbee2mqtt
COPY zigbee2mqtt-frontend ./zigbee2mqtt-frontend

RUN --mount=type=cache,target=/root/.cache,sharing=locked \
--mount=type=cache,target=/pnpm/store,sharing=locked \
  pnpm install && \
  pnpm --filter zigbee2mqtt add mqtt-packet \
  pnpm --filter zigbee-herdsman build && \ 
  pnpm --filter zigbee-herdsman-converters build && \ 
  pnpm --filter zigbee2mqtt build

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Support the same data path as production images
RUN mv /app/zigbee2mqtt/data /app
RUN ln -s /app/data /app/zigbee2mqtt/data

WORKDIR /app/zigbee2mqtt

RUN git rev-parse --short HEAD > dist/.hash

ENTRYPOINT ["docker-entrypoint.sh"]
CMD [ "/sbin/tini", "--", "node", "index.js"]
