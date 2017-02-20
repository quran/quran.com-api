server {
  listen   3000;
  server_name  api.quran.com;

  access_log  /var/log/nginx/api.quran.com/access.log;
  error_log  /var/log/nginx/api.quran.com/error.log;

  location / {
    passenger_enabled on;
    passenger_user app;
    passenger_ruby /usr/bin/ruby2.3;
    passenger_app_env production;
    passenger_max_request_queue_size 200;
    passenger_ruby /usr/local/rvm/rubies/ruby-2.3.1/bin/ruby;
    root   /home/app/quran/public;
    index  index.html index.htm;
  }
}
