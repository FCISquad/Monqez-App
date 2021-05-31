const bodyParser = require('body-parser');
const session = require("express-session");
const express = require('express');
const app = express();

const admin = require('firebase-admin');
const serviceAccount = require('./firebase-Monqez.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://monqez-6f9b1.firebaseio.com"
});

app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));
app.use(bodyParser.urlencoded({parameterLimit: 100000,limit: '50mb', extended : true}));
app.use(bodyParser.json({limit: '50mb'}));

const userRoute = require('./API/Controller/User/userController');
app.use('/user' , userRoute);

const adminRoute = require('./API/Controller/User/adminController');
app.use('/admin' , adminRoute);

const helperRoute = require('./API/Controller/User/helperController');
app.use('/helper' , helperRoute);

const helper = require('./API/Tools/RequestFunctions');
app.get('/getToken' , (request, response) => {
    console.log("*INFO", request.body["uid"]);
    helper.getToken(request.body["uid"]).then( (token) => {
        response.status(200).send(token);
    })
});

module.exports = app;