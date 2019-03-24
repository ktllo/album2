<?php
include_once 'config.php';
include_once 'func.db.php';
if($_SERVER['REQUEST_METHOD']!='POST'){
	header('HTTP/1.1 405 Method Not Allowed');
	header('Allow: POST');
	exit;
}
if(!isset($_POST['username'])||!isset($_POST['password'])){
	header('HTTP/1.1 480 Missing Required Parameter');
	exit;
}
$db = getDBConnection();
$stmt = $db->prepare('SELECT `password` FROM `USERS` WHERE `user_id`=?');
$stmt->bindParam(1,$_POST['username']);
$stmt->execute();
$login_ok = false;
$options = [
    'cost' => 12,
];
if($stmt->rowCount()==0){
	password_hash($_POST['password'], PASSWORD_DEFAULT,$options);
}else{
	$array = $stmt->fetch(PDO::FETCH_NUM);
	if(password_verify($_POST['password'], $array[0])){
		$login_ok = true;
		if(password_needs_rehash($array[0], PASSWORD_DEFAULT,$options)){
			$newHash = password_hash($_POST['password'], PASSWORD_DEFAULT,$options);
			$stmt = $db->prepare('UPDATE `USERS` SET `password`=? WHERE `user_id`=?');
			$stmt->bindParam(1, $newHash);
			$stmt->bindParam(2, $_POST['username']);
			$stmt->execute();
		}
	}else{
		if(password_needs_rehash($array[0], PASSWORD_DEFAULT,$options)){
			password_hash($_POST['password'], PASSWORD_DEFAULT,$options);
		}
	}
}
header('Content-Type: application/json;charset=utf-8');
if($login_ok){
	session_start();
	$_SESSION['username'] = $_POST['username'];
?>{
	"success": true
}
<?php }else{ ?>{
	"success": false
}
<?php }
