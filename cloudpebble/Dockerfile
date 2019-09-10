#FROM python:2.7.16
FROM gfunkmonk/python:cloudpebble-base-alpine
SHELL ["/bin/bash", "-c"]

# Django stuff
RUN apk update && apk add --no-cache gettext \
memcached \
nodejs \
npm \
ca-certificates \
postgresql-client

RUN apk add --no-cache --virtual .build-deps \
gcc \ 
postgresql-dev \
python-dev \
libc-dev \
linux-headers \
musl-dev \
zlib-dev \
jpeg-dev \
build-base \
gettext-dev \
cmake

# Install language pack
#RUN set -ex && \
#    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
#    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
#    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
#    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-i18n-2.30-r0.apk && \
#    apk add glibc-bin-2.30-r0.apk glibc-i18n-2.30-r0.apk glibc-2.30-r0.apk

# Iterate through all locale and install it
# Note that locale -a is not available in alpine linux, use `/usr/glibc-compat/bin/locale -a` instead
#COPY ./locale.md /locale.md
#RUN cat locale.md | xargs -i /usr/glibc-compat/bin/localedef -i {} -f UTF-8 {}.UTF-8

# Set the lang, you can also specify it as as environment variable through docker-compose.yml
#ENV LANG=en_US.UTF-8 \
#    LANGUAGE=en_US.UTF-8

ENV MUSL_LOCPATH=/usr/local/share/i18n/locales/musl
RUN cd /tmp && git clone https://github.com/rilian-la-te/musl-locales.git \
&& cd /tmp/musl-locales && cmake . && make && make install

#RUN pip install psycopg2 django==1.6.2

EXPOSE 8000

# CloudPebble stuff
RUN npm install -g bower jshint jslint && echo '{"allow_root": true}' > /root/.bowerrc

# Grab the toolchain
RUN mkdir /arm-cs-tools && curl -L "https://gfunkmonk.s3.amazonaws.com/arm-cs-tools-4.9-2017.01.tar.xz" | tar --strip-components=1 -xJ -C /arm-cs-tools

ADD requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt \

# Install SDK 2
RUN mkdir /sdk2 && \
  curl -L "https://binaries.rebble.io/sdk-core/release/sdk-core-2.9.tar.bz2" | tar --strip-components=1 -xj -C /sdk2

# Install SDK 3
RUN mkdir /sdk3 && \
  curl -L "https://binaries.rebble.io/sdk-core/release/sdk-core-4.3.tar.bz2" | tar --strip-components=1 -xj -C /sdk3

# Install SDK 3 Node dependencies
RUN cd /sdk3 && npm install
ENV WAF_NODE_PATH=/sdk3/node_modules

COPY . /code
WORKDIR /code

# Bower is awful.
RUN rm -rf bower_components && cd /tmp && python /code/manage.py bower install && mv bower_components /code/
RUN python manage.py compilemessages && make -C /code/c-preload

#RUN service memcached start
RUN find /usr/local \
        \( -type d -a -name test -o -name tests \) \
        -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
        -exec rm -rf '{}' + \
    && runDeps="$( \
        scanelf --needed --nobanner --recursive /usr/local \
                | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
                | sort -u \
                | xargs -r apk info --installed \
                | sort -u \
    )" \
    && apk add --virtual .rundeps $runDeps \
    && apk del .build-deps
CMD ["sh", "docker_start.sh"]
