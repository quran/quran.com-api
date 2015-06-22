server {
  listen   3000;
  server_name  quran;

  access_log  /var/log/nginx/localhost.access.log;

  location / {
    passenger_enabled on;
    passenger_user app;
    passenger_ruby /usr/bin/ruby2.2;
    passenger_app_env production;
    root   /home/app/quran/public;
    index  index.html index.htm;
  }
}
