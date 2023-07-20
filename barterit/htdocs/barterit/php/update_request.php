<?php
include_once("dbconnect.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $req_id = $_POST['req_id'];
    $status = $_POST['status'];

    // Update request status in tbl_request
    $updateRequestQuery = "UPDATE `tbl_request` SET `status` = '$status' WHERE `req_id` = '$req_id'";
    $updateRequestResult = $conn->query($updateRequestQuery);

    if ($updateRequestResult) {
        if ($status == "Completed") {
            // Update owner and user possessions
            $ownerPossId = $_POST['owner_poss_id'];
            $userPossId = $_POST['user_poss_id'];
            $cashInput = $_POST['cash_input'];

            // Update owner possession available status to false
            $updateOwnerPossessionQuery = "UPDATE `tbl_possessions` SET `available` = false WHERE `possession_id` = '$ownerPossId'";
            $updateOwnerPossessionResult = $conn->query($updateOwnerPossessionQuery);

            // Update user possession available status to false
            $updateUserPossessionQuery = "UPDATE `tbl_possessions` SET `available` = false WHERE `possession_id` = '$userPossId'";
            $updateUserPossessionResult = $conn->query($updateUserPossessionQuery);

            // Update owner's cash by adding the cash input
            $updateOwnerCashQuery = "UPDATE `tbl_users` SET `cash` = `cash` + '$cashInput' WHERE `user_id` = (SELECT `user_id` FROM `tbl_possessions` WHERE `possession_id` = '$ownerPossId')";
            $updateOwnerCashResult = $conn->query($updateOwnerCashQuery);

            // Update user's cash by deducting the cash input
            $updateUserCashQuery = "UPDATE `tbl_users` SET `cash` = `cash` - '$cashInput' WHERE `user_id` = (SELECT `user_id` FROM `tbl_possessions` WHERE `possession_id` = '$userPossId')";
            $updateUserCashResult = $conn->query($updateUserCashQuery);

            if ($updateOwnerPossessionResult && $updateUserPossessionResult && $updateOwnerCashResult && $updateUserCashResult) {
                $response = array('status' => 'success', 'data' => $updateOwnerPossessionResult);
            } else {
                $response = array('status' => 'failed', 'data' => $updateOwnerPossessionResult);
            }
        } else {
            $response = array('status' => 'success', 'data' => $updateUserPossessionQuery);
        }
    } else {
        $response = array('status' => 'failed', 'data' => $updateOwnerCashQuery);
    }
} else {
    $response = array('status' => 'failed', 'data' => $updateUserCashQuery);
}

header('Content-Type: application/json');
echo json_encode($response);
?>
