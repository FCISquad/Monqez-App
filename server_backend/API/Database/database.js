const admin = require('firebase-admin')
class Database{
    createUser(userObject){
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

    getApplicationQueue() {
    admin.database().ref('applicationQueue/').orderByChild("date").once("value", function(snapshot) {
        console.log(snapshot.numChildren());
        snapshot.forEach(snap => {
            const issue = snap.val();
            // More code but we don't need to see it here
            console.log(issue);
        });
    }).then(() => {});
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
                        if (userInfo.val().type === "2"){
                            resolve({
                                type: userInfo.val().type,
                                isDisabled: userInfo.val().disable,
                                firstLogin: userInfo.val().firstLogin
                            });
                        }
                        else{
                            resolve({
                                type: userInfo.val().type,
                                isDisabled: userInfo.val().disable,
                                firstLogin: "false"
                            });
                        }
                    }
                } )
                .catch( (error) => {
                    reject(error);
                } )
        } )
    }

    getProfile(userID) {
        return new Promise(((resolve, reject) => {
            admin.database().ref( 'user/' + userID )
                .once("value")
                .then( (userInfo) => {
                    resolve({
                        name: userInfo.val().name,
                        national_id: userInfo.val().national_id,
                        phone: userInfo.val().phone,
                        birthdate: userInfo.val().birthdate,
                        country: userInfo.val().country,
                        city: userInfo.val().city,
                        street: userInfo.val().street,
                        buildNumber: userInfo.val().buildNumber,
                        gender: userInfo.val().gender
                    });
                } )
                .catch( (error) => {
                    reject(error);
                } )
        }));
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

    addAdmin(userID , databaseJson){
        return new Promise( (resolve, reject) => {
            admin.database().ref('user/' + userID).set(databaseJson)
                .then( () =>{
                    resolve();
                } )
                .catch((error) => {
                    reject(error);
                });
        } );
    }

    addAdminAdditionalInformation(userID , databaseJson){
        return new Promise( (resolve, reject) => {
            admin.database().ref('user/' + userID).update(databaseJson)
                .then( () =>{
                    resolve();
                } )
                .catch((error) => {
                    reject(error);
                });
        } );

    }

    setHelperStatus(userID , status){
        return new Promise( (resolve, reject) => {
            admin.database().ref('monqez/' + userID).update({
                "status": status
            }).then( () => {
                resolve();
            }).catch( (error) => {
                reject(error);
            } );
        } );
    }

    editAccount(userID, userInfo) {
        return new Promise( (resolve, reject) => {
            admin.database().ref('user/' + userID).update({
                name: userInfo.name,
                national_id: userInfo.national_id,
                phone: userInfo.phone,
                birthdate: userInfo.birthdate,
                country: userInfo.country,
                city: userInfo.city,
                street: userInfo.street,
                buildNumber: userInfo.buildNumber,
                gender: userInfo.gender
            }).then( () => {
                resolve();
            }).catch( (error) => {
                reject(error);
            } );
        } );
    }
}

module.exports = Database;