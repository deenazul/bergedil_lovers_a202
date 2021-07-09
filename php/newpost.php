<?php
include_once("dbconnect.php");
$desc_review = $_POST['desc_review'];
$id_review = $_POST['id_review'];
$encoded_string = $_POST["encoded_string"];
$img_review = uniqid() . '.png';


    $sqlfeed = "INSERT INTO tbl_review(id_review,img_review,desc_review) VALUES('$id_review','$img_review','$desc_review')";
    if ($conn->query($sqlfeed) === TRUE){
        $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/feedimages/'. $img_review;
        $is_written = file_put_contents($path, $decoded_string);
        echo "success";
    }else{
        echo "failed";
    }
?>
