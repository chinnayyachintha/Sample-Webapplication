const express = require('express');
const app = express();
const port = 3000;

app.get('/api', (req, res) => {
  res.send({ message: 'Hello from the backend!' });
});

app.listen(port, () => {
  console.log(`Backend is running at http://localhost:${port}`);
});
