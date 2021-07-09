<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlloadcart= "SELECT * FROM tbl_cart INNER JOIN tbl_products ON tbl_cart.prid = tbl_products.prid WHERE tbl_cart.email = 'irdinazulkeffli@gmail.com'";

$result = $conn->query($sqlloadcart);
if ($result->num_rows > 0) {
    $response["cart"] = array();
    while ($row = $result ->fetch_assoc()){
        $productlist = array();
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['prqty'] = $row['prqty'];
        $productlist['cart_qty'] = $row['cart_qty'];
       $productlist['picture'] = 'https://nurulida1.com/272834/bergedillovers/images/productimages/' . $row['picture'];
        array_push($response["cart"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "failed";
}
?>