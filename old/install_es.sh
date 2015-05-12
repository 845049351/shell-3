#!/usr/bin/php 
 
<?php 


class install 
{ 
     
     	function __construct() 
    	{ 
        		# code 
    	} 
 
	function masterRun() 
	{ 
	 
	        $cmdstr="iptables -L";           //$cmdstr可赋值为想执行的命令字符串 
	 
	        system("$cmdstr");   //调用cmd, 执行命令 
	} 
} 
 
?>