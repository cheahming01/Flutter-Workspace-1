<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$name = $_POST['name'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$otp = rand(10000,99999);
$cash = 0;

$sqlinsert = "INSERT INTO `tbl_users`(`user_name`, `user_password`, `user_phone`,`otp`,`cash`) VALUES ('$name','$password','$phone','$otp','$cash')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>