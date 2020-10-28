const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');
const qs = require('querystring');

router.post('/' , function (request,response){
    var body = '';
    request.on('data', function (data) {
        body += data;
        // Too much POST data, kill the connection!
        // 1e6 === 1 * Math.pow(10, 6) === 1 * 1000000 ~~~ 1MB
        if (body.length > 1e6)
            request.connection.destroy();
    });

    var obj;
    request.on('end', function () {
        obj = JSON.parse(body);
        console.log(obj.token);
        console.log(obj.uid);
        console.log(obj.name);
        console.log(obj.national_id);
        console.log(obj.phone);


        admin.auth().verifyIdToken(obj.token).then(function(decodedToken){
            var uid = decodedToken.uid;
            if ( uid === obj.uid ){
                admin.database().ref('users/' + uid).set({
                    name: obj.name,
                    phone: obj.phone,
                    nationalID: obj.national_id
                })

                // response
                response.status(200).json({
                    "message": "okay"
                });
            }
            else{
                response.status(404);
                response.status(404).json({
                    "message" : "hatem"
                });
            }
            console.log(uid);
            console.log(obj.uid);
        }).catch(function (error){
            console.log(error);
            response.status(404).json({
               "message" : "hatem"
            });
        });
    });


});


module.exports = router;