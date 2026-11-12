FROM node:22-bookworm-slim@sha256:18052396bf1d0c6e0a8c58181b5c1457da19409efbd5032a3f4d86974e74d13c
LABEL org.opencontainers.image.source="https://github.com/brunostjohn/homelab"
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
ENV PATH="/app/node_modules/.bin:$PATH" HOME=/tmp
USER 1000:1000
ENTRYPOINT ["supergateway"]
