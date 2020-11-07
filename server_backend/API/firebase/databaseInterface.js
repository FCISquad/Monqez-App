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
    },

    getUserInformation(userJson , callback){
        admin.database().ref('users/' + userJson.uid).once("value" , function (userInfo){
            if (userInfo.val() === null){
                callback({
                    "databaseStatus" : "user not founded"
                })
            }
            else{
                let user = userInfo.val()
                let databaseStatus = {"state" : "user founded"}
                admin.database.ref('monqez/')
                callback({databaseStatus , user})
            }
        })
    },

    uploadCertificate(certificate , callback){
        admin.database.ref('monqez/' + certificate.uid).once("value" , function (userInfo){
            if ( userInfo.val() === null ){
                callback({
                    "Status": "User type is not monqez"
                })
            }
            else{
                admin.database.ref("monqez/" + certificate.uid).update({
                    "disable": userInfo.disable,
                    "certificate": certificate.image,
                    "certificateName": certificate.name
                })
                callback({
                    "Status": "Certificate Added Successfully"
                })
            }
        })
    },

    downloadCertificate(certificate , callback){
        admin.database.ref('monqez/' + certificate.uid).once("value" , function (userInfo){
            if ( userInfo.val() === null ){
                callback({
                    "CertificateName" : "null",
                    "Certificate" : "null"
                })
            }
            else{
                callback({
                    "CertificateName" : userInfo.val().name,
                    "Certificate" : userInfo.val().image
                })
            }
        })
    }
}