#!/bin/bash

#ubuntu系统环境基础设置
Setting(){

	sudo apt-get update
    sudo apt-get -y upgrade
	sudo apt-get -y install python-software-properties
	sudo add-apt-repository -y ppa:nginx/stable
   	sudo apt-get update
}


#edusoho
edusoho(){
	
	sudo mkdir /var/www
	cd /var/www
	sudo wget http://www.edusoho.com/edusoho-3.3.4.tar.gz
	sudo tar zxvf edusoho-3.3.4.tar.gz
	sudo chown www-data:www-data edusoho/ -Rf
	
}


#安装Nginx
Nginx(){

	sudo apt-get install -y nginx
   	sudo sed -i '/sendfile on;/ i client_max_body_size 1024M;' /etc/nginx/nginx.conf
   	sudo /etc/init.d/nginx restart

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

	sudo /etc/init.d/mysql restart	
    	
}


#-------------------------------安装PHP------------------------------
PHP(){
	
	sudo apt-get install -y php5 php5-cli php5-curl php5-fpm php5-intl php5-mcrypt php5-mysqlnd php5-gd
    sudo sed -i 's/listen = 127.0.0.1:9000.*/listen = /var/run/php5-fpm.sock/g' /etc/php5/fpm/pool.d/www.conf
	#修改PHP.ini配置
	sudo sed -i 's/memory_limit.*/memory_limit = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/upload_max_filesize.*/upload_max_filesize = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/post_max_size.*/post_max_size = 1024M/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/max_execution_time.*/max_execution_time = 300/g' /etc/php5/fpm/php.ini
    sudo sed -i 's/max_input_time.*/max_input_time = 300/g' /etc/php5/fpm/php.ini
    sudo /etc/init.d/php5-fpm restart
	
	sudo /etc/init.d/nginx restart
}

echo "欢迎使用EDUSOHO安装脚本!"

Setting
edusoho
Nginx
Mysql
PHP

