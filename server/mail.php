<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/Exception.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/PHPMailer.php';
require '/home8/nurulid1/public_html/phpmailer/PHPMailer/src/SMTP.php';

//Instantiation and passing `true` enables exceptions
$mail = new PHPMailer(true);
echo "Trying to send email";
try {
    //Server settings
    $mail->SMTPDebug = 0;                      //Enable verbose debug output
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'mail.nurulida1.com';                     //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'bergedillovers@nurulida1.com';                     //SMTP username
    $mail->Password   = 'dzWu6EUhZK.5';                               //SMTP password
    $mail->SMTPSecure = 'tls';         //Enable TLS encryption; `PHPMailer::ENCRYPTION_SMTPS` encouraged
    $mail->Port       = 587;                                    //TCP port to connect to, use 465 for `PHPMailer::ENCRYPTION_SMTPS` above

    //Recipients
    $mail->setFrom('bergedillovers@nurulida1.com', 'Mailer');
    $mail->addAddress('irdinazulkeffli@gmail.com', 'Irdina');     //Add a recipient
    
    
    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Account Verification';
    $mail->Body    = "<p>Click the following link to verify your account<br><br><a href='https://nurulida1.com/272834/bergedillovers/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here</a>";
    
    $mail->AltBody = 'This is the body in plain text for non-HTML mail clients';

    $mail->send();
    echo 'Message has been sent';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>