FROM alpine:3.10

RUN apk update && apk upgrade && \
    apk add --no-cache bash zip

COPY zip-it.sh /zip-it.sh
COPY zip-it /zip-it
RUN chmod +x /zip-it*

ENTRYPOINT ["/zip-it.sh"]
