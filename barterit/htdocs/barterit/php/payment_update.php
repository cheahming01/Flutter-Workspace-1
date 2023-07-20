<?php
include_once("dbconnect.php");

$userid = $_GET['userid'];
$amount = $_GET['amount'];

$data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
$paidstatus = $paidstatus === "true" ? "Success" : "Failed";
$receiptid = $_GET['billplz']['id'];

$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$signed = hash_hmac('sha256', $signing, 'S-exU2TiFakg4zuQZm5wc-Uw');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success") { // Payment success
        // Update tbl_user.cash
        $sqlUpdateCash = "UPDATE `tbl_users` SET `cash` = `cash` + $amount WHERE `user_id` = '$userid'";
        if ($conn->query($sqlUpdateCash) === TRUE) {
            echo "Payment successful. Your account has been topped up with RM $amount.";
        } else {
            echo "Error updating cash: " . $conn->error;
        }
    } else {
        echo "Payment failed. Please try again.";
    }
}
?>
