#!/bin/bash

Setting(){

yum install -y wget&&sudo yum install -y glibc.i686    #安装下载工具wget
wget http://www.atomicorp.com/installers/atomic  #下载atomic yum源
sh ./atomic   #安装
yum -y check-update  #更新yum软件包
yum -y update     #更新系统
}

Nginx(){

yum install -y nginx
service nginx start    #启动
chkconfig nginx on    #设为开机启动
sudo sed -i '/sendfile        on;/ i client_max_body_size 1024M;' /etc/nginx/nginx.conf&&sudo rm /etc/nginx/conf.d/default.conf&&sudo rm /etc/nginx/conf.d/ssl.conf&&sudo rm /etc/nginx/conf.d/virtual.conf
sudo echo 'server {
    listen 80;
    server_name www.example.com example.com;
    root /usr/share/nginx/edusoho/web;

    access_log /var/log/nginx/example.com.access.log;
    error_log /var/log/nginx/example.com.error.log;

    location / {
        index app.php;
        try_files $uri @rewriteapp;
    }

    location @rewriteapp {
        rewrite ^(.*)$ /app.php/$1 last;
    }

    location ~ ^/udisk {
        internal;
        root /var/www/edusoho/app/data/;
    }

    location ~ ^/(app|app_dev)\.php(/|$) {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS              off;
        fastcgi_param HTTP_X-Sendfile-Type X-Accel-Redirect;
        fastcgi_param HTTP_X-Accel-Mapping /udisk=/var/www/edusoho/app/data/udisk;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 8 128k;
    }

    location ~* \.(jpg|jpeg|gif|png|ico|swf)$ {
        expires 3y;
        access_log off;
        gzip off;
    }

    location ~* \.(css|js)$ {
        access_log off;
        expires 3y;
    }

    location ~ ^/files/.*\.(php|php5)$ {
        deny all;
    }

    location ~ \.php$ {
        
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS              off;
    }
}' |sudo tee /etc/nginx/conf.d/edusoho.conf

}

Mysql(){
yum install -y mysql mysql-server&&chkconfig mysqld on&&sudo cp /usr/share/mysql/my-medium.cnf   /etc/my.cnf&&service mysqld restart&&/usr/bin/mysqladmin -u root password 'root'
mysql -uroot -proot -e"CREATE DATABASE edusoho DEFAULT CHARACTER SET utf8;"
mysql -uroot -proot -e"GRANT ALL PRIVILEGES ON edusoho.* TO 'esuser'@'localhost' IDENTIFIED BY 'edusoho';"
}

Php(){

yum install -y php php-cli php-curl php-fpm php-intl php-mcrypt php-mysqlnd php-gd php-mbstring php-xml php-dom
sudo sed -i 's/memory_limit.*/memory_limit = 1024M/g' /etc/php.ini
sudo sed -i 's/upload_max_filesize.*/upload_max_filesize = 1024M/g' /etc/php.ini
sudo sed -i 's/post_max_size.*/post_max_size = 1024M/g' /etc/php.ini
sudo sed -i 's/max_execution_time.*/max_execution_time = 30000/g' /etc/php.ini
sudo sed -i 's/max_input_time.*/max_input_time = 30000/g' /etc/php.ini
chkconfig php-fpm on  #设置开机启动
}

Edusoho(){

wget http://stedolan.github.io/jq/download/linux32/jq&&chmod +x jq
curl http://www.edusoho.com/version/edusoho >out.txt&&cat out.txt | ./jq . | ./jq .url |cat > url.txt&&tr -d \" < url.txt | cat > download.txt&&wget -O edusoho.tar.gz -i download.txt&&sudo tar -zxvf edusoho.tar.gz -C /usr/share/nginx&&sudo chmod 777 /usr/share/nginx/edusoho/ -Rf
}

echo '#######################################################'
echo '#Welcome to use Edusoho one-click installation script!#'
echo '#######################################################'

Setting
Nginx
Mysql
Php
Edusoho
sudo /etc/init.d/php-fpm restart&&sudo /etc/init.d/nginx restart&&sudo /etc/init.d/mysqld restart&&/etc/init.d/iptables stop

