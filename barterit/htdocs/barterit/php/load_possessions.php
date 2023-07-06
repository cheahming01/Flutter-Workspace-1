<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$results_per_page = 5;
if (isset($_POST['pageno'])){
	$pageno = (int)$_POST['pageno'];
}else{
	$pageno = 1;
}
$page_first_result = ($pageno - 1) * $results_per_page;


//profile
if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions` WHERE user_id = '$userid'";
    if (isset($_POST['publish']) && $_POST['publish'] == 'true') {
        $sqlloadpossessions .= " AND publish = 1";
    } elseif (isset($_POST['publish']) && $_POST['publish'] == 'false') {
        $sqlloadpossessions .= " AND publish = 0";
    }
} 

//search
elseif (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions` WHERE possession_name LIKE '%$search%'";
    if (isset($_POST['publish']) && $_POST['publish'] == 'true') {
        $sqlloadpossessions .= " AND publish = 1";
    }
} 

//buyertabscreen
else {
    $sqlloadpossessions = "SELECT * FROM `tbl_possessions`";
    if (isset($_POST['publish']) && $_POST['publish'] == 'true') {
        $sqlloadpossessions .= " WHERE publish = 1";
    }
}

$result = $conn->query($sqlloadpossessions);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadpossessions = $sqlloadpossessions . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadpossessions);

if ($result->num_rows > 0) {
    $possessions["possessions"] = array();
    while ($row = $result->fetch_assoc()) {
        $possessionlist = array();
        $possessionlist['possession_id'] = $row['possession_id'];
        $possessionlist['user_id'] = $row['user_id'];
	$possessionlist['user_name'] = $row['user_name'];
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
	$possessionlist['publish'] = $row['publish'];
        array_push($possessions["possessions"], $possessionlist);
    }
    $response = array('status' => 'success', 'data' => $possessions, 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result");
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
