<?php
// errors on while developing
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

// helper: print a bulleted list from a mysqli_result
function print_bullets($result) {
    echo "<ul>";
    // SHOW TABLES returns one column; use numeric index 0
    while ($row = $result->fetch_row()) {
        echo "<li>" . htmlspecialchars($row[0]) . "</li>";
    }
    echo "</ul>";
}

$dbname = trim($_GET['dbname'] ?? '');
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Tables in <?php echo htmlspecialchars($dbname); ?></title>
</head>
<body>
  <h1>Tables in: <?php echo htmlspecialchars($dbname); ?></h1>
<?php
if ($dbname === '') {
    echo "<p>No database provided.</p>";
} else {
    // connect (same creds as connect.php)
    // ---- Credentials ----
    $dbhost = 'localhost';
    $dbuser = 'hunga1509';
    $dbpass = '123456';

    $conn = new mysqli($dbhost, $dbuser, $dbpass);

    if ($conn->connect_errno) {
        echo "Error: Failed to connect<br>";
        echo "Errno: " . $conn->connect_errno . "<br>";
        echo "Error: " . $conn->connect_error . "<br>";
        exit;
    }

    if (!preg_match('/^\w+$/', $dbname)) {
        echo "<p>Invalid database name.</p>";
    } else {
        $result = $conn->query("SHOW TABLES FROM `$dbname`");
        print_bullets($result);
        $result->free();
    }

    $conn->close();
}
?>
  <p><a href="connect.php">Back</a></p>
</body>
</html>
