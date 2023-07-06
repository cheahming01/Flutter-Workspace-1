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
$cash_checked = $_POST['cash_checked'] == 'true' ? 1 : 0;
$goods_checked = $_POST['goods_checked'] == 'true' ? 1 : 0;
$services_checked = $_POST['services_checked'] == 'true' ? 1 : 0;
$other_checked = $_POST['other_checked'] == 'true' ? 1 : 0;

$sqlinsert = "INSERT INTO `tbl_possessions`(`user_id`, `possession_name`, `possession_type`, `possession_desc`, `latitude`, `longitude`, `state`, `locality`, `date_owned`, `cash_checked`, `goods_checked`, `services_checked`, `other_checked`) VALUES ('$userid','$possession_name','$possession_type','$possession_desc','$latitude','$longitude','$state','$locality','$date_owned','$cash_checked','$goods_checked','$services_checked','$other_checked')";


echo "SQL Query: " . $sqlinsert . PHP_EOL;

if ($conn->query($sqlinsert) === TRUE) {
	$foldername = mysqli_insert_id($conn);
	$filename = 1;
	$filename++;
	$response = array('status' => 'success', 'data' => null);
	$decoded_string = base64_decode($images);
	$directory = "../assets/possessions/$foldername";
	// Create the directory if it doesn't exist
    	if (!is_dir($directory)) {
        	mkdir($directory, 0777, true);
    	}
    
    	$path = "$directory/$filename.png";
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
