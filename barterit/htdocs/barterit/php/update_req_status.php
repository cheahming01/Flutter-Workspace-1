<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

// Retrieve the request ID and status from the POST request
$reqId = $_POST['reqid'];
$status = $_POST['status'];

// Update the status in the database
$sqlupdate = "UPDATE `tbl_request` SET `status` = '$status' WHERE `req_id` = '$reqId'";


if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlupdate);
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