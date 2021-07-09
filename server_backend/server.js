const express = require('express');
const app = express();

app.use(express.json({limit: '50mb'}));
app.get('/', (req,res) => {
    res.send('Welcome in Monqez Server');
});

const monqez = require('./monqez');
const localtunnel = require("localtunnel");
app.use('/' , monqez);

const port = process.env.PORT || '5000';
app.listen(port, () => console.log(`Server started on Port ${port}`));


(async () => {
    const tunnel = await localtunnel({ port: 5000, subdomain: "monqez2" });

    // the assigned public url for your tunnel
    // i.e. https://abcdefgjhij.localtunnel.me
    console.log(tunnel.url);

    tunnel.on('close', () => {
        // tunnels are closed
    });
})();