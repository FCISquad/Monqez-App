const admin = require('firebase-admin');
const Database = require('../Database/database');
const database = new Database();
// const rp = require('request-promise');

module.exports = {
    verifyToken(requestJson, controllerType , callback){
        let bearerHeader = requestJson.headers['authorization'];

        if (bearerHeader) {
            const bearer = bearerHeader.split(' ');
            const bearerToken = bearer[1];

            admin.auth().verifyIdToken(bearerToken).then((decodedToken) => {

                if (controllerType === "all" || ("onetimerequest" in requestJson.headers)){
                    callback(decodedToken.uid);
                }
                else{
                    database.getUserType(decodedToken.uid)
                        .then( function (userType){
                            console.log("*INFO", userType);
                            if (userType === controllerType){
                                callback(decodedToken.uid);
                            }
                            else{
                                callback(null);
                            }
                        } )
                        .catch( function(error){
                            callback(null);
                        } )
                }
            }).catch((error) => {
                callback(null);
            })
        }
        else{
            callback(null);
        }
    },

    send_notifications(userId, payload, options){
        admin.database().ref('user/' + userId).once("value", function (snapshot) {
            let token = snapshot.val()["token"];
            let registrationTokens = [];
            registrationTokens.push(token);

            admin.messaging().sendToDevice(registrationTokens, payload, options)
                .then(function (response) {
                    // See the MessagingDevicesResponse reference documentation for
                    // the contents of response.
                    console.log('Successfully sent message:', response);
                })
                .catch(function (error) {
                    console.log('Error sending message:', error);
                });
        }).then(function (){})
            .catch(function (error){})
    }
}