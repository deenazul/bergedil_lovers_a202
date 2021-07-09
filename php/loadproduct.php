<?php
error_reporting(0);
include_once("dbconnect.php");
$prid = $_POST['prid'];


$sqlload = "SELECT * FROM tbl_products ORDER BY datecreated DESC"; 
$result = $conn->query($sqlload);

if ($result->num_rows > 0) {
    $response["products"] = array();
    while ($row = $result ->fetch_assoc()){
        $productlist = array();
        $productlist['prid'] = $row['prid'];
        $productlist['prname'] = $row['prname'];
        $productlist['prprice'] = $row['prprice'];
        $productlist['prqty'] = $row['prqty'];
        $productlist['datecreated'] = $row['datecreated'];
        $productlist['picture'] = 'https://nurulida1.com/272834/bergedillovers/images/productimages/' . $row['picture'];
        array_push($response["products"],$productlist);
    }
    echo json_encode($response);
}else{
    echo "no data";
}
?>