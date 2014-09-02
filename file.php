#!/usr/bin/php 
 
<?php 


class fileWirte
{ 
	function __construct() 
	{
		$str=file_get_contents("/var/studio/demo.conf");//打开文件
$str=str_replace("sd","替换成的内容",$str);
file_put_contents("demo.conf",$str);//把替换的内容写到.php文		
		
	}



}

$fileTest = new fileWirte(); 
?>	