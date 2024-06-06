FROM alpine:3.19

RUN apk update && apk add unzip aws-cli postgresql16-client 7zip

ENTRYPOINT ["/bin/ash"]