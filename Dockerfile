FROM alpine:3.10

RUN apk update && apk upgrade && \
    apk add --no-cache zip

COPY zip-it.sh /zip-it.sh

ENTRYPOINT ["/zip-it.sh"]
