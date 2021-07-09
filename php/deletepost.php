<?php
error_reporting(0);
include_once("dbconnect.php");
$id_review=$_POST['id_review'];
$sqldelete = "DELETE FROM tbl_review WHERE id_review = '$id_review'";

if ($conn->query($sqldelete) == true)
{
    echo "success";
}
else{
    echo "failed";
}

?>