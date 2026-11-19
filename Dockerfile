ARG NODE_IMAGE=node:24-alpine

FROM ${NODE_IMAGE} AS source
ARG DSBOT_REPO=https://github.com/Fei2411/DS-Bot.git
ARG DSBOT_REF=5e9b7da8882da3b68d8a0624342708c2150a9156
RUN apk add --no-cache git \
 && git init -q /src \
 && cd /src \
 && git remote add origin "${DSBOT_REPO}" \
 && git fetch -q --depth 1 --filter=blob:none origin "${DSBOT_REF}" \
 && git sparse-checkout init --cone \
 && git sparse-checkout set link \
 && git checkout -q FETCH_HEAD

FROM ${NODE_IMAGE} AS deps
COPY --from=source /src/link /app
WORKDIR /app
RUN npm ci --omit=dev --no-audit --no-fund --cache /tmp/npm-cache

FROM ${NODE_IMAGE} AS runtime
ENV NODE_ENV=production \
    HOST=0.0.0.0 \
    PORT=8787 \
    DSBOT_LINK_DATA=/data/devices.json
WORKDIR /app
COPY --from=deps /app /app
RUN mkdir -p /data && chown node:node /data
USER node
EXPOSE 8787
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e 'fetch("http://127.0.0.1:"+process.env.PORT+"/healthz").then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))'
ENTRYPOINT ["node", "server/main.ts"]
