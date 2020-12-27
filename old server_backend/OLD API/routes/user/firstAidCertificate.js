const express = require('express')
const router = express.Router()

const http = require('http')
const helper = require('../../helper/RequestFunctions')
const database = require('../../firebase/databaseInterface')

router.post('/download' , function (request , response){
    helper.RequestToJson(request , function (certificateJson){
        database.downloadCertificate(certificateJson , function (status){
            response.send(status)
        })
    })
})

router.post('/upload' , function (request , response){
    helper.RequestToJson(request , function (certificateJson){
        database.uploadCertificate(certificateJson , function (status){
            response.send(status)
        })
    })
})


module.exports = router