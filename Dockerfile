ARG GOLANG="golang:1.15-alpine"
FROM ${GOLANG} AS build
COPY . /go/src/go-what
WORKDIR /go/src/go-what
RUN apk --no-cache add bash curl docker git make
RUN make build

FROM scratch AS package
COPY --from=build /go/src/go-what/bin/what /bin/what
