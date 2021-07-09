<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];
$cart_qty = $_POST['cart_qty'];

$sqlcheck = "SELECT * FROM tbl_cart WHERE prid = '$prid' AND email = '$email'";
$resultcheck = $conn->query($sqlcheck);

if ($resultcheck->num_rows == 0) 
    {
    $sqladdcart = "INSERT INTO tbl_cart (email, prid, cart_qty) VALUES 
    ('$email','$prid','1')";
     if ($conn->query($sqladdcart) === TRUE) 
        {echo "success";
        }
     else 
        {echo "failed";
        }
    }
else
    {
        $sqlupdatecart = "UPDATE tbl_cart SET cart_qty= cart_qty+1 WHERE prid = '$prid' AND email = '$email'";
     if ($conn->query($sqlupdatecart) === TRUE) 
        {echo "success";
        }
     else 
        {echo "failed";
        }
    }
?>
