const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello, World!');
});

app.listen(port, () => {
    console.log(`Server is running at http://localhost:${port}`);
});
// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Set up a simple API endpoint
app.get('/api/data', (req, res) => {
    res.json({ message: 'Hello, this is your fancy webserver!' });
});

// Handle 404 errors
app.use((req, res, next) => {
    res.status(404).send('Sorry, we could not find that!');
});

// Handle other errors
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});