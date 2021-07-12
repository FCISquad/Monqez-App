const express = require('express');
const app = express();


const helper = require('../../Tools/requestFunctions');
const NormalUser = require("../../Model/User/normalUser");
const HelperUser = require("../../Model/User/helperUser");
const User = require("../../Model/User/user");
const tracker = require('../../Tools/debugger');

const controllerType = "normal";
const freeForAll = "all";

app.post('/notify_me', function(request, response){

    helper.verifyToken(request, controllerType, (userId) => {
        const payload = {
            notification: {
                title: 'Hello world',
                body: 'Test notifications'
            },
            data:{
                type: 'normal',
                description: 'message'
            }
        };

        const options = {
            priority: 'high',
            timeToLive: 60 * 60
        };

        helper.send_notifications(userId, payload, options);
    });

})

app.post('/khaled', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    // console.log("*INFO", request.body["oneTimeRequest"]);
    // response.send(200);

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            response.send(200);
        }
    })
});

app.post('/signup' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll , (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().signUp(userId, request.body)
                .then( function (){
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .then( function(error){
                    tracker.error(error);
                    response.status(400).send(error);
                } );
        }
    });

});

app.post('/apply' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll , (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            /**
             discuss error here , see => submitApplication => user.submitApplication();
             */

            tracker.track("good Auth - start process");
            new HelperUser(request.body).submitApplication(userId, request.body)
                .then( function (){
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.status(400).send(error);
                } )
        }
    });
});

app.get( '/get' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll, (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            /**
             discuss error here , see => submitApplication => user.submitApplication();
             */
            tracker.track("good Auth - start process");
            User.getUser(userId)
                .then( (userJson) => {
                    tracker.track("request finished without errors");
                    response.send(userJson);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.status(400).send(error);
                } );
        }
    });

} );

app.get( '/getprofile' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll ,(userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            User.getProfile(userId)
                .then( (userJson) => {
                    tracker.track("request finished without errors");
                    response.send(userJson);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.status(400).send(error);
                } );
        }
    });
} );

app.get( '/get_instructions' , (request , response) => {
    User.getInstructions()
        .then( (userJson) => {
            response.send(userJson);
        } )
        .catch( (error) => {
            console.log(error);
            response.send(error);
        } );

} );

app.post( '/edit' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll, (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            User.editAccount(userId, request.body)
                .then( (userJson) => {
                    tracker.track("request finished without errors");
                    response.send(userJson);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.send(error);
                } );
        }
    });

} );

/*
        need to discuss (delete !)
        need to discuss (delete !)
        need to discuss (delete !)
        need to discuss (delete !)
        need to discuss (delete !)
        need to discuss (delete !)
 */
app.post('/update_registration_token', (request, response)=>{
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, freeForAll, (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            User.registrationToken(userId, request.body)
                .then( () => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.status(400).send(error);
                } );
        }
    });

    tracker.end();
});

function requestTimeOut(userId, monqezIDs){
    tracker.track("Time is finished - check the request state");

    new NormalUser().isCancelled(userId).then(function (result){
        if (result !== "cancelled"){
            new NormalUser().isTimeOut(userId).then( (acceptCount) => {
                if (acceptCount === 0){
                    tracker.track("No helper accept the request");
                    for (let i = 3; i < monqezIDs.length; ++i){
                        let user = new NormalUser({});
                        user.requestTimeOut(userId, monqezIDs[i]).then( (allDecline) => {
                            if (allDecline === true){
                                tracker.track("all decline - call re request function");
                                re_request({"uid" : userId});
                            }
                        } )
                    }
                }
                else{
                    tracker.track("request is accepted by some helper");
                }
            } );
        }
    });
}

app.post('/cancel_request', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new NormalUser().cancel_request(userId).then(function (){
                tracker.track("request finished without errors");
                response.sendStatus(200);
            })
        }
    })
});

app.post('/check_national_ID', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().checkOneTimeRequest(userId, request.body["nationalId"])
                .then( function (){
                    tracker.track("request finished without errors");
                    response.send(200);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.status(503).send(error);
                } )
        }
    })
});

// app.post('/check_national_ID', (request, response) => {
//     tracker.start(request.originalUrl);
//     tracker.track("Hello Request");
//
//     tracker.track(request.body["nationalId"]);
//     new NormalUser().checkOneTimeRequest(request.body["nationalId"])
//         .then( function (){
//             tracker.track("request finished without errors");
//             response.send(200);
//         } )
//         .catch( function (error){
//             tracker.error(error);
//             response.status(403).send(error);
//         } )
// });

app.post('/request', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().validRequest(userId).then(function (){
                new NormalUser().request(userId, request.body, true).then((monqezIDs) => {
                    response.sendStatus(200);

                    tracker.track("request is send");
                    tracker.track("start timer");

                    setTimeout(function (){
                        requestTimeOut(userId, monqezIDs);
                    }, 30000);
                }).catch((error) => {
                        // service unavailable
                        tracker.error(error);
                        response.sendStatus(503);
                    });
            }).catch(function (error){
                tracker.error(error);
                response.sendStatus(503);
            });

        }
    });

    tracker.end();
})

app.post('/request_information', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if ( userId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new NormalUser().request_additional(userId, request.body);
            response.sendStatus(200);
            tracker.track("request finished without errors");
        }
    });

    tracker.end();
});

app.post('/call', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new NormalUser().insertCall(userId , request.body).then( (channelId) => {
                response.status(200).send(channelId);
                tracker.track("request finished without errors");
            } );
        }
    });

    requestTimeOut()
});

function re_request(userJson){
    tracker.track("start re-request function");
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
    tracker.track("END re-request function");
}

app.post( '/call_out' , (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new NormalUser().callOut(userId).then( () => {
                response.sendStatus(200);

                tracker.track("archive call");
                new NormalUser().logCallRequest({"uid" : userId}).then(() => {});
                tracker.track("request finished without errors");
            } );
        }
    });
    tracker.end();
} );

module.exports.re_request = re_request;

app.get('/get_requests', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().getRequestLog(userId)
                .then( function (requestLog){
                    tracker.track("request finished without errors");
                    response.status(200).send(requestLog);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.send(503);
                } );
        }
    })
});

app.post('/rate', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().rate(userId, request.body)
                .then( () => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .catch( function ( error) {
                    tracker.error(error);
                    response.status(503).send(error);
                });
        }
    })
});

app.post('/complaint', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new NormalUser().addComplaint(userId, request.body)
                .then( function (){
                    tracker.track("request finished without errors");
                    response.send(200);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.status(503).send(error);
                } );
        }
    })
});

app.get('/get_instructions', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            User.getInstructions()
                .then( (userJson) => {
                    response.send(userJson);
                } )
                .catch( (error) => {
                    console.log(error);
                    response.send(error);
                } );
        }
    })
});


module.exports = app;