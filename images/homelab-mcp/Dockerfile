FROM node:22-bookworm-slim@sha256:5ec23b7c622b00547753bc6ffd78085dd868a68aeb41c8e0a1418f033e13d96d
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --ignore-scripts && npm cache clean --force
ENV PATH="/app/node_modules/.bin:$PATH" HOME=/tmp
USER 1000:1000
ENTRYPOINT ["supergateway"]
