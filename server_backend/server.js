const http = require('http');
const port = 8000;

const app = require('./Monqez');
const server = http.createServer(app);

server.listen(port);