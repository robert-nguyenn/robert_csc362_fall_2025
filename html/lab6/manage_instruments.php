<?php
// -----------------------
// Lab 6 – manage_instruments.php
// -----------------------

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$dbhost = 'localhost';
$dbuser = 'hunga1509';  
$dbpass = '123456';     
$dbname = 'instrument_rentals';

$sql_dir = __DIR__ . '/';

$conn = new mysqli($dbhost, $dbuser, $dbpass, $dbname);

function h($s) { return htmlspecialchars((string)$s, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'); }

function result_to_html_table(mysqli_result $result) : void {
    $rows   = $result->fetch_all(MYSQLI_NUM);
    $nCols  = $result->field_count;
    $fields = $result->fetch_fields();
    ?>
    <form method="POST">
      <table border="1" cellpadding="4" cellspacing="0">
        <thead>
          <tr>
            <td><b>Delete?</b></td>
            <?php for ($c = 0; $c < $nCols; $c++): ?>
              <td><b><?php echo h($fields[$c]->name); ?></b></td>
            <?php endfor; ?>
          </tr>
        </thead>
        <tbody>
        <?php foreach ($rows as $r): ?>
          <?php
            $id = (int)$r[0];
            $isRented = isset($r[2]) && $r[2] !== '' && $r[2] !== null;
          ?>
          <tr>
            <td>
              <input
                type="checkbox"
                name="<?php echo 'checkbox' . $id; ?>"
                value="<?php echo $id; ?>"
                <?php echo $isRented ? 'disabled="disabled"' : ''; ?>
              />
            </td>
            <?php for ($c = 0; $c < $nCols; $c++): ?>
              <td><?php echo h($r[$c]); ?></td>
            <?php endfor; ?>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
      <p><input type="submit" name="delbtn" value="Delete Selected Records" /></p>
    </form>
    <?php
}


if (array_key_exists('add_records', $_POST)) {
    $insert_sql = file_get_contents($sql_dir . 'add_instruments.sql');
    $conn->query($insert_sql);

    // PRG: redirect to GET after changing data
    header('Location: ' . $_SERVER['REQUEST_URI'], true, 303);
    exit();
}

// Delete selected (prepared statement)
if (array_key_exists('delbtn', $_POST)) {
    $del_sql = trim(file_get_contents($sql_dir . 'delete_instruments.sql')); //
    $stmt = $conn->prepare($del_sql);
    $stmt->bind_param('i', $id);

    foreach ($_POST as $key => $val) {
        if (strncmp($key, 'checkbox', 8) === 0) {
            $id = (int)$val;    
            $stmt->execute();
        }
    }
    $stmt->close();

    header('Location: ' . $_SERVER['REQUEST_URI'], true, 303);
    exit();
}

// ------------- Page (GET) -------------
?>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Manage Instruments</title>
</head>
<body>
  <h1>Instrument Rentals: Manage Instruments</h1>

  <form method="POST">
    <input type="submit" name="add_records" value="Add extra records" />
  </form>

  <h2>Current Instruments</h2>
  <?php
    $select_sql = file_get_contents($sql_dir . 'select_instruments.sql');
    $result = $conn->query($select_sql);
    result_to_html_table($result);
    $result->free();
    $conn->close();
  ?>
</body>
</html>
