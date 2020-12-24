const express = require('express')
const router = express.Router()

const http = require('http')
const helper = require('../../Tools/RequestFunctions');
const database = require('../../Database/database');
const normalUserController = require("../../Controller/User/normalUserController");
const helperController = require("../../Controller/User/helperUserContoller");
const userController = require("../../Controller/User/userController");

router.get('/signup' , (request , response) => {
    helper.verifyToken(request , (userId) => {
        if ( userId === null ){
            // Forbidden
            response.sendStatus(403);
        }
        else{
            request.body.userID = userId;
            let normalUser_controller = new normalUserController();
            normalUser_controller.signup(request.body);
            response.sendStatus(200);
        }
    });
});

router.get('/apply' , (request , response) => {
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
            let helper_controller = new helperController();
            helper_controller.submitApplication(request.body);
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
            user_controller.getUser(userId)
                .then( (userJson) => {
                    response.setHeader('Content-Type', 'application/json');
                    response.end(userJson);
                } )
                .catch( (error) => {
                    response.setHeader('Content-Type', 'application/json');
                    response.end(error);
                } );
        }
    });
} );

module.exports = router;