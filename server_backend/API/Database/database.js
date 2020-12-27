const admin = require('firebase-admin')
class Database{
    createUser(userObject){
        return new Promise( (resolve, reject) => {
            admin.database().ref('user/' + userObject.userID).set({
                name: userObject.userName,
                national_id: userObject.userNatSionalID,
                phone: userObject.userPhoneNumber,
                gender: userObject.userGender,
                birthdate: userObject.userDOB,
                country: userObject.userAddress.country,
                city: userObject.userAddress.city,
                street: userObject.userAddress.street,
                buildNumber: userObject.userAddress.buildNumber,
                chronicDiseases: "",
                type: "0"
            })
                .then(() => { resolve(); })
                .catch((error) => { reject(error); });
        } );
    }

    changeToMonqez(userObject){
        admin.database().ref('monqez/' + userObject.userID).set({
            certificate: userObject.certificate,
            certificateName: userObject.certificateName
        }).then( () => {} );
        admin.database().ref('user/' + userObject.userID).update({
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

    getCertificate(userID){
        return new Promise( (resolve, reject) => {
            admin.database().ref('monqez/' + userID).once("value")
                .then( (certificate) => {
                    resolve(certificate.val());
                } )
                .catch( (error) => {
                    reject(error);
                });
        } );
    }
}

module.exports = Database;