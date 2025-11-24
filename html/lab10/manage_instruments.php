<?php
session_set_cookie_params(60*30);
session_start();

if (isset($_POST['logout'])) {
    session_unset();
    session_destroy();
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}

if (isset($_POST['login_name']) && $_POST['login_name'] !== '') {
    $_SESSION['user_name']     = trim($_POST['login_name']);
    $_SESSION['added_count']   = 0;
    $_SESSION['deleted_count'] = 0;
}

$theme = isset($_COOKIE['theme']) ? $_COOKIE['theme'] : 'light';
if (isset($_POST['set_theme']) && in_array($_POST['set_theme'], ['light','dark'], true)) {
    $theme = $_POST['set_theme'];
    setcookie('theme', $theme, time() + 60*60*24*365*10, '/', '', false, true);
    header("Location: " . $_SERVER['PHP_SELF']);
    exit;
}
$cssFile = ($theme === 'dark') ? 'darkmode.css' : 'basic.css';

require_once __DIR__ . '/../connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['add_instrument'])) {
        $name = trim($_POST['instrument_type'] ?? '');
        if ($name !== '') {
            $stmt = $conn->prepare("INSERT INTO instruments (instrument_type) VALUES (?)");
            $stmt->bind_param("s", $name);
            $stmt->execute();
            if ($stmt->affected_rows === 1) {
                $_SESSION['added_count'] = (int)($_SESSION['added_count'] ?? 0) + 1;
            }
            $stmt->close();
        }
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }

    if (isset($_POST['delete_instrument'])) {
        $id = (int)($_POST['instrument_id'] ?? 0);
        if ($id > 0) {
            $stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id = ?");
            $stmt->bind_param("i", $id);
            $stmt->execute();
            if ($stmt->affected_rows === 1) {
                $_SESSION['deleted_count'] = (int)($_SESSION['deleted_count'] ?? 0) + 1;
            }
            $stmt->close();
        }
        header("Location: " . $_SERVER['PHP_SELF']);
        exit;
    }
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Manage Instruments</title>
  <link rel="stylesheet" href="<?= htmlspecialchars($cssFile) ?>">
</head>
<body>

<h1>Manage Instruments</h1>

<?php if (!isset($_SESSION['user_name'])): ?>
  <form method="post" style="margin-bottom:1rem">
    <label>
      Name:
      <input type="text" name="login_name" required>
    </label>
    <button type="submit">Start Session</button>
  </form>
<?php else: ?>
  <p>Welcome, <strong><?= htmlspecialchars($_SESSION['user_name']) ?></strong>.</p>
  <p>
    Added this session: <strong><?= (int)($_SESSION['added_count'] ?? 0) ?></strong> |
    Deleted this session: <strong><?= (int)($_SESSION['deleted_count'] ?? 0) ?></strong>
  </p>
  <form method="post" style="display:inline">
    <button type="submit" name="logout" value="1">Logout (end session)</button>
  </form>
<?php endif; ?>

<form method="post" style="margin:1rem 0">
  <label>
    View mode:
    <select name="set_theme">
      <option value="light" <?= $theme==='light'?'selected':'' ?>>Light</option>
      <option value="dark"  <?= $theme==='dark'?'selected':''  ?>>Dark</option>
    </select>
  </label>
  <button type="submit">Apply</button>
</form>

<hr>

<form method="post" style="margin:.5rem 0;">
  <input type="text" name="instrument_type" placeholder="New instrument type" required>
  <button type="submit" name="add_instrument" value="1">Add</button>
</form>

<form method="post" style="margin:.5rem 0;">
  <input type="number" name="instrument_id" placeholder="Instrument ID" min="1" required>
  <button type="submit" name="delete_instrument" value="1">Delete</button>
</form>

</body>
</html>
