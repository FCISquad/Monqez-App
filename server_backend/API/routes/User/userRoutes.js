const express = require('express')
const router = express.Router()

const http = require('http')
const helper = require('../../Tools/RequestFunctions');
const database = require('../../Database/database');
const normalUserController = require("../../Controller/User/normalUserController");

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
            request.body.userID = userId;
            let normalUser_controller = new normalUserController();
            normalUser_controller.signup(request.body);
            response.sendStatus(200);
        }
    });
});

module.exports = router;