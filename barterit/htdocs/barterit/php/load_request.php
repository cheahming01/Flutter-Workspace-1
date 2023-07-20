<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqlreq = "SELECT tbl_request.req_id, tbl_request.user_id AS request_user_id, tbl_request.owner_poss_id, tbl_request.cash_input, tbl_request.user_poss_id, tbl_request.time_req, tbl_request.notification, tbl_request.status, owner_possession.possession_name AS owner_poss_name, user_possession.possession_name AS user_poss_name, owner_possession.available AS owner_poss_available, user_possession.available AS user_poss_available, owner_possession.user_id AS ownerid, owner_possession.user_name AS owner_username, user_possession.user_name AS user_username
               FROM `tbl_request`
               INNER JOIN `tbl_possessions` AS owner_possession ON tbl_request.owner_poss_id = owner_possession.possession_id
               INNER JOIN `tbl_possessions` AS user_possession ON tbl_request.user_poss_id = user_possession.possession_id
               WHERE owner_possession.user_id = '$userid' OR tbl_request.user_id = '$userid'";
}

$result = $conn->query($sqlreq);

$reqitems = array(); // Initialize the variable as an empty array

if ($result->num_rows > 0) {
    $reqitems["request"] = array();
    while ($row = $result->fetch_assoc()) {
        $reqlist = array();
        $reqlist['req_id'] = $row['req_id'];
        $reqlist['request_user_id'] = $row['request_user_id'];
        $reqlist['owner_poss_id'] = $row['owner_poss_id'];
        $reqlist['cash_input'] = $row['cash_input'];
        $reqlist['user_poss_id'] = $row['user_poss_id'];
        $reqlist['time_req'] = $row['time_req'];
        $reqlist['notification'] = $row['notification'];
        $reqlist['status'] = $row['status'];
        $reqlist['owner_poss_name'] = $row['owner_poss_name'];
        $reqlist['user_poss_name'] = $row['user_poss_name'];
        $reqlist['owner_poss_available'] =  (bool)$row['owner_poss_available'];
        $reqlist['user_poss_available'] =  (bool)$row['user_poss_available'];
        $reqlist['ownerid'] = $row['ownerid'];
        $reqlist['owner_username'] = $row['owner_username'];
        $reqlist['user_username'] = $row['user_username'];

        array_push($reqitems["request"], $reqlist);
    }
    $response = array('status' => 'success', 'data' => $reqitems);
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
