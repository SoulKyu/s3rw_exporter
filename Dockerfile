# numberlyinfra/vault-injector
FROM golang:1.22.3-alpine3.20 AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux go build -o /s3rw_exporter

FROM scratch

WORKDIR /

COPY --from=build /s3rw_exporter /s3rw_exporter

COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

USER 65534

EXPOSE 8080

ENTRYPOINT ["/s3rw_exporter"]
