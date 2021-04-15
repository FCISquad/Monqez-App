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
            user.signUp();
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
            user.submitApplication(request.body.submissionDate);
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
                    console.log(error);
                    response.send(error);
                } );
        }
    });
} );

app.get( '/getprofile' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            User.getProfile(userId)
                .then( (userJson) => {
                    response.send(userJson);
                } )
                .catch( (error) => {
                    console.log(error);
                    response.send(error);
                } );
        }
    });
} );

app.post( '/edit' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            User.editAccount(userId, request.body)
                .then( (userJson) => {
                    response.send(userJson);
                } )
                .catch( (error) => {
                    console.log(error);
                    response.send(error);
                } );
        }
    });
} );

app.post('/update_registration_token', (request, response)=>{
    console.log(request.body);
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            User.registrationToken(userId, request.body)
                .then( () => {
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    console.log(error);
                    response.send(error);
                } );
        }
    });
});

app.post('/request', (request, response) => {
    let user = new NormalUser(request.body);
    user.request("userId", request.body);
    response.sendStatus(200);

    // helper.verifyToken(request , (userId) => {
    //     if ( userId === null ){
    //         // Forbidden
    //         response.sendStatus(403);
    //     }
    //     else{
    //        let user = new NormalUser(request.body);
    //        user.request(userId, request.body);
    //        response.sendStatus(200);
    //     }
    // });
})
module.exports = app;