<?php
$servername = "localhost";
$username = "";
$password = "";
$dbname = "nurulid1_bergedilloversdb_272834";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}else{
    //echo "success";
}
?>
