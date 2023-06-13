<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions` WHERE user_id = '$userid'";
} elseif (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions` WHERE possession_name LIKE '%$search%'";
} else {
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions`";
}

$result = $conn->query($sqlloadpossessions);
if ($result->num_rows > 0) {
    $possessions = array();
    while ($row = $result->fetch_assoc()) {
        $possessionlist = array();
        $possessionlist['possession_id'] = $row['possession_id'];
        $possessionlist['user_id'] = $row['user_id'];
        $possessionlist['possession_name'] = $row['possession_name'];
        $possessionlist['possession_type'] = $row['possession_type'];
        $possessionlist['possession_desc'] = $row['possession_desc'];
        $possessionlist['latitude'] = $row['latitude'];
        $possessionlist['longitude'] = $row['longitude'];
        $possessionlist['state'] = $row['state'];
        $possessionlist['locality'] = $row['locality'];
        $possessionlist['date_owned'] = $row['date_owned'];
        $possessionlist['cash_checked'] = $row['cash_checked'];
        $possessionlist['goods_checked'] = $row['goods_checked'];
        $possessionlist['services_checked'] = $row['services_checked'];
        $possessionlist['other_checked'] = $row['other_checked'];
        array_push($possessions, $possessionlist);
    }
    $response = array('status' => 'success', 'data' => array('possessions' => $possessions));
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
