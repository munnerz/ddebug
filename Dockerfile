FROM alpine:3.6

RUN apk add --no-cache jq

ADD ddebug.sh /usr/local/bin/ddebug

ENTRYPOINT ["/usr/local/bin/ddebug"]
