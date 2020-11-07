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

const signupRoute = require('./API/routes/authentication/signup')
app.use('/signup' , signupRoute)

const signupMonqezRoute = require('./API/routes/authentication/signupMonqez')
app.use('/apply' , signupMonqezRoute)

const UserInformation = require('./API/routes/user/getuser')
app.use('/checkUser' , UserInformation)

// const certificate = require('./API/routes/user/firstAidCertificate')
// app.use('/certificate' , certificate)

module.exports = app;