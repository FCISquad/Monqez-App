const express = require('express')
const router = express.Router()
const helper = require('../../Tools/RequestFunctions');
const userController = require("../../Old Controller/User/userController");
const HelperUser = require("../../Model/User/helperUser");
const NormalUser = require("../../Model/User/normalUser");
const User = require("../../Model/User/user");

router.post('/signup' , (request , response) => {
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

router.post('/apply' , (request , response) => {
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

router.get( '/get' , (request , response) => {
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
            let user_controller = new userController();
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

// router.get( '/get_certificate' , (request , response) => {
//     helper.verifyToken(request , (userId) => {
//         if (userId === null) {
//             // Forbidden
//             response.sendStatus(403);
//         }
//         else{
//             request.body.userID = userId;
//             let helperUser = new HelperUser();
//             helperUser.getCertificate(userId)
//                 .then( (certificate) => {
//                     response.send(certificate);
//                 } )
//                 .catch( (error) => {
//                     response.send(error);
//                 } );
//         }
//     });
// });

module.exports = router;