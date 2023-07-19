<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$possession_id = $_POST['possession_id'];
$possession_name = $_POST['possession_name'];
$possession_desc = $_POST['possession_desc'];
$possession_type = $_POST['possession_type'];
$date_owned = $_POST['date_owned'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];

$cash_checked = $_POST['cash_checked'] == 'true' ? 1 : 0;
$goods_checked = $_POST['goods_checked'] == 'true' ? 1 : 0;
$services_checked = $_POST['services_checked'] == 'true' ? 1 : 0;
$other_checked = $_POST['other_checked'] == 'true' ? 1 : 0;
$publish = $_POST['publish'] == 'true' ? 1 : 0;
$req_id = $_POST['req_id'];


$sqlupdate = "UPDATE `tbl_possessions` SET `possession_name`='$possession_name',`possession_type`='$possession_type',`possession_desc`='$possession_desc',`latitude`='$latitude',`longitude`='$longitude',`state`='$state',`locality`='$locality',`date_owned`='$date_owned',`cash_checked`='$cash_checked',`goods_checked`='$goods_checked',`services_checked`='$services_checked',`other_checked`='$other_checked',`publish`='$publish',`req_id`='$req_id' WHERE `possession_id`='$possession_id'";

if ($conn->query($sqlupdate) === TRUE) {
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