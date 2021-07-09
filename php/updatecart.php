<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];
$cart_qty = $_POST['cart_qty'];
$op = $_POST['op'];

//$sqlupdate = "UPDATE tbl_cart SET cart_qty = '$cart_qty' WHERE email = '$email' AND prid = '$prid'";

if ($op == "addcart")
    {$sqlupdate = "UPDATE tbl_cart SET cart_qty = cart_qty+1 WHERE prid = '$prid' AND email = '$email'";
    if ($conn->query($sqlupdate) === TRUE) 
        {echo "success";
        }
    else
        {echo "failed";
        }
    }
    
if ($op == "removecart") 
    {if ($cart_qty == 1) 
        {echo "failed";
        } 
     else 
        {$sqlupdate = "UPDATE tbl_cart SET cart_qty = cart_qty-1 WHERE prid = '$prid' AND email = '$email'";
        if ($conn->query($sqlupdate) === TRUE)
            {echo "success";
            } 
        else
            {echo "failed";
            }
        }
    }
$conn->close();
?>