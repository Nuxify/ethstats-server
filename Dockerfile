FROM node:lts-alpine AS builder
ARG GRUNT_TASK=poa
WORKDIR /ethstats-server
COPY ["package.json", "package-lock.json*", "./"]
RUN npm ci --only=production && npm install -g grunt-cli
COPY --chown=node:node . .
RUN grunt $GRUNT_TASK --configPath="./common.config.js"

FROM node:lts-alpine
RUN apk add dumb-init
WORKDIR /ethstats-server
COPY --chown=node:node --from=builder /ethstats-server .
USER node

CMD ["dumb-init", "node", "./bin/www"]
