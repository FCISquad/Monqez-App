const express = require('express')
const router = express.Router()

const http = require('http')
const helper = require('../../helper/RequestFunctions')
const database = require('../../firebase/databaseInterface')


router.post('/' , function(request , response){
    helper.RequestToJson(request , function (requestJson){
        if ( requestJson === null ){
            response.send(http.STATUS_CODES[400])
        }
        else{
            database.getUserInformation(requestJson , function (statusJson){
                response.status(200).send(statusJson)
            })
        }
    })
})

module.exports = router;