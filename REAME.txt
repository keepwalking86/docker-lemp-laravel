# LEMP STACK
Linux Enginx MongoDB PHP7 for Laravel on CentOS 7

## Exposing external port (Nginx, Mongo, PHP-FPM)
```docker run -d -p 8081:80 -p 27018:27017 -p 9099:9000 -v `pwd`/mongo:/data/db -v `pwd`/app:/var/www/example --name lemp-laravel5 keepwalking/lemp-laravel5```
