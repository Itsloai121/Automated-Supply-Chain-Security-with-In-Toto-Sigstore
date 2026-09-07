# syntax=docker/dockerfile:1.7

FROM golang:1.24-alpine AS build
ARG VERSION=dev
ARG COMMIT=unknown
ARG BUILD_DATE=unknown
RUN apk add --no-cache ca-certificates
WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY app ./app
RUN CGO_ENABLED=0 GOOS=linux go build \
    -trimpath \
    -ldflags "-s -w -X main.version=${VERSION} -X main.commit=${COMMIT} -X main.buildTime=${BUILD_DATE}" \
    -o /out/chainshield ./app

FROM gcr.io/distroless/static-debian12:nonroot
ARG VERSION=dev
ARG COMMIT=unknown
ARG BUILD_DATE=unknown
LABEL org.opencontainers.image.title="ChainShield demo service" \
      org.opencontainers.image.description="Workload protected by an attest-and-verify software supply chain" \
      org.opencontainers.image.source="https://github.com/YOUR_GITHUB_OWNER/YOUR_GITHUB_REPOSITORY" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${COMMIT}" \
      org.opencontainers.image.created="${BUILD_DATE}"
COPY --from=build --chown=nonroot:nonroot /out/chainshield /chainshield
USER nonroot:nonroot
EXPOSE 8080
ENTRYPOINT ["/chainshield"]
