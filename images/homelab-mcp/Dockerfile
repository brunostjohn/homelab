FROM node:26-bookworm-slim@sha256:0042e17d232a87a2cd485be1da7900fca4d10a4ad11b29e9285da1d2e54798c9
LABEL org.opencontainers.image.source="https://github.com/brunostjohn/homelab"
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
ENV PATH="/app/node_modules/.bin:$PATH" HOME=/tmp
USER 1000:1000
ENTRYPOINT ["supergateway"]
