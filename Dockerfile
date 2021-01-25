FROM ruby:3.0.0-alpine

RUN apk add --no-cache curl postgresql-dev tzdata git make gcc g++ python3 linux-headers binutils-gold gnupg libstdc++ yarn bash autoconf automake libtool build-base

# install protobuf
ENV PROTOBUF_URL https://github.com/google/protobuf/releases/download/v3.3.0/protobuf-cpp-3.3.0.tar.gz
RUN curl -L -o /tmp/protobuf.tar.gz $PROTOBUF_URL
WORKDIR /tmp/
RUN tar xvzf protobuf.tar.gz
WORKDIR /tmp/protobuf-3.3.0
RUN mkdir /export
RUN ./autogen.sh && \
    ./configure --prefix=/usr && \
    make -j 3 && \
    make check && \
    make install
RUN ldconfig /etc/ld.so.conf.d

# Rails
ENV RAILS_ROOT /var/www/quran
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Adding gems
RUN gem install bundler
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config set without 'development test'
RUN bundle install --jobs 20 --retry 5

# Adding project files
COPY . .

# run yarn install
RUN yarn install --silent --no-progress --no-audit --no-optional

RUN mkdir -p /var/www/quran/tmp/pids/

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
