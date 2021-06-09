<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/Exception.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/PHPMailer.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/SMTP.php';

include_once ("dbconnect.php");

$email = $_POST['email'];
$newpass = random_password(10);
$passha2 = sha1($newpass);
$newotp = rand(1000,9999);

$sql = "SELECT * FROM tbl_user WHERE email ='$email' AND otp='0'";
    $result = $conn->query($sql);
if ($result->num_rows > 0){
    $sqlupdate = "UPDATE tbl_user SET otp = '$newotp' , password = '$passha2' WHERE email = '$email'";
        if ($conn->query($sqlupdate) === true){
            random_password($length);
            sendEmail($newotp, $newpass, $email);
            echo "success";
            }
            else{
                echo "failed";
            }
} else {
    echo "failed";
}

function sendEmail($newotp,$newpass,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.nurulida1.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'bergedillovers@nurulida1.com';                  //SMTP username
    $mail->Password   = 'dzWu6EUhZK.5';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "bergedillovers@nurulida1.com";
    $to = $email;
    $subject = "From Bergedil Lovers. Reset your account.";
    $message = "<p>Account has been reset. Login with the new password below.</p><br><br><h3>Password:".$newpass."</h3><br><br><a href='https://nurulida1.com/272834/bergedillovers/php/verify_account.php?email=".$email."&key=".$newotp."'>Click here to activate account.</a>";
    
    $mail->setFrom($from,"Bergedil Lovers");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}

function random_password($length){
    $characters= '01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $password = '';
    $characterListLength = mb_strlen($characters, '8bit') - 1;
    //loop from 1-$length that was specified
    foreach(range(1, $length) as $i){
        $password .= $characters[rand(0, $characterListLength)];
    }
    return $password;
}

?>