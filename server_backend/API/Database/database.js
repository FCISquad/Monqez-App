const admin  = require('firebase-admin')
const admin2 = require('firebase-admin')

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
    /*
                                        let obj = {
                                table: []
                            };

                            snapShot.forEach(snap => {
                                admin.database().ref('user/' + snap.key)
                                    .once("value" , (userData) => {
                                        obj.table.push({"name" : userData.val().name});
                                    })
                                    .then((userData) => {
                                        obj.table.push({"name" : userData.val().name});
                                    });
                            });
                            resolve(JSON.stringify(obj.table));
                        })


     */

    /*

              refCart.child(user_id).on("value", function(snapshot) {

              snapshot.forEach(function(childSnapshot) {
                var item_id = childSnapshot.name();
                var qty = childSnapshot.val();

                    refMenu.child(item_id).once("value", function(snapshot) {
                      var item = snapshot.val()
                      console.log(item.name +' '+ item.price)
                    });

             });

            });

     */


    getApplicationQueue(callback) {
        admin.database().ref('applicationQueue/').orderByChild("date")
            .once("value" , function (snapShot){
                callback(snapShot);
            })
            .then( () => {} );


        // return new Promise((resolve, reject) => {
        //     let obj = {
        //         table: []
        //     };
        //     admin.database().ref('applicationQueue/').orderByChild("date")
        //         .on("value" , function (snapShot){
        //            snapShot.forEach(function (child){
        //
        //                admin2.database().ref('user/' + child.key)
        //                    .once("value" , function (data){
        //                        obj.table.push({
        //                           "name": data.val().name,
        //                           "date": child.val(),
        //                           "uid": child.key
        //                        });
        //                    })
        //                    .then( () => {} );
        //            });
        //         });
        //     // resolve(JSON.stringify(obj.table));
        //     // console.log(obj.table);
        // });
    }
    async temp(userID , callback) {
        await admin.database().ref('user/' + userID).once("value" , function (userData){
            callback(userData.val().name);
        });
    }

    // getApplicationQueue() {
    //     console.log("Hererere");
    //     return new Promise((resolve, reject) => {
    //         admin.database().ref('applicationQueue/').orderByChild("date").once("value", function(snapshot) {
    //             let obj = {
    //                 table: []
    //             };
    //             snapshot.forEach(snap => {
    //                 admin.database().ref('user/' + snap.key).once("value", function (userdata) {
    //                     console.log("In loop");
    //                     obj.table.push(
    //                         {
    //                             uid: snap.key,
    //                             date: snap.val().date,
    //                             name: userdata.val().name
    //                         }
    //                     );
    //                 });
    //             });
    //             console.log("out json: " + JSON.stringify(obj.table));
    //             return JSON.stringify(obj.table);
    //         }).then((json) => {
    //             console.log("in json: " + json);
    //             resolve(json);
    //         }).catch( (error) => {
    //             reject(error);
    //         });
    //     });
    // }

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