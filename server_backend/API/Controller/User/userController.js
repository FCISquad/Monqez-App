const express = require('express');
const app = express();


const helper = require('../../Tools/RequestFunctions');
const NormalUser = require("../../Model/User/normalUser");
const HelperUser = require("../../Model/User/helperUser");
const User = require("../../Model/User/user");

app.post('/signup' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            request.body.userID = userId;
             let user = new NormalUser(request.body);
            // user.signUp();
            response.sendStatus(200);
        }
    });
});

app.post('/apply' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            /**
             discuss error here , see => submitApplication => user.submitApplication();
             */
            request.body.userID = userId;
            let user = new HelperUser(request.body);
            user.submitApplication();
            response.sendStatus(200);
        }
    });
});

app.get( '/get' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            /**
             discuss error here , see => submitApplication => user.submitApplication();
             */
            request.body.userID = userId;
            User.getUser(userId)
                .then( (userJson) => {
                    response.send(userJson);
                } )
                .catch( (error) => {
                    response.send(error);
                } );
        }
    });
} );
module.exports = app;