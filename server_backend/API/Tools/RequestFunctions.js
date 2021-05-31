const admin = require('firebase-admin');
const Database = require('../Database/database');
const database = new Database();
const rp = require('request-promise');

module.exports = {
    RequestToJson(request){
        let body = '';
        request.on('data' , function (data){
            body += data
            if (body.length > 1e6){
                request.connection.destroy()
                return null;
            }
        });
        request.on('end' , ()=>{
            return JSON.parse(body);
        });
    },

    // verifyToken(requestJson , callback){
    //     const bearerHeader = requestJson.headers['authorization'];
    //
    //     if (bearerHeader) {
    //         const bearer = bearerHeader.split(' ');
    //         const bearerToken = bearer[1];
    //         admin.auth().verifyIdToken(bearerToken).then((decodedToken) => {
    //             callback(decodedToken.uid);
    //         }).catch((error) => {
    //             callback(null);
    //         })
    //     }
    //     else{
    //         callback(null);
    //     }
    // },

    verifyToken(requestJson, controllerType , callback){
        let bearerHeader = requestJson.headers['authorization'];

        if (bearerHeader) {
            const bearer = bearerHeader.split(' ');
            const bearerToken = bearer[1];
            admin.auth().verifyIdToken(bearerToken).then((decodedToken) => {

                if (controllerType === "all" || requestJson.hasOwnProperty("oneTimeRequest")){
                    callback(decodedToken.uid);
                }
                else{
                    database.getUserType(decodedToken.uid)
                        .then( function (userType){
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
        });
    },

    getToken(userId){
        return new Promise( (resolve, reject) => {

            admin.auth().createCustomToken(userId)
                .then(async (customToken)=>{

                    let FIREBASE_API_KEY = "AIzaSyAV1jNma63PVN33-FvVFWSN2hMqqAJH_zU";
                    rp({
                        url: `https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyCustomToken?key=${FIREBASE_API_KEY}`,
                        method: 'POST',
                        body: {
                            token: customToken,
                            returnSecureToken: true
                        },
                        json: true,
                    }).then((idToken)=>{
                        resolve(idToken);
                    })

                })
                .catch( (error) => {
                    reject(error);
                })
        } );
    }
}