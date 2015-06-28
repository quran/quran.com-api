FROM phusion/passenger-customizable:0.9.15

# set correct environment variables
ENV HOME /root

# use baseimage-docker's init process
CMD ["/sbin/my_init"]

# customizing passenger-customizable image
RUN /pd_build/ruby2.2.sh
RUN /pd_build/nodejs.sh
RUN /pd_build/redis.sh

ENV RAILS_ENV production

# upgrade passenger
RUN apt-get update
RUN apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

# native passenger
RUN setuser app ruby2.2 -S passenger-config build-native-support

# nginx
RUN rm /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD docker/backend.quran.com /etc/nginx/sites-enabled/backend.quran.com
ADD docker/postgres-env.conf /etc/nginx/main.d/postgres-env.conf
ADD docker/elasticsearch-env.conf /etc/nginx/main.d/elasticsearch-env.conf

# redis
RUN rm /etc/service/redis/down

# setup gems
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# setup the app
RUN mkdir /home/app/quran
ADD . /home/app/quran/

WORKDIR /home/app/quran
RUN chown -R app log
RUN chown -R app public
RUN chown app Gemfile
RUN chown app Gemfile.lock

# cleanup apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose port 3000
EXPOSE 3000
