const admin = require('firebase-admin');
const mailer = require('../Tools/nodeMailer');

class Database {
    createUser(userObject) {
        return new Promise((resolve, reject) => {
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
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                });
        });
    }

    changeToMonqez(userObject, subDate) {
        admin.database().ref('monqez/' + userObject.userID).set({
            certificate: userObject.certificate,
            certificateName: userObject.certificateName
        }).then(() => {
        });
        admin.database().ref('user/' + userObject.userID).update({
            "type": "1",
            "disable": "true"
        }).then(() => {
        });
        admin.database().ref('applicationQueue/' + userObject.userID).set({
            "date": subDate
        }).then(() => {
        });
    }

    getApplicationQueue(callback) {
        admin.database().ref('applicationQueue/').orderByChild("date")
            .once("value", function (snapShot) {
                admin.database().ref('user/').once("value", function (tableJson) {
                    let table = [];
                    snapShot.forEach(function (snap) {
                        // console.log(tableJson.child("/" + snap.key).val());
                        table.push({
                            "name": tableJson.child("/" + snap.key).val().name,
                            "date": snap.val().date,
                            "uid": snap.key
                        });
                    });
                    console.log(table);
                    callback(JSON.stringify(table));
                }).then(() => {
                });
            })
            .then(() => {
            });
    }

    getState() { //to be continued
        return new Promise(((resolve, reject) => {
            admin.database().ref('applicationQueue/')
                .once("value")
                .then((snapshot) => {
                    resolve({
                        snapshot: snapshot.numChildren()
                    });
                })
                .catch((error) => {
                    reject(error);
                })
        }));
    }

    getMonqezState(userID) { //to be continued
        return new Promise((resolve, reject) => {
            admin.database().ref('monqez/' + userID)
                .once("value")
                .then((userInfo) => {
                    resolve({
                        status: userInfo.val().status
                    })
                })
                .catch((error) => {
                    reject(error);
                })
        });
    }

    getUser(userID) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID)
                .once("value")
                .then((userInfo) => {
                    if (userInfo.val() === null) {
                        resolve({
                            type: "-1",
                            isDisabled: "false",
                            firstLogin: "true"
                        });
                    } else {
                        if (userInfo.val().type === "2") {
                            resolve({
                                type: userInfo.val().type,
                                isDisabled: userInfo.val().disable,
                                firstLogin: userInfo.val().firstLogin
                            });
                        } else {
                            resolve({
                                type: userInfo.val().type,
                                isDisabled: userInfo.val().disable,
                                firstLogin: "false"
                            });
                        }
                    }
                })
                .catch((error) => {
                    reject(error);
                })
        })
    }

    getApplication(userID, callback) {
        admin.database().ref('user/' + userID).once("value", function (userData) {
            admin.database().ref('monqez/').once("value", function (monqez) {
                let json = userData.val();
                json.certificate = monqez.child(userID).val().certificate;
                admin.auth().getUser(userID).then((userData) => {
                    json.email = userData.email;
                    callback(json);
                })
            }).then(() => {
            });
        }).then(() => {
        });
    }

    getProfile(userID) {
        return new Promise(((resolve, reject) => {
            admin.database().ref('user/' + userID)
                .once("value")
                .then((userInfo) => {
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
                })
                .catch((error) => {
                    reject(error);
                })
        }));
    }

    getCertificate(userID) {
        return new Promise((resolve, reject) => {
            admin.database().ref('monqez/' + userID).once("value")
                .then((certificate) => {
                    resolve(certificate.val());
                })
                .catch((error) => {
                    reject(error);
                });
        });
    }

    addAdmin(userID, databaseJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).set(databaseJson)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                });
        });
    }

    addAdminAdditionalInformation(userID, databaseJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).update(databaseJson)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                });
        });

    }

    setHelperStatus(userID, status) {
        return new Promise((resolve, reject) => {
            if (status !== 'Available'){
                admin.database().ref('activeMonqez/' + userID).remove().then(()=>{});
            }

            admin.database().ref('monqez/' + userID).update({
                "status": status
            }).then(() => {
                resolve();
            }).catch((error) => {
                reject(error);
            });
        });
    }

    editAccount(userID, userInfo) {
        return new Promise((resolve, reject) => {
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
            }).then(() => {
                resolve();
            }).catch((error) => {
                reject(error);
            });
        });
    }

    registerToken(userID, registrationToken) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).update({
                "token": registrationToken["token"]
            }).then(() => {
                resolve();
            }).catch((error) => {
                reject(error);
            });
        });
    }

    setApproval(adminID, applicationJSON) {
        admin.database().ref('applicationApproval/' + applicationJSON.userID)
            .set({
                "adminUID": adminID,
                "date": applicationJSON.date,
                "result": applicationJSON.result
            })
            .then(() => {
            });
        admin.database().ref('applicationQueue/' + applicationJSON.userID).remove().then(() => {
        });
        if (applicationJSON.result === 'true') {
            admin.database().ref('user/' + applicationJSON.userID).update({
                "disable": "false"
            })
                .then(() => {
                });
        }
        admin.database().ref('monqez/' + applicationJSON.userID).update({
            "status": "Busy"
        }).then(() => {
        });
        admin.auth().getUser(applicationJSON.userID)
            .then((userData) => {
                let mailSubject = 'Monqez Team - Application Approval';
                let mailBody = applicationJSON.result;
                mailer.sendMail(userData.email, mailSubject, mailBody)
                    .then(() => {
                    }).catch(() => {
                });
            });
    }

    updateLocation(userID, longitude, latitude) {
        admin.database().ref('activeMonqez/' + userID).update({
            "longitude": longitude,
            "latitude": latitude
        }).then(() => {
        });
    }

    getAllActiveMonqez() {
        return new Promise((resolve, reject) => {
            admin.database().ref('/activeMonqez').once("value", function (snapshot) {
                resolve(snapshot);
            }).catch((error) => {
                reject(error);
            });
        });
    }

    getFCMToken(userID) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).once("value", function (snapshot) {
                resolve(snapshot.val()["token"]);
            }).catch((error) => {
                reject(error);
            });
        });
    }

    insertRequest(uid, request, monqezCounter, isFirst){
        if ( isFirst === true ){
            let date_ob = new Date();

            let date    = ("0" + date_ob.getDate()).slice(-2);
            let month   = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            let year    = date_ob.getFullYear();
            let hours   = date_ob.getHours();
            let minutes = date_ob.getMinutes();
            let seconds = date_ob.getSeconds();
            let timeID  = year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;

            admin.database().ref('requests/' + uid + '/' + timeID)
                .update(request)
                .then( () => {
                    admin.database().ref('requests/' + uid + '/' + timeID + '/' + "rejected").set({"counter" : 0}).then(() => {});
                    admin.database().ref('requests/' + uid + '/' + timeID + '/' + "accepted").set({"counter" : 0}).then(() => {});
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"monqezCounter" : monqezCounter}).then(() => {});
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"re-request" : false}).then(() => {});
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"longitude" : request["longitude"]}).then(() => {});
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"latitude" : request["latitude"]}).then(() => {});
                } ) ;
        }
        else{
            admin.database().ref('requests/' + uid).limitToLast(1).once('value')
                .then(function(snapshot) {
                    snapshot.forEach(function(childSnapshot) {
                        admin.database().ref('requests/' + uid + '/' + childSnapshot.key)
                            .update({
                                "monqezCounter": monqezCounter,
                                "rejected/counter" : 0
                            })
                            .then( () => {} ) ;
                        //console.log(childSnapshot.key);
                    });
                });
        }
    }

    insertRequestAdditional(uid, request) {
        console.log(request);
        admin.database().ref('requests/' + uid).limitToLast(1).once('value')
            .then(function(snapshot) {
                snapshot.forEach(function(childSnapshot) {
                    admin.database().ref('requests/' + uid + '/' + childSnapshot.key)
                    .update(request)
                    .then( () => {} ) ;
                    //console.log(childSnapshot.key);
                });
            });
    }

    getRequests(userID){
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userID).once("value", function (snapshot) {
                resolve(snapshot.val());
            }).catch((error) => {
                reject(error);
            });
        });
    }

    requestDecline(monqezId, userJson){
        return new Promise( (resolve, reject) => {
            admin.database().ref('requests/' + userJson["uid"]).limitToLast(1).once('value')
                .then(function(snapshot) {
                    snapshot.forEach(function(childSnapshot) {
                        let allDecline = false;
                        admin.database().ref('requests/' + userJson["uid"] + '/' + childSnapshot.key).transaction(function(current_value){
                                current_value["rejected"]["counter"]++;
                                current_value["rejected"]['uid_' + current_value["counter"]] = monqezId;
                                if ( current_value["rejected"]["counter"] === current_value["monqezCounter"] ){
                                    allDecline = true;
                                }
                                return current_value;
                            }).then(() => {
                                resolve(allDecline);
                            })
                            .catch(() => {reject()});

                    });
                });
        } );

    }

    requestAccept(monqezId, userJson){
        return new Promise( (resolve, reject) => {
            admin.database().ref('requests/' + userJson["uid"]).limitToLast(1).once('value')
                .then(function(snapshot) {
                    snapshot.forEach(function(childSnapshot) {
                        console.log('requests/' + userJson["uid"] + '/' + childSnapshot.key + '/' + "accepted");
                        admin.database().ref('requests/' + userJson["uid"] + '/' + childSnapshot.key + '/' + "accepted")
                            .transaction(function(current_value){
                                if ( current_value !== null ){
                                    if ( current_value["counter"] === 1 ){
                                        reject();
                                    }
                                    else{
                                        current_value["counter"]++;
                                        current_value['uid_' + current_value["counter"]] = monqezId;
                                    }
                                }

                                return current_value;
                            }).then(() => {resolve()});
                    });
                });
        } );
    }


    getLongLat(uid){
        return new Promise( (resolve, reject) => {
            admin.database().ref('requests/' + uid).limitToLast(1).once('value').then(function(snapshot) {
                        resolve(snapshot);
                    });
        });
    }
}

module.exports = Database;
