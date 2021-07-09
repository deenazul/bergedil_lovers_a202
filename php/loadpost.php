<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];


$sqlload = "SELECT * FROM tbl_review ORDER BY dateposted DESC"; 
$result = $conn->query($sqlload);

if ($result->num_rows > 0) {
    $response["review"] = array();
    while ($row = $result ->fetch_assoc()){
         $feedlist = array();
         $feedlist['id_review'] = $row['id_review'];
         $feedlist['desc_review'] = $row['desc_review'];
         $feedlist['dateposted'] = $row['dateposted'];
         $feedlist['img_review'] = 'https://nurulida1.com/272834/bergedillovers/images/feedimages/' . $row['img_review'];
        array_push($response["review"], $feedlist);
    }
    echo json_encode($response);
}else{
    echo "no data";
}
?>