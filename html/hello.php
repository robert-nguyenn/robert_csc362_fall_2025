<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><title>Form Demo</title></head>
<body>
  <h1>Form Demo</h1>
  <form action="action.php" method="post">
    <label for="name">Your name:</label>
    <input name="name" id="name" type="text" required>

    <label for="age">Your age:</label>
    <input name="age" id="age" type="number" required>

    <button type="submit">Submit</button>
  </form>
  <p><a href="index.php">Back to index</a></p>
</body>
</html>
