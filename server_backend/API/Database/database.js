const admin = require('firebase-admin')
class Database{
    createUser(userObject){
        admin.database().ref('user/' + userObject.userID).set({
            name: userObject.userName,
            national_id: userObject.userNationalID,
            phone: userObject.userPhoneNumber,
            gender: userObject.userGender,
            birthdate: userObject.userDOB,
            country: userObject.userAddress.country,
            city: userObject.userAddress.city,
            street: userObject.userAddress.street,
            buildNumber: userObject.userAddress.buildNumber,
            chronicDiseases: "",
            disable: "false",
            type: "0"
        }).then(r => {});
    }
    // createUser(userJson){
    //     admin.database().ref('user/' + userJson.uid).set({
    //         name: userJson.name,
    //         national_id: userJson.national_id,
    //         phone: userJson.phone,
    //         gender: userJson.gender,
    //         birthdate: userJson.birthdate,
    //         country: userJson.country,
    //         city: userJson.city,
    //         street: userJson.street,
    //         buildNumber: userJson.buildNumber,
    //         chronicDiseases: "",
    //         disable: "false",
    //         type: "0"
    //     }).then(r => {});
    // }
}

module.exports = Database;