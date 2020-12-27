const express = require('express');
const app = express();

const helper = require('../../Tools/RequestFunctions');
const adminModel = require('../../Model/User/adminUser');

// url/admin/add
app.post('/add' , (request , response) => {
    // console.log(request.body);
    //
    // request.body.userID = request.body.newUserID;
    // let admin = new adminModel(request.body);
    // admin.addAdmin(request.body.newUserID)
    //     .then( () => {
    //         response.sendStatus(200);
    //     } )
    //     .catch( (error) => {
    //         response.status(error.code).send(error);
    //     } );


    helper.verifyToken(request , (userID) => {
        if ( userID === null ){
            response.sendStatus(403);
        }
        else{
            request.body.userID = request.body.newUserID;
            let admin = new adminModel(request.body);
            admin.addAdmin(request.body.newUserID)
                .then( () => {
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    response.send(error);
                } );
        }
    });
});

app.post('/addAdditionalInformation' , (request , response) => {
    helper.verifyToken(request , (userID) => {
        if ( userID === null ){
            response.sendStatus(403);
        }
        else{
            let admin = new adminModel(request.body);
            admin.addAdditionalInformation(userID, request.body)
                .then( () => {
                    response.sendStatus(200);
                } )
                .catch( (error) => {
                    response.send(error);
                } );
        }
    });
});


module.exports = app;