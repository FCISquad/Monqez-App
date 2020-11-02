const admin = require('firebase-admin')

module.exports = {
    createUser(userJson , callback){
        admin.auth().verifyIdToken(userJson.token).then(function (decodedToken){
            let userId = decodedToken.uid
            if ( userId === userJson.uid ){
                admin.database().ref('users/' + userId).set({
                    name: userJson.name,
                    phone: userJson.phone,
                    nationalID: userJson.national_id
                })
                callback('okay')
            }
            else{
                callback('invalid id')
            }
        }).catch(function (error){
            callback('unauthorized')
        })
    }
}