FROM ruby:2.3.3

RUN apt-get update -qq && \
    apt-get install -y \
        build-essential \
        libpq-dev \
        nodejs \
        rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY / /app/
# files could be mounted in dev for realtime code changes without rebuild
# typically that would be: .:/app

RUN mkdir /var/www && \
    chown -R www-data /app /var/www /usr/local/bundle

USER www-data

# install a matching bundler to Gemfile.lock
RUN gem install bundler -v 1.15.3

# install all gems
ARG env=development
ARG bundle_opts=

ENV RAILS_ENV $env
ENV RACK_ENV $env

RUN echo "Running \"bundle install $bundle_opts\" with environment set to \"$env\"..." && \
    bundle install $bundle_opts

# generate sitemap
RUN bundle exec rake rake sitemap:refresh RAILS_ENV=$env

EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]
CMD ["puma", "-C", "config/puma.rb"]
