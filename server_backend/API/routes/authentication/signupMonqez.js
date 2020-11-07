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
            database.createUser(requestJson , function (status){
                if      ( status === 'unauthorized' ){
                    response.send(http.STATUS_CODES[401])
                }
                else if ( status === 'invalid id' ){
                    response.send(http.STATUS_CODES[403])
                }
                else if ( status === 'okay' ){
                    database.changeToMonqez(requestJson)
                    response.send(http.STATUS_CODES[200])
                }
                else if ( status === 'nationalID founded' ){
                    response.send(http.STATUS_CODES[403])
                }
            })
        }
    })
})



module.exports = router;