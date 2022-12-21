https://blackarch.ru/?p=1029


# Установка Nginx
#### Установка Nginx выполняется следующей командой:
```text
sudo pacman -S nginx
```

#### Запустите службу:
```text
sudo systemctl start nginx
```

И проверьте её статус:
sudo systemctl status nginx


Установка MariaDB или MySQL
Для установки MariaDB выполните команду:
pacman -S mysql
Я выбрал MariaDB по этому нажал 1

Выполним установку баз данных и заполнение таблиц, необходимых для функционирования MariaDB:
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

Усилим безопасность окружения СУБД MariaDB/MySQL
mysql_secure_installation

Запускаем и проверяем статус службы:
systemctl start mysqld
systemctl status mysqld

Чтобы проверить безопасность входа MariaDB, используйте команду
mysql -u root -p
после которой вам нужно ввести пароль.
>> Для выхода, наберите команду exit или quit

Установка PHP
pacman -S php php-fpm
systemctl start php-fpm
systemctl status php-fpm

Установка phpMyAdmin
sudo pacman -S phpmyadmin openssl
sudo ln -s /usr/share/webapps/phpMyAdmin /usr/share/nginx/html

Теперь нам нужно настроить файл php.ini чтобы включить необходимые для phpMyAdmin расширения:
sudo vim /etc/php/php.ini

раскомментируйте
extension=bz2
extension=iconv
extension=imap
extension=mysqli
extension=pdo_mysql
extension=zip
mysqli.allow_local_infile = On
session.save_path = "/tmp"

Путей по умолчанию, эта директива должна выглядеть так:
open_basedir= /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/:/usr/share/nginx/html

Включение PHP-FPM FastCGI
Создаем резервную копию
sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

Создайте новый файл:
sudo nano /etc/nginx/nginx.conf

И скопируйте в него следующее:
#user html;
 
worker_processes  2;
 
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#pid        logs/nginx.pid;
 
events {
    worker_connections  1024;
}
 
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
 
    #tcp_nopush     on;
    #keepalive_timeout  0;
 
    keepalive_timeout  65;
 
    gzip  on;
 
    types_hash_max_size 4096;
 
    server {
        listen       80;
        server_name  localhost;
        root   /usr/share/nginx/html;
        charset utf-8;
        location / {
            index  index.php index.html index.htm;
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;
        }
 
        location /phpmyadmin {
            rewrite ^/* /phpMyAdmin last;
        }
 
        error_page  404              /404.html;
        # redirect server error pages to the static page /50x.html
        error_page   500 502 503 504  /50x.html;
 
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
 
        location ~ \.php$ {
            #fastcgi_pass 127.0.0.1:9000; (зависит от конфигурации сокета вашего php-fpm)
            fastcgi_pass unix:/run/php-fpm/php-fpm.sock;
            fastcgi_index index.php;
            include fastcgi.conf;
        }
 
        location ~ /\.ht {
            deny  all;
        }
    }         
}

Перезапустим службы Nginx и PHP-FPM
sudo systemctl restart php-fpm
sudo systemctl restart nginx

Откроем в браузере http://localhost:

Если всё работает как задумано, то добавим службы LEMP в автозагрузку следующими командами:
sudo systemctl enable php-fpm
sudo systemctl enable nginx
sudo systemctl enable mysqld
