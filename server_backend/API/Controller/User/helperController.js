const express = require('express');
const app = express();


const helper = require("../../Tools/RequestFunctions");
const HelperUser = require("../../Model/User/helperUser");
const normalUser = require("../User/userController");

// const userController = require()


app.post('/setstatus' , (request , response) => {
    // let helper = new HelperUser(request.body);
    // helper.setStatus(request.body.uid , request.body.status)
    //     .then(() => {
    //         response.sendStatus(200);
    //     })
    //     .catch( (error) => {
    //         response.send(error);
    //     } );


    helper.verifyToken(request , (userID) => {
        if ( userID === null ){
            response.sendStatus(403);
        }
        else{
            let helper = new HelperUser(request.body);
            helper.setStatus(userID , request.body.status)
                .then(() => {
                    response.sendStatus(200);
                })
                .catch( (error) => {
                    response.send(error);
                } );
        }
    })
});
app.get( '/getstate' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            let helper = new HelperUser(request.body);
            helper.getState(userId).then( (userJson) => {
                response.send(userJson);
            } )
            .catch( (error) => {
                response.send(error);
            } );
        }
    });
} );
app.post('/update_location', (request, response) => {

    helper.verifyToken(request, (userID) => {
        if (userID === null){
            response.sendStatus(403);
        }
        else{
            let helper = new HelperUser(request.body);
            helper.updateLocation(userID);
            response.sendStatus(200);
        }
    });
});
app.post('/decline_request', (request, response) => {
    // let user = new HelperUser(request.body);
    // user.requestDecline("monqez-ehab1", request.body);
    // response.sendStatus(200);

    helper.verifyToken(request , (monqezId) => {
        if ( monqezId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            let user = new HelperUser(request.body);
            user.requestDecline(monqezId, request.body)
                .then((allDecline) => {
                    if ( allDecline === true ){
                        user.rerequest(request.body);
                    }
                    response.sendStatus(200);
                })
                .catch((err) => {
                    response.sendStatus(503);
                });
        }
    });
});
app.post( '/accept_request' , (request, response) => {
    helper.verifyToken(request , (monqezId) => {
        if ( monqezId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            let user = new HelperUser(request.body);
            user.requestAccept(monqezId, request.body)
                .then( () => {
                    response.sendStatus(200);
                })
                .catch( () => {
                    response.sendStatus(201);
                });
        }
    });
} );

app.post('/get_call_queue' , (request, response) => {
    // let user = new HelperUser(request.body);
    // user.getCalls().then( (channelId) => {
    //     response.status(200).send(channelId);
    // } );

    helper.verifyToken(request, (userId) => {
        if (userId === null){
            response.sendStatus(403);
        }
        else{
            let user = new HelperUser(request.body);
            user.getCalls().then( (channelId) => {
                response.status(200).send(channelId);
            } );
        }
    });
});

app.post('/accept_call', (request, response) => {
    console.log("in");
    helper.verifyToken(request, (userId) => {
        if (userId === null){
            response.sendStatus(403);
        }
        else{
            let user = new HelperUser(request.body);
            user.acceptCall(userId, request.body).then( () => {

                console.log("Hussien");
                response.sendStatus(200);

                user.logCallRequest(request.body).then( ()=>{} );
            } )
            .catch( () => {
                response.sendStatus(503);
            } );
        }
    });
});

app.post('/get_additional_information', (request, response) => {
    helper.verifyToken(request, (userId) => {
        if (userId === null){
            response.sendStatus(403);
        }
        else{
            let user = new HelperUser(request.body);
            user.get_additional_information(request.body["uid"]).then( (additionalInfo) => {
                response.status(200).send(additionalInfo);
            } );
        }
    });
});

module.exports = app;