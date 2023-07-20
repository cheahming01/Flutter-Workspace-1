<?php
error_reporting(0);

$phone = $_GET['phone']; 
$name = $_GET['name']; 
$userid = $_GET['userid'];
$amount = $_GET['amount']; 


$api_key = '7bacbdb7-f8bc-4aa5-8a04-f219a4b80c6f';
$collection_id = '8gtqgd8z';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

$data = array(
          'collection_id' => $collection_id,
          'mobile' => $phone,
          'name' => $name,
          'amount' => ($amount) * 100, // RM20
      'description' => 'Payment for order by '.$name,
          'callback_url' => "https://generationz3.com/barterit/return_url",
          'redirect_url' => "https://generationz3.com/barterit/php/payment_update.php?userid=$userid&phone=$phone&amount=$amount&name=$name" 
);

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);
header("Location: {$bill['url']}");
?>