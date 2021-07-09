<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];
    $sqldelete = "DELETE FROM tbl_cart WHERE EMAIL = 'irdinazulkeffli@gmail.com' AND PRID='$prid'";
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>