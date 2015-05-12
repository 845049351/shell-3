#!/bin/bash

Setting(){

yum install -y wget    #安装下载工具wget
wget http://www.atomicorp.com/installers/atomic  #下载atomic yum源
sh ./atomic   #安装
yum check-update  #更新yum软件包
yum update     #更新系统
}

Edusoho(){

cd /usr/share/nginx
wget http://www.edusoho.com/edusoho-2.8.4.tar.gz
sudo tar zxvf edusoho-4.0.0.tar.gz
rm edusoho-4.0.0.tar.gz
chown apache:apache edusoho/ -Rf
}


#安装Nginx
Nginx(){

yum install -y nginx
service nginx start    #启动
chkconfig nginx on    #设为开机启动

   	sudo sed -i '/sendfile on;/ i client_max_body_size 1024M;' /etc/nginx/nginx.conf
   	rm /etc/nginx/sites-enabled/default

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
        fastcgi_pass   unix:/var/run/php5-fpm.sock;
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
        
        fastcgi_pass   unix:/var/run/php5-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
        fastcgi_param  HTTPS              off;
    }
}' |sudo tee /etc/nginx/conf.d/edusoho.conf

}

Mysql(){

# sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
# sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
echo 'mysql-server-5.5 mysql-server/root_password password root' | sudo debconf-set-selections
echo 'mysql-server-5.5 mysql-server/root_password_again password root' | sudo debconf-set-selections
yum install -y mysql mysql-server
/etc/init.d/mysqld start
chkconfig mysqld on   
cp /usr/share/mysql/my-medium.cnf   /etc/my.cnf
mysql -uroot -proot -e"CREATE DATABASE edusoho DEFAULT CHARACTER SET utf8;"
mysql -uroot -proot -e"GRANT ALL PRIVILEGES ON edusoho.* TO 'esuser'@'localhost' IDENTIFIED BY 'edusoho';"
}

PHP(){

yum install -y php php-cli php-curl php-fpm php-intl php-mcrypt php-mysqlnd php-gd php-mbstring php-xml php-dom
sudo sed -i 's/memory_limit.*/memory_limit = 1024M/g' /etc/php.ini
sudo sed -i 's/upload_max_filesize.*/upload_max_filesize = 1024M/g' /etc/php.ini
sudo sed -i 's/post_max_size.*/post_max_size = 1024M/g' /etc/php.ini
sudo sed -i 's/max_execution_time.*/max_execution_time = 30000/g' /etc/php.ini
sudo sed -i 's/max_input_time.*/max_input_time = 30000/g' /etc/php.ini
/etc/rc.d/init.d/php-fpm start  #启动php-fpm
chkconfig php-fpm on  #设置开机启动
}

echo "欢迎使用EDUSOHO安装脚本!"

Setting
Edusoho
Nginx
Mysql
PHP
sudo /etc/init.d/php5-fpm restart
sudo /etc/init.d/nginx restart
sudo /etc/init.d/mysql restart


server {

listen 80;
server_name www.centos.edu;

root /usr/share/nginx/edusoho/web;



access_log /var/log/nginx/edusoho.access.log;

error_log /var/log/nginx/edusoho.error.log;



location / {

index app.php;

try_files $uri @rewriteapp;

}



location @rewriteapp {

rewrite ^(.*)$ /app.php/$1 last;

}



location ~ ^/udisk {

internal;

root /usr/share/nginx/edusoho/app/data/;

}



location ~ ^/(app|app_dev)\.php(/|$) {



fastcgi_pass   127.0.0.1:9000;

fastcgi_split_path_info ^(.+\.php)(/.*)$;

include fastcgi_params;

fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;

fastcgi_param  HTTPS              off;

fastcgi_param HTTP_X-Sendfile-Type X-Accel-Redirect;

fastcgi_param HTTP_X-Accel-Mapping /udisk=/usr/share/nginx/edusoho/app/data/udisk;

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

fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;

fastcgi_param  HTTPS              off;

include        fastcgi_params;



}

}



