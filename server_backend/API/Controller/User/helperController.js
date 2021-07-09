const express = require('express');
const app = express();

const helper = require("../../Tools/RequestFunctions");
const HelperUser = require("../../Model/User/helperUser");
const tracker = require('../../Tools/debugger');
const controllerType = "helper";


app.post('/setstatus' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if ( userID === null ){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new HelperUser().setStatus(userID , request.body.status)
                .then(() => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                })
                .catch( (error) => {
                    tracker.error(error);
                    response.send(error);
                } );
        }
    })
});

app.get( '/getstate' , (request , response) => {
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
            new HelperUser().getState(userId).then( (userJson) => {
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

app.post('/update_location', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new HelperUser().updateLocation(userID, request.body);
            response.sendStatus(200);
        }
    });
});

app.post('/decline_request', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (monqezId) => {
        if ( monqezId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            let user = new HelperUser();
            user.requestDecline(monqezId, request.body)
                .then((allDecline) => {
                    if ( allDecline === true ){
                        tracker.track("All Decline - start re request");
                        user.rerequest(request.body);
                    }
                    response.sendStatus(200);
                    tracker.track("request finished without errors");
                })
                .catch((error) => {
                    tracker.error(error);
                    response.sendStatus(503);
                });
        }
    });
});

app.post( '/accept_request' , (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (monqezId) => {
        if ( monqezId === null ){
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new HelperUser().requestAccept(monqezId, request.body)
                .then( (phoneNumber) => {
                    tracker.track("request finished without errors");
                    response.status(200).send({"phone": phoneNumber});

                    let normalUserId = request.body["uid"];
                    const payload = {
                        notification: {
                            title: 'Request is accepted',
                            body: 'Helper is on the way to you'
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

                    helper.send_notifications(normalUserId, payload, options);
                })
                .catch( () => {
                    tracker.error(error);
                    response.sendStatus(201);
                });
        }
    });
} );

app.post('/get_call_queue' , (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType,(userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new HelperUser().getCalls().then( (channelId) => {
                response.status(200).send(channelId);
                tracker.track("request finished without errors");
            } );
        }
    });
});

app.post('/accept_call', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            let user = new HelperUser();
            user.acceptCall(userId, request.body).then( () => {
                response.sendStatus(200);

                tracker.track("Write Call Request in calls Log");
                user.logCallRequest(request.body).then( ()=>{} );
                tracker.track("request finished without errors");
            } )
            .catch( (error) => {
                tracker.error(error);
                response.sendStatus(503);
            } );
        }
    });
});

app.post('/get_additional_information', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request,controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new HelperUser().get_additional_information(request.body["uid"]).then( (additionalInfo) => {
                tracker.track("request finished without errors");
                console.log("*INFO", additionalInfo);
                response.status(200).send(additionalInfo);
            } );
        }
    });
});

// app.post('/ehab', function (request, response){
//     tracker.start(request.originalUrl);
//     tracker.track("Hello Request");
//
//
//     helper.verifyToken(request, controllerType, (userId) => {
//         if (userId === null){
//             tracker.error("Auth error, null userId");
//             response.sendStatus(403);
//         }
//         else{
//             tracker.track("good Auth - start process");
//             new HelperUser().insertDummy(userId, request.body)
//                 .then( ()=> {
//                     tracker.track("request finished without errors");
//                     response.send(200);
//                 } )
//                 .catch( function (error){
//                     tracker.error(error);
//                     response.status(503).send(error);
//                 } )
//         }
//     })
// });

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

            let helperUser = new HelperUser();
            helperUser.getRequests(userId)
                .then( async function (snapShot){
                    tracker.track("done, start to collect request body");

                    let requestsPool = [];
                    for(let normalUserId in snapShot){
                        let time = snapShot[normalUserId];

                        let requestJson = await helperUser.getRequestBody(normalUserId, time);
                        let userJson    = await helperUser.getUser(normalUserId);

                        let json = {
                            "request" : requestJson,
                            "user": userJson,
                            "time": time
                        }

                        requestsPool.push(json);
                    }

                    response.status(200).send(requestsPool);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.status(503).send(error);
                } )
        }
    })
});



module.exports = app;