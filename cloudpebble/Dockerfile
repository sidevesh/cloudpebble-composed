FROM gfunkmonk/cloudpebble:alpine AS squashme
SHELL ["/bin/bash", "-c"]

RUN apk update && apk add --no-cache gettext \
nodejs npm \
freetype \
postgresql-client \
&& rm -rf /var/cache/apk/*

RUN apk add --no-cache --virtual .build-deps \
postgresql-dev \
libc-dev linux-headers \
zlib-dev jpeg-dev gettext-dev \
build-base musl-dev make \
cmake gcc g++ make binutils \
&& rm -rf /var/cache/apk/*

RUN npm install -g jshint jslint

ENV MUSL_LOCPATH=/usr/local/share/i18n/locales/musl
RUN cd /tmp && git clone https://github.com/rilian-la-te/musl-locales.git \
&& cd /tmp/musl-locales && cmake . && make && make install

RUN pip install psycopg2 django==1.6.2

EXPOSE 8000

# CloudPebble stuff
RUN npm install -g bower && echo '{"allow_root": true}' > /root/.bowerrc

# Grab the toolchain
RUN mkdir /arm-cs-tools && curl -L "https://gfunkmonk.s3.amazonaws.com/arm-cs-tools-4.9-2017.01.tar.xz" | tar --strip-components=1 -xJ -C /arm-cs-tools

# Grab the toolchain
#RUN curl -o /tmp/arm-cs-tools.tar https://cloudpebble-vagrant.s3.amazonaws.com/arm-cs-tools-stripped.tar && \ 
#  tar -xf /tmp/arm-cs-tools.tar -C / && rm /tmp/arm-cs-tools.tar

ADD requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install SDK 2
RUN mkdir /sdk2 && curl -L "https://binaries.rebble.io/sdk-core/release/sdk-core-2.9.tar.bz2" | tar --strip-components=1 -xj -C /sdk2

# Install SDK 3
RUN mkdir /sdk3 && curl -L "https://binaries.rebble.io/sdk-core/release/sdk-core-4.3.tar.bz2" | tar --strip-components=1 -xj -C /sdk3

# Install SDK 3 Node dependencies
RUN cd /sdk3 && npm install
ENV WAF_NODE_PATH=/sdk3/node_modules

COPY . /code
WORKDIR /code

# Bower is awful.
RUN rm -rf bower_components && cd /tmp && python /code/manage.py bower install && mv bower_components /code/
RUN python manage.py compilemessages
RUN make -C /code/c-preload

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
    && apk add --virtual .rundeps $runDeps && rm -rf /var/cache/apk/* \
    && apk del .build-deps

FROM scratch
COPY --from=squashme / /
WORKDIR /code
ENV WAF_NODE_PATH=/sdk3/node_modules

CMD ["sh", "docker_start.sh"]
