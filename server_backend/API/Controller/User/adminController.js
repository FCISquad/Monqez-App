const express = require('express');
const app = express();

const helper = require('../../Tools/RequestFunctions');
const adminModel = require('../../Model/User/adminUser');
const tracker = require('../../Tools/debugger');
const controllerType = "admin";

app.post('/add' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if ( userID === null ){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new adminModel().addAdmin(request.body["newUserID"])
                .then( () => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.send(error);
                } );
        }
    });
});

app.post('/get_state', (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            new adminModel().getState().then((stateJson) => {
                tracker.track("request finished without errors");
                response.send(stateJson);
            }).catch((error) => {
                tracker.error(error);
                response.send(error);
            });
        }
    });
});

app.post('/get_application' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            new adminModel().getApplication(request.body["userID"]).then((applicationJson) => {
                tracker.track("request finished without errors");
                response.send(applicationJson);
            }).catch((error) => {
                tracker.error(error);
                response.send(error);
            });
        }
    });
})

app.post('/get_application_queue', (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new adminModel().getAllApplicationRequests().then((queue) => {
                tracker.track("request finished without errors");
                response.send(queue);
            }).catch((error) => {
                tracker.error(error);
                response.send(error);
            });
        }
    });
});

app.post('/addAdditionalInformation' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if ( userID === null ){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");

            new adminModel().addAdditionalInformation(userID, request.body)
                .then( () => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    tracker.error(error);
                    response.send(error);
                } );
        }
    });
});

app.post( '/set_approval' , (request , response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if ( userID === null ){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new adminModel().setApproval(userID , request.body);
            response.sendStatus(200);
            tracker.track("request finished without errors");
        }
    });
} );

app.post('/ban', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new adminModel().banUser(request.body["uid"])
                .then(function (){
                    tracker.track("request finished without errors");
                    response.send(200);
                })
                .catch(function (error){
                    tracker.error(error);
                    response.status(503).send(error);
                })
        }
    })
});

app.get('/getComplaints', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new adminModel().getAllComplaints()
                .then( function (comps){
                    tracker.track("request finished without errors");
                    response.status(200).send(comps);
                } )
                .catch( function (error){
                    tracker.error(error);
                    response.send(503);
                } )
        }
    })
});

app.get('/getComplaint', function (request, response){
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null){
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        }
        else{
            tracker.track("good Auth - start process");
            new adminModel().getComplaint(request.body)
                .then(function (complaint){
                    tracker.track("request finished without errors");
                    response.status(200).send(complaint);
                })
                .catch(function (error){
                    tracker.error(error);
                    response.status(503).send(error);
                })
        }
    })
});


module.exports = app;