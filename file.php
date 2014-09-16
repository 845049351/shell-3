#!/usr/bin/php 
 
<?php 


class fileWirte
{ 
	function __construct() 
	{
		$this->setfolder();
		$this->setSalt();
		exit();

		$str=file_get_contents("/var/studio/demo.conf");//打开文件
		$str=str_replace("sd","替换成的内容",$str);
		file_put_contents("demo.conf",$str);//把替换的内容写到.php文		
		
	}

	function setSalt()
	{
		$serialNum =  $_SERVER["argv"][1];
		system("echo $serialNum >/var/studio/tmp/saltId.txt");


	}


	function setZabbix()
	{
		$zabbixHostname = $_SERVER["argv"][2];
		system("command");
	}

	function setfolder()
	{
		system("sudo chown www-data:www-data /var/www/edusoho -Rf");
	}
}

$fileTest = new fileWirte(); 
?>	