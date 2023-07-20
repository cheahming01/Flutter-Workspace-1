<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['user_id'];
$user_name = $_POST['user_name'];
$possession_name = $_POST['possession_name'];
$possession_desc = $_POST['possession_desc'];
$possession_type = $_POST['possession_type'];
$date_owned = $_POST['date_owned'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$images = json_decode($_POST['images']);

$cash_checked = $_POST['cash_checked'] == 'true' ? 1 : 0;
$goods_checked = $_POST['goods_checked'] == 'true' ? 1 : 0;
$services_checked = $_POST['services_checked'] == 'true' ? 1 : 0;
$other_checked = $_POST['other_checked'] == 'true' ? 1 : 0;
$publish = $_POST['publish'] == 'true' ? 1 : 0;
$available = $_POST['available'] == 'true' ? 1 : 0;

$sqlinsert = "INSERT INTO `tbl_possessions`(`user_id`, `user_name`, `possession_name`, `possession_type`, `possession_desc`, `latitude`, `longitude`, `state`, `locality`, `date_owned`, `cash_checked`, `goods_checked`, `services_checked`, `other_checked`, `publish`, `available`) VALUES ('$userid','$user_name','$possession_name','$possession_type','$possession_desc','$latitude','$longitude','$state','$locality','$date_owned','$cash_checked','$goods_checked','$services_checked','$other_checked','$publish','$available')";

if ($conn->query($sqlinsert) === TRUE) {
    $foldername = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);
    $directory = "../assets/possessions/$foldername";
    
    // Create the directory if it doesn't exist
    if (!is_dir($directory)) {
        mkdir($directory, 0777, true);
    }
    
    foreach ($images as $index => $base64Image) {
        $decoded_string = base64_decode($base64Image);
        $filename = $index + 1;
        $path = "$directory/$filename.png";
        file_put_contents($path, $decoded_string);
    }
    
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

