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

$cash_checked = $_POST['cash_checked'] == 'true' ? 1 : 0;
$goods_checked = $_POST['goods_checked'] == 'true' ? 1 : 0;
$services_checked = $_POST['services_checked'] == 'true' ? 1 : 0;
$other_checked = $_POST['other_checked'] == 'true' ? 1 : 0;
$publish = $_POST['publish'] == 'true' ? 1 : 0;


$sqlupdate = "UPDATE `tbl_possessions` SET `possession_name`='$possession_name',`possession_type`='$possession_type',`possession_desc`='$possession_desc',`date_owned`='$date_owned',`cash_checked`='$cash_checked',`goods_checked`='$goods_checked',`services_checked`='$services_checked',`other_checked`='$other_checked',`publish`='$publish' WHERE `possession_id`='$possession_id'";


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