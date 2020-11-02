const express = require('express');
const app = express();

/*
    Firebase database connection
 */
const admin = require('firebase-admin');
const serviceAccount = require('./API/firebase/firebase-Monqez.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://monqez-6f9b1.firebaseio.com"
});

/*
    Routes Sections
 */

const signupRoute = require('./API/routes/authentication/signup');
app.use('/signup' , signupRoute);

module.exports = app;