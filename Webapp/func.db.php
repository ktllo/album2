<?php
include_once 'config.php';

function getDBConnection(){
	$db =  new PDO('mysql:host='.DB_PATH.';dbname='.DB_NAME, DB_USER, DB_PASS);
	$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
	$db->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );
	return $db;
}
