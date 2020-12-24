const admin = require('firebase-admin')
class Database{
    // createUser(userObject){
    //     admin.database().ref('user/' + userObject.userID).set({
    //         name: userObject.userName,
    //         national_id: userObject.userNationalID,
    //         phone: userObject.userPhoneNumber,
    //         gender: userObject.userGender,
    //         birthdate: userObject.userDOB,
    //         country: userObject.userAddress.country,
    //         city: userObject.userAddress.city,
    //         street: userObject.userAddress.street,
    //         buildNumber: userObject.userAddress.buildNumber,
    //         chronicDiseases: "",
    //         disable: "false",
    //         type: "0"
    //     }).then(r => {});
    // }


    createUserPromise(userObject){
        return new Promise( (resolve, reject) => {
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
            })
                .then(() => { resolve(); })
                .catch(() => { reject('error in firebase'); });
        } );
    }

    changeToMonqez(userObject){
        admin.database().ref('monqez/' + userObject.uid).set({
            certificate: userObject.certificate,
            certificateName: userObject.certificateName
        }).then( () => {} );
        admin.database().ref('user/' + userObject.uid).update({
            "type": "1",
            "disable": "true"
        }).then( () => {} );
    }

    getUser(userID){
        return new Promise( (resolve, reject) => {
            admin.database().ref( 'user/' + userID )
                .once("value")
                .then( (userInfo) => {
                    if ( userInfo.val() === null ){
                        resolve({
                            type: "-1",
                            isDisabled: "false",
                            firstLogin: "true"
                        });
                    }
                    else{
                        resolve({
                            type: userInfo.val().type,
                            isDisabled: userInfo.val().disable,
                            firstLogin: "false"
                        });
                    }
                } )
                .catch( (error) => {
                    reject(error);
                } )
        } )
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