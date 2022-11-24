<<<<<<< HEAD
FROM ruby:2.7.2-alpine AS base

# Set a variable for the install location.
ARG RAILS_ROOT=/usr/src/app
# Set Rails environment.
ENV RAILS_ENV production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

# Make the directory and set as working.
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev sqlite-libs sqlite-dev yaml-dev zlib-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata"

# Install app dependencies.
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

COPY Gemfile* ./
COPY Gemfile Gemfile.lock $RAILS_ROOT/

RUN bundle config --global frozen 1 \
    && bundle config set deployment 'true' \
    && bundle config set without 'development:test:assets' \
    && bundle install -j4 --path=vendor/bundle \
    && rm -rf vendor/bundle/ruby/2.7.0/cache/*.gem \
    && find vendor/bundle/ruby/2.7.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.7.0/gems/ -name "*.o" -delete

# Adding project files.
COPY . .

# Remove folders not needed in resulting image
RUN rm -rf tmp/cache spec

############### Build step done ###############

FROM ruby:2.7.2-alpine

# Set a variable for the install location.
ARG RAILS_ROOT=/usr/src/app
ARG PACKAGES="tzdata curl postgresql-client sqlite-libs yarn nodejs bash"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES


COPY --from=base $RAILS_ROOT $RAILS_ROOT

# Expose port 80.
EXPOSE 80

# Sets the footer of greenlight application with current build version
ARG version_code
ENV VERSION_CODE=$version_code

# Set executable permission to start file
RUN chmod +x bin/start
# Update HTTPClient cacert.pem with the latest Mozilla cacert.pem
RUN wget https://curl.se/ca/cacert.pem https://curl.se/ca/cacert.pem.sha256 -P /tmp
RUN cd /tmp && sha256sum cacert.pem > cacert.pem.sha256sum && cd ${RAILS_ROOT}
RUN diff /tmp/cacert.pem.sha256sum /tmp/cacert.pem.sha256
RUN mv -v /tmp/cacert.pem $(bundle info httpclient --path)/lib/httpclient/ && rm -v /tmp/cacert*

# Update Openssl certs [This is for Faraday adapter for Net::HTTP]
RUN [[ $(id -u) -eq 0 ]] && update-ca-certificates
# Start the application.
CMD ["bin/start"]
=======
FROM alpine:3.16 AS alpine

ARG RAILS_ROOT=/usr/src/app
ENV RAILS_ROOT=${RAILS_ROOT}

FROM alpine AS base
WORKDIR $RAILS_ROOT
RUN apk add --no-cache \
    libpq \
    libxml2 \
    libxslt \
    ruby \
    ruby-irb \
    ruby-bigdecimal \
    ruby-bundler \
    ruby-json \
    tzdata \
    bash \
    shared-mime-info

FROM base
RUN apk add --no-cache \
    build-base \
    curl-dev \
    git \
    gettext \
    imagemagick \
    libxml2-dev \
    libxslt-dev \
    pkgconf \
    postgresql-dev \
    sqlite-libs \
    sqlite-dev \
    ruby-dev \
    nodejs npm \
    yarn \
    yaml-dev \
    zlib-dev \
    && ( echo 'install: --no-document' ; echo 'update: --no-document' ) >>/etc/gemrc
COPY . ./
RUN bundle install -j4 \
    && yarn install \
    && ./node_modules/.bin/esbuild app/javascript/*.* --bundle --sourcemap --outdir=app/assets/builds

ARG RAILS_ENV
ENV RAILS_ENV=${RAILS_ENV:-production}
ARG RAILS_LOG_TO_STDOUT
ENV RAILS_LOG_TO_STDOUT=${RAILS_LOG_TO_STDOUT:-true}
ARG RAILS_SERVE_STATIC_FILES
ENV RAILS_SERVE_STATIC_FILES=${RAILS_SERVE_STATIC_FILES:-true}
ARG PORT
ENV PORT=${PORT:-3000}

EXPOSE ${PORT}

ARG VERSION_TAG
ENV VERSION_TAG=$VERSION_TAG

ENTRYPOINT [ "./bin/start" ]
>>>>>>> 5a3eb37130dbeeddf333366e83bfc929424877c8
