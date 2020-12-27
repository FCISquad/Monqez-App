const express = require('express');
const app = express();

app.use(express.json());
app.get('/', (req,res) => {
    res.send('Welcome in Monqez Server');
});

const monqez = require('./monqez');
app.use('/' , monqez);

const port = process.env.PORT || '5000';
app.listen(port, () => console.log(`Server started on Port ${port}`));
