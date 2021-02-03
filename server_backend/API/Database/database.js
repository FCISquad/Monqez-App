const admin  = require('firebase-admin')

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

    changeToMonqez(userObject , subDate){
        admin.database().ref('monqez/' + userObject.userID).set({
            certificate: userObject.certificate,
            certificateName: userObject.certificateName
        }).then( () => {} );
        admin.database().ref('user/' + userObject.userID).update({
            "type": "1",
            "disable": "true"
        }).then( () => {} );
        admin.database().ref('applicationQueue/' + userObject.userID).set({
            "date": subDate
        }).then( () => {} );
    }

    getApplicationQueue(callback) {
        admin.database().ref('applicationQueue/').orderByChild("date")
            .once("value" , function (snapShot){
                admin.database().ref('user/').once("value" , function (tableJson){
                      let table = [];
                      snapShot.forEach(function (snap){
                          // console.log(tableJson.child("/" + snap.key).val());
                         table.push({
                             "name": tableJson.child("/" + snap.key).val().name,
                             "date": snap.val().date,
                             "uid": snap.key
                         }) ;
                      });
                      console.log(table);
                      callback(JSON.stringify(table));
                }).then(()=>{});
            })
            .then( () => {} );
    }

    getState() { //to be continued
        return new Promise(((resolve, reject) => {
            admin.database().ref( 'applicationQueue/' )
                .once("value")
                .then( (snapshot) => {
                    resolve({
                        snapshot: snapshot.numChildren()
                    });
                } )
                .catch( (error) => {
                    reject(error);
                } )
        }));
    }

    getMonqezState(userID) { //to be continued
        return new Promise( (resolve, reject) => {
            admin.database().ref( 'monqez/' + userID )
                .once("value")
                .then( (userInfo) => {
                    resolve({
                        status: userInfo.val().status
                    })
                } )
                .catch( (error) => {
                    reject(error);
                } )
        });
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

    getApplication(userID , callback){
        admin.database().ref('user/' + userID).once("value" , function (userData){
            admin.database().ref('monqez/').once("value" , function (monqez){
                let json = userData.val();
                json.certificate = monqez.child(userID).val().certificate;
                callback(json);
            }).then(()=>{});
        }).then(()=>{});
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

    setApproval(adminID , applicationJSON){
        admin.database().ref('applicationApproval/' + applicationJSON.userID)
            .set({
                "adminUID" : adminID,
                "date": applicationJSON.date,
                "result": applicationJSON.result
            })
            .then(() => {});
        admin.database().ref('applicationQueue/' + applicationJSON.userID).remove().then(() => {});
        if ( applicationJSON.result === 'true' ){
            admin.database().ref('user/' + applicationJSON.userID).update({
                "disable": "false"
            })
                .then(() => {});
        }
    }
}

module.exports = Database;