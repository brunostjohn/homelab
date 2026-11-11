FROM golang:1.26-alpine@sha256:30b1e546a9c7fa3b747c2bdba3a0c7bdf3a02ebb4c5b8405d2f948d7e8aac4ec AS build
ENV CGO_ENABLED=0
RUN go install github.com/minio/console/cmd/console@v1.7.6

FROM alpine:3.23@sha256:469c9ea410b9215eaee7976ba6c0639039b444be8e5d638f7abbada189971eb2
RUN apk add --no-cache ca-certificates
COPY --from=build /go/bin/console /usr/bin/console
USER 1000:1000
ENTRYPOINT ["/usr/bin/console"]
CMD ["server", "--host", "0.0.0.0", "--port", "9090"]
LABEL org.opencontainers.image.source="https://github.com/minio/console" \
      org.opencontainers.image.revision="f4a08fc0af8f776aa667677fb943aad137808f7c" \
      org.opencontainers.image.version="v1.7.6" \
      org.opencontainers.image.licenses="AGPL-3.0-or-later"
