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
    }
}