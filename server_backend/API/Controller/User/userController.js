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

function requestTimeOut(userId, monqezIDs){
    new NormalUser().isTimeOut(userId).then( (acceptCount) => {
        if (acceptCount === 0){
            for (let i = 3; i < monqezIDs.length; ++i){
                let user = new NormalUser({});
                user.requestTimeOut(userId, monqezIDs[i]).then( (allDecline) => {
                    if (allDecline === true){
                        re_request({"uid" : userId});
                    }
                } )
            }
        }
    } );
}

app.post('/request', (request, response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
           let user = new NormalUser(request.body);
           user.request(userId, request.body, true).then((monqezIDs) => {
               response.sendStatus(200);
               setTimeout(function (){
                   requestTimeOut(userId, monqezIDs);
               }, 30000);
               //setTimeout(30000, requestTimeOut, userId, monqezIDs);
           })
           .catch(() => {
               // service unavailable
               response.sendStatus(503);
           });
        }
    });
})

app.post('/request_information', (request, response) => {

    // let user = new NormalUser(request.body);
    // user.request_additional("ehabfawzy", request.body);
    // response.sendStatus(200);

    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            let user = new NormalUser(request.body);
            user.request_additional(userId, request.body);
            response.sendStatus(200);
        }
    });
});

app.post('/call', (request, response) => {

    // let user = new NormalUser(request.body);
    // user.insertCall( "ehabID" , request.body).then( (channelId) => {
    //     response.status(200).send(channelId);
    // } );

    helper.verifyToken(request, (userId) => {
        if (userId === null){
            response.sendStatus(403);
        }
        else{
            let user = new NormalUser(request.body);
            user.insertCall(userId , request.body).then( (channelId) => {
                response.status(200).send(channelId);
            } );
        }
    });
});

function re_request(userJson){
    let user = new NormalUser(userJson);
    user.getLongLat(userJson["uid"]).then( (locationJson) => {
        if (locationJson["isFirst"] === true){
            user.request(userJson["uid"], locationJson , false)
                .then((monqezIDs) => {
                    setTimeout(function (){
                        requestTimeOut(userJson["uid"], monqezIDs);
                    }, 30000);
                })
                .catch(() => {});
        }
    } );
}

app.post( '/call_out' , (request, response) => {
    console.log(11);
    helper.verifyToken(request, (userId) => {
        if (userId === null){
            response.sendStatus(403);
        }
        else{
            let user = new NormalUser(request.body);
            console.log(22);
            user.callOut(userId).then( () => {
                response.sendStatus(200);
                console.log(33);
                user.logCallRequest({"uid" : userId}).then(() => {});
            } );
        }
    });
} );

module.exports.re_request = re_request;

module.exports = app;