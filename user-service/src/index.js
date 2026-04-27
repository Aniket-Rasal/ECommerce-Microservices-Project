const express = require('express');
const app = express();

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'user-service' });
});

app.get('/users', (req, res) => {
  res.json([{ id: 1, name: 'Test User', email: 'test@example.com' }]);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`User service running on ${PORT}`));
