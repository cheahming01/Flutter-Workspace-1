<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['user_id'];
$possession_name = $_POST['possession_name'];
$possession_desc = $_POST['possession_desc'];
$possession_type = $_POST['possession_type'];
$date_owned = $_POST['date_owned'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$images = $_POST['images'];
$trade_option = json_decode($_POST['trade_option']);

$sqlinsert = "INSERT INTO `tbl_possessions`(`user_id`, `possession_name`, `possession_type`, `possession_desc`, `latitude`, `longitude`, `state`, `locality`, `trade_option`, `date_owned`) VALUES ('$userid','$possession_name','$possession_type','$possession_desc','$latitude','$longitude','$state','$locality','$trade_option','$date_owned')";

if ($conn->query($sqlinsert) === TRUE) {
	$foldername = mysqli_insert_id($conn);
	$filename = 1;
	$filename++;
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($images);
	$path = "../assets/possessions/$foldername/".$filename.".png";
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
