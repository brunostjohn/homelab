FROM node:26-bookworm-slim@sha256:5df79989ed685e09f0a98019db4cebfb22fb9df1a53c0161664a011f7ff6b0f1
LABEL org.opencontainers.image.source="https://github.com/brunostjohn/homelab"
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
ENV PATH="/app/node_modules/.bin:$PATH" HOME=/tmp
USER 1000:1000
ENTRYPOINT ["supergateway"]
