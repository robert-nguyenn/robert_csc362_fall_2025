<!DOCTYPE html>
<html>
  <head><title>PHP Test</title></head>
  <body>
    <?php echo '<p>Hello World</p>'; ?>

    <?php
      // show the user agent and a simple check (use strpos for max compatibility)
      $ua = $_SERVER['HTTP_USER_AGENT'] ?? '';
      echo '<p><strong>User agent:</strong> ' . htmlspecialchars($ua) . '</p>';

      if (strpos($ua, 'Firefox') !== false) {
        echo '<p>You are using Firefox.</p>';
      } else {
        echo '<p>You are not using Firefox.</p>';
      }
    ?>

    <p><a href="hello.php">Form demo</a></p>
  </body>
</html>
