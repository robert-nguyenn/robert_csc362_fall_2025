<?php
// ---- Errors on (for dev) ----
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Databases Available</title>
</head>
<body>
  <h1>Databases Available</h1>

<?php
  // ---- Credentials ----
  $dbhost = 'localhost';
  $dbuser = 'hunga1509';
  $dbpass = '123456';

  $conn = new mysqli($dbhost, $dbuser, $dbpass);

  if ($conn->connect_errno) {
      echo "Error: Failed to make a MySQL connection, here is why:<br>";
      echo "Errno: " . $conn->connect_errno . "<br>";
      echo "Error: " . $conn->connect_error . "<br>";
      exit;
  } else {
      echo "Connected Successfully!<br>";
      echo "YAY!<br><br>";
  }

  $dblist = "SHOW DATABASES";
  $result = $conn->query($dblist);

  echo "<ul>";
  while ($row = $result->fetch_array()) {
      echo "<li>" . htmlspecialchars($row['Database']) . "</li>";
  }
  echo "</ul>";

  $conn->close();
?>

  <h2>Check back soon!</h2>

  <hr>
  <h2>See tables in a database</h2>
  <form action="details.php" method="get">
    <label for="dbname">Database name:</label>
    <input id="dbname" name="dbname" type="text" required>
    <button type="submit">Show tables</button>
  </form>
</body>
</html>
