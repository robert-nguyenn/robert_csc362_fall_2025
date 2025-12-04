<?php
session_set_cookie_params(60 * 30);
session_start();

if (isset($_POST['logout'])) {
    session_unset();
    session_destroy();
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}

if (isset($_POST['login_name']) && $_POST['login_name'] !== '') {
    $_SESSION['user_name'] = trim($_POST['login_name']);
    $_SESSION['added_count'] = 0;
    $_SESSION['deleted_count'] = 0;
}

$theme = 'light';
if (isset($_COOKIE['theme'])) {
    $theme = $_COOKIE['theme'];
}


if (isset($_POST['set_theme'])) {
    if ($_POST['set_theme'] == 'light' || $_POST['set_theme'] == 'dark') {
        $theme = $_POST['set_theme'];
        setcookie('theme', $theme, time() + 60*60*24*365*10, '/', '', false, true);
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}

if ($theme == 'dark') {
    $cssFile = 'darkmode.css';
} else {
    $cssFile = 'basic.css';
}

require_once __DIR__ . '/connect.php';

if (isset($_SERVER['REQUEST_METHOD']) && $_SERVER['REQUEST_METHOD'] == 'POST') {

    if (isset($_POST['add_instrument'])) {
        $instrument_type = trim($_POST['instrument_type']);
        if ($instrument_type != '') {
            $stmt = $conn->prepare("INSERT INTO instruments (instrument_type) VALUES (?)");
            $stmt->bind_param("s", $instrument_type);
            $stmt->execute();

            if ($stmt->affected_rows == 1) {
                if (!isset($_SESSION['added_count'])) {
                    $_SESSION['added_count'] = 0;
                }
                $_SESSION['added_count']++;
            }
            $stmt->close();
        }
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }

    if (isset($_POST['delete_instrument'])) {
        $instrument_id = (int)$_POST['instrument_id'];
        if ($instrument_id > 0) {
            $stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id = ?");
            $stmt->bind_param("i", $instrument_id);
            $stmt->execute();


            if ($stmt->affected_rows == 1) {
                if (!isset($_SESSION['deleted_count'])) {
                    $_SESSION['deleted_count'] = 0;
                }
                $_SESSION['deleted_count']++;
            }
            $stmt->close();
        }

        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}


$instruments = [];
$result = $conn->query("SELECT instrument_id, instrument_type FROM instruments ORDER BY instrument_id ASC");
if ($result) {
    while ($row = $result->fetch_assoc()) {
        $instruments[] = $row;
    }
    $result->free();
}

$conn->close();
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Manage Instruments</title>
  <link rel="stylesheet" href="<?php echo htmlspecialchars($cssFile); ?>">
</head>
<body>

<h1>Manage Instruments</h1>

<?php if (!isset($_SESSION['user_name'])): ?>
  <!-- Start session -->
  <form method="post" style="margin-bottom:1rem">
    <label>Name:
      <input type="text" name="login_name" required>
    </label>
    <button type="submit">Start Session</button>
  </form>
<?php else: ?>
  <!-- Logged-in area -->
  <p>Welcome, <strong><?php echo htmlspecialchars($_SESSION['user_name']); ?></strong>.</p>
  <p>
    Added this session: <strong><?php echo isset($_SESSION['added_count']) ? $_SESSION['added_count'] : 0; ?></strong> |
    Deleted this session: <strong><?php echo isset($_SESSION['deleted_count']) ? $_SESSION['deleted_count'] : 0; ?></strong>
  </p>
  <form method="post" style="display:inline">
    <button type="submit" name="logout" value="1">Logout (end session)</button>
  </form>
<?php endif; ?>

<!-- Theme toggle (cookie persists) -->
<form method="post" style="margin:1rem 0">
  <label>View mode:
    <select name="set_theme">
      <option value="light" <?php if($theme == 'light') echo 'selected'; ?>>Light</option>
      <option value="dark" <?php if($theme == 'dark') echo 'selected'; ?>>Dark</option>
    </select>
  </label>
  <button type="submit">Apply</button>
</form>

<hr>

<!-- Add -->
<form method="post" style="margin:.5rem 0;">
  <input type="text" name="instrument_type" placeholder="New instrument type" required>
  <button type="submit" name="add_instrument" value="1">Add</button>
</form>

<!-- Delete -->
<form method="post" style="margin:.5rem 0;">
  <input type="number" name="instrument_id" placeholder="Instrument ID" min="1" required>
  <button type="submit" name="delete_instrument" value="1">Delete</button>
</form>


<?php if (count($instruments) > 0): ?>
  <h3>Current Instruments</h3>
  <table>
    <thead>
      <tr><th>ID</th><th>Type</th></tr>
    </thead>
    <tbody>
    <?php foreach ($instruments as $instrument): ?>
      <tr>
        <td><?php echo (int)$instrument['instrument_id']; ?></td>
        <td><?php echo htmlspecialchars($instrument['instrument_type']); ?></td>
      </tr>
    <?php endforeach; ?>
    </tbody>
  </table>
<?php endif; ?>

</body>
</html>
