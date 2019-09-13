FROM alpine:3.3
MAINTAINER Bryan Talbot <bryan.talbot@ijji.com>
WORKDIR /fakes3_root
VOLUME ["/fakes3_root"]
EXPOSE 4569
CMD ["fakes3", "server", "--root",  ".", "--port",  "4569"]

RUN apk add --no-cache ruby ruby-io-console

RUN gem install fakes3 -v 0.2.5 --no-doc

