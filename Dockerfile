ARG GOLANG=golang:1.15-alpine
FROM ${GOLANG} AS build
RUN apk --no-cache add binutils docker file g++ git jq make
WORKDIR /usr/lib/gh
ADD https://api.github.com/repos/cli/cli/releases/latest latest.json
RUN git clone https://github.com/cli/cli.git /usr/src/gh
WORKDIR /usr/src/gh
RUN git checkout $(jq -r .tag_name < /usr/lib/gh/latest.json)
RUN make \
 && install -s bin/gh /usr/bin \
 && gh --version
WORKDIR /go

FROM scratch AS package
ARG GOARCH=amd64
COPY dist/artifacts/what-${GOARCH} /bin/what
ENTRYPOINT ["what"]
