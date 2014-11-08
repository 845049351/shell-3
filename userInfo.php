<?php
header("content-Type: text/html; charset=Utf-8");
/**
* 
*/
class userInfo
{
	
	function __construct()
	{
		$this->addInfo();
	}

	private function addInfo()
	{
		// $username = htmlspecialchars(trim($_POST['username']));
		$password = htmlspecialchars(trim($_POST['password']));
		$email = htmlspecialchars(trim($_POST['email']));
		$customerClass = htmlspecialchars(trim($_POST['customerClass']));
		$ip = htmlspecialchars(trim($_POST['ip']));
		$customerNumber = htmlspecialchars(trim($_POST['customerNumber']));
		$addtime =time();
		$customerManager=htmlspecialchars(trim($_POST['customerManager']));
		$city = htmlspecialchars(trim($_POST['city']));
		$suppliers=htmlspecialchars(trim($_POST['suppliers']));
		$domain=htmlspecialchars(trim($_POST['domain']));
		$esDomain=htmlspecialchars(trim($_POST['esDomain']));
		$other=htmlspecialchars(trim($_POST['other']));
		$live = htmlspecialchars(trim($_POST['live']));

		if ($password&&$ip&&$customerNumber&&$customerManager&&$city&&$suppliers) {

			if (empty($this->isInfo($customerNumber,$ip))) {

				$rs =  $this->dbh() ->query( "INSERT INTO server(Passwd,Hostname, Saltname, Ip,Addtime,CustomerNumber,CustomerManager,City,Suppliers,Domain,esDomain) 
				VALUES ('$password','$customerNumber', '$customerNumber', '$ip',$addtime, '$customerNumber', 
				'$customerManager','$city','$suppliers','$domain','$esDomain');");

				$str = array
				       (
				          'Auth'=>'admin',
				          'CustomerNumber'=>$customerNumber,
				          'Addtime'=>$addtime ,
				          'City'=>$city,
				          'Suppliers'=>$suppliers,
				          'Domain'=>$domain,
				          'esDomain'=>$esDomain,
				       );

				$url = "http://www.topxia.com/infoServer.php";
				$ch = curl_init ();
				curl_setopt ( $ch, CURLOPT_URL, $url );
				curl_setopt ( $ch, CURLOPT_POST, 1 );
				curl_setopt ( $ch, CURLOPT_HEADER, 0 );
				curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, 1 );
				curl_setopt ( $ch, CURLOPT_POSTFIELDS, $str );
				$return = curl_exec ( $ch );
				curl_close ( $ch );
				$addCustomerNumber = base64_encode($customerNumber);
				$addOther = base64_encode($other);
				$addCustomerClass = base64_encode($customerClass);
				$addEmail = base64_encode($email);
				$addIp = base64_encode($ip);
				$addDomain = base64_encode($domain);
				$addEsDomian = base64_encode($esDomain);
				$addCustomerManager = base64_encode($customerManager);
				$addLive = base64_encode($live);
				echo('执行完成，辛苦了！！！');
				header("Refresh: 2;url=repairorder.php?customerNumber=$addCustomerNumber&&other=$addOther&&customerClass=$addCustomerClass&&email=$addEmail&&ip=$addIp&&domain=$addDomain&&esDomain=$addEsDomian&&customerManager=$addCustomerManager&&live=$addLive");

			}else{

				echo('客户编号和客户称谓已经存在');
				header("Refresh: 1;url=index.html");
			}

		}else{
			echo('亲，将信息填写完整再提交哦');
			header("Refresh: 1;url=index.html");
		}
	}

	private function isInfo($customerNumber,$ip)
	{

		$rs =  $this->dbh() ->query("SELECT ID FROM server where CustomerNumber='$customerNumber' AND Ip='$ip';");
		return $rs->fetch();
	}

	private function dbh()
	{

		try {

		        $dbh = new PDO('mysql:host=localhost;port=3306;dbname=es-backup', 'root', 'root', array( PDO::ATTR_PERSISTENT => "set names utf8"));
			   
		    } catch (PDOException $e) {
		       
		        print $e->getMessage() ;
		        die();
		    }

		return $dbh;
	}
}

$run = new userInfo();
?>