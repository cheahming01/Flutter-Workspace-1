<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


$userId = $_POST['userId'];
$cashInput = $_POST['cashInput'];
$ownerPossId = $_POST['ownerPossId'];
$userPossId = $_POST['userPossId'];
$status = $_POST['status'];


// Insert data into tbl_request
$sqlinsert = "INSERT INTO `tbl_request`(`user_id`, `cash_input`, `owner_poss_id`,`user_poss_id`,`status`) VALUES ('$userId','$cashInput','$ownerPossId','$userPossId','$status')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlinsert);
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
