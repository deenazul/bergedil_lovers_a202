<?php
error_reporting(0);
include_once("dbconnect.php");
$id_review=$_POST['id_review'];
$newreview=$_POST['newreview'];

echo $sqlupdate = "UPDATE FROM tbl_review SET desc_review = '$newreview' WHERE id_review = '$id_review'";

if ($conn->query($sqlupdate) == true)
{
    echo "success";
}
else{
    echo "failed";
}

?>