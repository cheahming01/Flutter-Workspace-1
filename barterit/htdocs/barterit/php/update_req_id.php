<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}


if (isset($_POST['req_id'])) {
    $req_id = $_POST['req_id'];
    $possession_id = $_POST['possessionId'];
    $sqlupdate = "UPDATE tbl_possessions SET `req_id` ='$req_id' WHERE `possession_id` = '$possession_id'";
    databaseUpdate($sqlupdate);
    die();
}


function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => $sql);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => $sql);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>