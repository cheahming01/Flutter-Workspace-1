<?php
$servername = "localhost";
$username   = "generati_z3creator";
$password   = "@Database41012195";
$dbname     = "generati_barterit";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>