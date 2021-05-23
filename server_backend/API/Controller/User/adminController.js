const express = require('express');
const app = express();

const helper = require('../../Tools/RequestFunctions');
const adminModel = require('../../Model/User/adminUser');

// url/admin/add
app.post('/add' , (request , response) => {
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

app.post('/get_state', (request , response) => {
    helper.verifyToken(request, (userID) => {
        if (userID === null) {
            response.sendStatus(403);
        } else {
            let admin = new adminModel(request.body);
            admin.getState().then((stateJson) => {
                response.send(stateJson);
            }).catch((error) => {
                response.send(error);
            });
        }
    });
});

app.post('/get_application' , (request , response) => {
    helper.verifyToken(request, (userID) => {
        if (userID === null) {
            response.sendStatus(403);
        } else {
            let admin = new adminModel(request.body);
            admin.getApplication(request.body.userID).then((applicationJson) => {
                response.send(applicationJson);
            }).catch((error) => {
                response.send(error);
            });
        }
    });
})

app.post('/get_application_queue', (request , response) => {
    helper.verifyToken(request, (userID) => {
        if (userID === null) {
            response.sendStatus(403);
        } else {
            let admin = new adminModel(request.body);
            admin.getAllApplicationRequests().then((queue) => {
                response.send(queue);
            }).catch((error) => {
                response.send(error);
            });
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

app.post( '/set_approval' , (request , response) => {
    helper.verifyToken(request , (userID) => {
        if ( userID === null ){
            response.sendStatus(403);
        }
        else{
            let admin = new adminModel(request.body);
            admin.setApproval(userID , request.body);
            response.sendStatus(200);
        }
    });
} );


const mailer = require('../../Tools/nodeMailer');
app.post('/test' , (request , response) => {
    mailer.sendMail('fifteenseven7@gmail.com' , 'mail from monqez' , 'hello world')
        .then( (info) => {console.log(info)} )
        .catch( (error) => {console.log(error)} );
    response.end();
});


app.post('/base64', (req, res) => {
    console.log(req.body["image"]);
})

module.exports = app;