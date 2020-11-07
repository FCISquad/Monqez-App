const admin = require('firebase-admin')

module.exports = {
    createUser(userJson , callback){
        admin.auth().verifyIdToken(userJson.token).then(function (decodedToken){
            let userId = decodedToken.uid
            if ( userId === userJson.uid ){
                admin.database().ref('user/' + userJson.uid).once("value" , function (userInfo){
                    // if ( userInfo.val().national_id === userJson.national_id ){
                        admin.database().ref('user/' + userId).set({
                            name: userJson.name,
                            national_id: userJson.national_id,
                            phone: userJson.phone,
                            gender: userJson.gender,
                            birthdate: userJson.birthdate,
                            country: userJson.country,
                            city: userJson.city,
                            street: userJson.street,
                            buildNumber: userJson.buildNumber,
                            chronicDiseases: "",
                            disable: "false",
                            type: "0"
                        })
                        callback('okay')
                    // }
                    // else{
                    //     callback('nationalID founded')
                    // }
                })
            }
            else{
                callback('invalid id')
            }
        }).catch(function (error){
            callback('unauthorized')
        })
    },

    changeToMonqez(userJson , callback){
        admin.database().ref('monqez/' + userJson.uid).set({
            certificate: userJson.certificate,
            certificateName: userJson.certificateName
        })
        admin.database().ref('user/' + userJson.uid).update({
            "type": "1",
            "disable": "true"
        })
    },

    getUserInformation(userJson , callback){
        console.log(0)
        admin.auth().verifyIdToken(userJson.token).then(function (decodedToken){
            let userId = decodedToken.uid
            console.log(1)
            if ( userId === userJson.uid ){
                console.log(2)
                admin.database().ref('user/' + userJson.uid).once("value" , function (userInfo){
                    if (userInfo.val() === null){
                        callback({
                            type: "-1",
                            isDisabled: "false",
                            firstLogin: "true"
                        })
                    }
                    else{
                        callback({
                            type: userInfo.val().type,
                            isDisabled: userInfo.val().disable,
                            firstLogin: "false"
                        })
                    }
                })
            }
        })
    },

    // uploadCertificate(certificate , callback){
    //     admin.database.ref('monqez/' + certificate.uid).once("value" , function (userInfo){
    //         if ( userInfo.val() === null ){
    //             callback({
    //                 "Status": "User type is not monqez"
    //             })
    //         }
    //         else{
    //             admin.database.ref("monqez/" + certificate.uid).update({
    //                 "disable": userInfo.disable,
    //                 "certificate": certificate.image,
    //                 "certificateName": certificate.name
    //             })
    //             callback({
    //                 "Status": "Certificate Added Successfully"
    //             })
    //         }
    //     })
    // },

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