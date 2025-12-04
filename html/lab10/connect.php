<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$dbhost = 'localhost';
$dbuser = 'hunga1509';
$dbpass = '123456';
$dbname = 'instrument_rentals';

$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
if ($conn->connect_errno) {
    http_response_code(500);
    exit('Database connection failed.');
}
$conn->set_charset('utf8mb4');
