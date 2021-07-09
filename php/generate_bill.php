<?php
error_reporting(0);
//include_once("dbconnect.php");

$email = $_GET['email']; //email
$mobile = $_GET['mobile']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 

$api_key = '991f6e0f-eba2-44b2-a857-59c91339b8de';
$collection_id = '5snrrsgb';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email, //'irdinazulkeffli@gmail.com',
          'mobile' => $mobile, //'0174690849',
          'name' => $name, //'irdina',
          'amount' => $amount * 100 , //'13' * 100,
		  'description' => 'Payment for order: ',
          'callback_url' => "http://nurulida1.com/272834/bergedillovers/php/return_url",
          'redirect_url' => "http://nurulida1.com/272834/bergedillovers/php/payment_update.php?userid=$email&mobile=$mobile&amount=$amount" 
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

echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>