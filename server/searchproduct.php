<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];

    $sqlsearchproducts= "SELECT * FROM tbl_products WHERE prname LIKE '%$prname%'";
    $result = $conn->query($sqlsearchproducts);

if ($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $_searchList = array();
        $_searchList['prid'] = $row['prid'];
        $_searchList['prname'] = $row['prname'];
        $_searchList['prqty'] = $row['prqty'];
        $_searchList['prprice'] = $row['prprice'];
        $_searchList['datecreated'] = $row['datecreated'];
        $_searchList['picture'] = 'https://nurulida1.com/272834/bergedillovers/images/productimages/' . $row['picture'];
        array_push($response["products"],$_searchList);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>