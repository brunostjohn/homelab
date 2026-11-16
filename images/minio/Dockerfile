FROM golang:1.27-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build

ENV CGO_ENABLED=0
RUN go install github.com/minio/minio@RELEASE.2025-10-15T17-29-55Z

FROM alpine:3.24@sha256:f59abe656b692d901e184be3445e084786602108599d2a51d229c0f5a48c71bf
RUN apk add --no-cache ca-certificates curl
COPY --from=build /go/bin/minio /usr/bin/minio
COPY --chmod=0755 docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD ["minio"]
LABEL org.opencontainers.image.source="https://github.com/minio/minio" \
      org.opencontainers.image.version="RELEASE.2025-10-15T17-29-55Z" \
      org.opencontainers.image.licenses="AGPL-3.0-only"
