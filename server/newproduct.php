<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];
$prprice = $_POST['prprice'];
$prqty = $_POST['prqty'];
$prid = $_POST['prid'];
$encoded_string = $_POST["encoded_string"];
$picture = uniqid() . '.png';


    $sqlregister = "INSERT INTO tbl_products(prid,prname,prprice,prqty, picture) VALUES('$prid','$prname','$prprice','$prqty','$picture')";
    if ($conn->query($sqlregister) === TRUE){
        $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/productimages/'. $picture;
        $is_written = file_put_contents($path, $decoded_string);
        echo "success";
    }else{
        echo "failed";
    }


?>