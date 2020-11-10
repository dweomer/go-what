ARG GOLANG=golang:1.15-alpine
FROM ${GOLANG} AS build
RUN apk --no-cache add binutils docker file git make

FROM scratch AS package
ARG GOARCH=amd64
COPY dist/artifacts/what-${GOARCH} /bin/what
ENTRYPOINT ["what"]
