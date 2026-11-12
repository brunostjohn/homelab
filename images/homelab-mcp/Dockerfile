FROM node:22-bookworm-slim@sha256:e9f565d32859f0cbfb52125eafe8be39390f24dac302dc3cdf566e8ba3ab21ee
LABEL org.opencontainers.image.source="https://github.com/brunostjohn/homelab"
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
ENV PATH="/app/node_modules/.bin:$PATH" HOME=/tmp
USER 1000:1000
ENTRYPOINT ["supergateway"]
