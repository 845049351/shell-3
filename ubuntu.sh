#!/bin/bash

#ubuntu系统环境基础设置
Setting(){

	sudo apt-get update
    	sudo apt-get -y upgrade
	sudo apt-get -y install python-software-properties
	sudo add-apt-repository -y ppa:nginx/stable
   	sudo apt-get update
   	sudo apt-get install -y git
}


#edusoho
Edusoho(){

	sudo mkdir /var/www
	cd /var/www
	sudo wget http://www.edusoho.com/edusoho-4.0.0.tar.gz
	sudo tar zxvf edusoho-4.0.0.tar.gz
	sudo chown www-data:www-data edusoho/ -Rf

}


#安装Nginx
Nginx(){

	sudo apt-get install -y nginx
   	sudo sed -i '/sendfile on;/ i client_max_body_size 1024M;' /etc/nginx/nginx.conf
   	rm /etc/nginx/sites-enabled/default

	sudo echo 'server {
    listen 80;
    server_name www.example.com example.com;
    root /var/www/edusoho/web;

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
}' |sudo tee /etc/nginx/sites-enabled/edusoho


}



#-------------------------------安装Mysql----------------------------
Mysql(){

	# sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
	# sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
	echo 'mysql-server-5.5 mysql-server/root_password password root' | sudo debconf-set-selections
	echo 'mysql-server-5.5 mysql-server/root_password_again password root' | sudo debconf-set-selections

	sudo apt-get install -y mysql-server
	mysql -uroot -proot -e"CREATE DATABASE edusoho DEFAULT CHARACTER SET utf8;"
	mysql -uroot -proot -e"GRANT ALL PRIVILEGES ON edusoho.* TO 'esuser'@'localhost' IDENTIFIED BY 'edusoho';"
}


#-------------------------------安装PHP------------------------------
PHP(){

	sudo apt-get install -y php5 php5-cli php5-curl php5-fpm php5-intl php5-mcrypt php5-mysqlnd php5-gd
    sudo sed -i 's/listen = 127.0.0.1:9000.*/listen = /var/run/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
	#修改PHP.ini配置
	sudo sed -i 's/memory_limit.*/memory_limit = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/upload_max_filesize.*/upload_max_filesize = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/post_max_size.*/post_max_size = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/max_execution_time.*/max_execution_time = 30000/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/max_input_time.*/max_input_time = 30000/g' /etc/php5/fpm/php.ini

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
