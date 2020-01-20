# Nginx redirect URL

```
docker run --name mynginx1 -p 8084:80 -d nginx

cat > nginx.conf <<EOF
server {
    listen 80;
    listen [::]:80;
    # hostname example.com www.example.com;
    root /var/www/example.com/public;
    rewrite ^/(.*)$ $scheme://192.168.160.112:9000/$1 permanent;
}
EOF
```

# Nginx enable directory listing

```
server {
       listen 8970;
       root  /usr/src/redhat/RPMS/x86_64/;
       location / {
               autoindex on;
        }
}
```

# Nginx add password protection

```
apt-get install -y nginx apache2-utils

htpasswd -c /etc/nginx/conf.d/kibana.htpasswd myusername

mypassword

rm /etc/nginx/sites-enabled/default

vim /etc/nginx/sites-enabled/kibana

service nginx stop
service nginx start
service nginx status
```

/etc/nginx/sites-enabled/kibana:

```
# Nginx proxy for Kibana
#
# In this setup, we are password protecting the saving of dashboards. You may
# wish to extend the password protection to all paths.
#
# Even though these paths are being called as the result of an ajax request, the
# browser will prompt for a username/password on the first request
#
# If you use this, you'll want to point config.js at http://FQDN:80/ instead of
# http://FQDN:9200
#

server {
  listen                *:80 ;

  # server_name           logcatcher.fqdn.example.com;
  access_log            /var/log/nginx/kibana.access.log;

  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:5601;
    auth_basic "Restricted";
    auth_basic_user_file /etc/nginx/conf.d/kibana.htpasswd;
   }
}
```
