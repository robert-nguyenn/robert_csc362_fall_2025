<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Form Result</title></head>
<body>
  <h1>Result</h1>
  <p>Hi <?php echo htmlspecialchars($_POST['name'] ?? ''); ?>.</p>
  <p>You are <?php echo (int)($_POST['age'] ?? 0); ?> years old.</p>
  <p><a href="hello.php">Back</a> | <a href="index.php">Home</a></p>
</body>
</html>
