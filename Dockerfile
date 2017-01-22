FROM phusion/passenger-customizable:0.9.19

# set correct environment variables
ENV HOME /root

# use baseimage-docker's init process
CMD ["/sbin/my_init"]

# customizing passenger-customizable image
RUN /pd_build/ruby-2.3.*.sh
RUN /pd_build/redis.sh

ENV RAILS_ENV production

# native passenger
RUN ruby2.3 -S passenger-config build-native-support
RUN setuser app ruby2.3 -S passenger-config build-native-support

# nginx
RUN rm /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD docker/backend.quran.com /etc/nginx/sites-enabled/backend.quran.com
ADD docker/postgres-env.conf /etc/nginx/main.d/postgres-env.conf
ADD docker/elasticsearch-env.conf /etc/nginx/main.d/elasticsearch-env.conf
ADD docker/gzip.conf /etc/nginx/conf.d/gzip.conf

# logrotate
COPY docker/nginx.logrotate.conf /etc/logrotate.d/nginx
RUN cp /etc/cron.daily/logrotate /etc/cron.hourly

# redis
RUN rm /etc/service/redis/down
RUN sed -i 's/^\(stop-writes-on-bgsave-error .*\)$/stop-writes-on-bgsave-error no/' /etc/redis/redis.conf && \
echo vm.overcommit_memory = 1 >> /etc/sysctl.conf

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

# let log files for nginx work
RUN mkdir -p /var/log/nginx/api.quran.com

# cleanup apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose port 3000
EXPOSE 3000
