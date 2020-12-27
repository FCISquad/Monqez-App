// const bodyParser = require('body-parser');
// const session = require("express-session");
const express = require('express');
const app = express();

// const admin = require('firebase-admin');
// const serviceAccount = require('./firebase-Monqez.json');
// admin.initializeApp({
//     credential: admin.credential.cert(serviceAccount),
//     databaseURL: "https://monqez-6f9b1.firebaseio.com"
// });
//
// app.use(session({
//     secret: 'secret',
//     resave: true,
//     saveUninitialized: true
// }));
// app.use(bodyParser.urlencoded({extended : true}));
// app.use(bodyParser.json());


// const signupRoute = require('./API/Controller/User/userController');
// app.use('/user' , signupRoute);

//
// const path = require('./api/code');
// app.use('/code' , path);

module.exports = app;