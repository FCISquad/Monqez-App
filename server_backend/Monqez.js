const express = require('express');
const session = require('express-session');
const bodyParser = require('body-parser');
const app = express();

/*
    Firebase database connection
 */
const admin = require('firebase-admin');
const serviceAccount = require('./OLD API/firebase/firebase-Monqez.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://monqez-6f9b1.firebaseio.com"
});


app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));
app.use(bodyParser.urlencoded({extended : true}));
app.use(bodyParser.json());

/*
    Routes Sections
 */

app.get('/find' , (req,res) => {
    admin.auth().createCustomToken('sitfe5LJtlVs1N4httAkrMcPMIf2')
        .then((token) => {
            res.send(token);
        })
        .catch((err) => {
            res.send(err);
        })
})

const signupRoute = require('./API/routes/User/userRoutes');
app.use('/user' , signupRoute);

const signupMonqezRoute = require('./OLD API/routes/authentication/signupMonqez');
app.use('/apply' , signupMonqezRoute);

const UserInformation = require('./OLD API/routes/user/getuser');
app.use('/checkUser' , UserInformation);

// const certificate = require('./API/routes/user/firstAidCertificate')
// app.use('/certificate' , certificate)

module.exports = app;