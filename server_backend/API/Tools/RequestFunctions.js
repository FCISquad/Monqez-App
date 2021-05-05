const admin = require('firebase-admin');

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

    verifyToken(requestJson , callback){
        const bearerHeader = requestJson.headers['authorization'];

        if (bearerHeader) {
            const bearer = bearerHeader.split(' ');
            const bearerToken = bearer[1];
            admin.auth().verifyIdToken(bearerToken).then((decodedToken) => {
                callback(decodedToken.uid);
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
    }
}