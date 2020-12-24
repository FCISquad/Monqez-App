const http = require('http');
const port = 8000;

const localtunnel = require('localtunnel');
(
    async () => {
        const tunnel = await localtunnel({port : port , subdomain : "monqezapp"});
        console.log(tunnel.url);
    }
)();

const app = require('./Monqez');
const server = http.createServer(app);

server.listen(port);