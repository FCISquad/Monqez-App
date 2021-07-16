const admin = require('firebase-admin');
const mailer = require('../Tools/nodeMailer');

class Database {
    checkNationalId(userId, nationalId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('oneTimeRequest/' + nationalId).once("value")
                .then(function (snapshot) {
                    if (snapshot.val() === null) {
                        admin.database().ref('oneTimeRequest/' + nationalId).set("").then(() => {
                        });

                        admin.database().ref('user/' + userId).update({
                            "name": "One Time Request",
                            "national_id": nationalId,
                            "phone": "011111",
                            "gender": "male",
                            "birthdate": "1111-11-11 00:00:00.0",
                            "country": " ",
                            "city": " ",
                            "street": " ",
                            "buildNumber": " ",
                            "chronicDiseases": " ",
                            "type": "0"
                        })
                            .then(() => {
                                resolve();
                            })
                            .catch((error) => {
                                reject(error);
                            });

                        resolve();
                    } else {
                        reject('free requests is used');
                    }
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }

    createUser(userId, userObject) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userId).update({
                "name": userObject["name"],
                "national_id": userObject["national_id"],
                "phone": userObject["phone_number"],
                "gender": userObject["gender"],
                "birthdate": userObject["dob"],
                "country": userObject["country"],
                "city": userObject["city"],
                "street": userObject["street"],
                "buildNumber": userObject["buildNumber"],
                "chronicDiseases": userObject["chronicDiseases"],
                "type": "0"
            })
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                });
        });
    }

    changeToMonqez(userId, userObject) {
        return new Promise((resolve, reject) => {
            admin.database().ref('monqez/' + userId).update({
                certificate: userObject["certificate"],
                certificateName: userObject["certificateName"],
                sum: 0,
                total: 0,
                points: 0
            }).catch((error) => {
                reject(error);
            });

            admin.database().ref('user/' + userId).update({
                "type": "1",
                "disable": "true"
            }).catch((error) => {
                reject(error);
            });
            admin.database().ref('applicationQueue/' + userId).update({
                "date": userObject["submissionDate"]
            }).catch((error) => {
                reject(error);
            });
            resolve();
        });

    }

    getApplicationQueue(callback) {
        admin.database().ref('applicationQueue/').orderByChild("date")
            .once("value", function (snapShot) {
                admin.database().ref('user/').once("value", function (tableJson) {
                    let table = [];
                    snapShot.forEach(function (snap) {
                        table.push({
                            "name": tableJson.child("/" + snap.key).val().name,
                            "date": snap.val().date,
                            "uid": snap.key
                        });
                    });
                    callback(JSON.stringify(table));
                }).then(() => {
                });
            })
            .then(() => {
            });
    }

    saveInstructions(adminID, instructionJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('injuries').update({
                injuries: instructionJson,
                edited_by: adminID
            }).then(() => {
                resolve();
            }).catch((error) => {
                reject(error);
            });
        });
    }

    getState() {
        return new Promise(((resolve, reject) => {
            this.getAllComplaints().then(function (complaints) {
                admin.database().ref('applicationQueue/')
                    .once("value")
                    .then(async (snapshot) => {
                        resolve({
                            "snapshot": snapshot.numChildren(),
                            "complaints": complaints.length
                        });
                    })
                    .catch((error) => {
                        reject(error);
                    })
            });

        }));
    }

    getMonqezState(userID) {
        async function getCallQueueSize() {
            return await admin.database().ref('callsQueue/').once("value")
                .then(function (snapShot) {
                    return Object.keys(snapShot.val()).length;
                })
                .catch(function () {
                    return 0;
                });
        }

        return new Promise((resolve, reject) => {
            admin.database().ref('monqez/' + userID)
                .once("value")
                .then(async function (userInfo) {
                    let callNumber = await getCallQueueSize();

                    resolve({
                        "status": userInfo.val()["status"],
                        "sum": userInfo.val()["sum"],
                        "total": userInfo.val()["total"],
                        "points": userInfo.val()["points"],
                        "calls": callNumber
                    })
                })
                .catch((error) => {
                    reject(error);
                })
        });
    }

    getUserType(userID) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).once("value")
                .then(function (snapShot) {
                    if (snapShot.val()["type"] === "0") {
                        resolve("normal");
                    } else if (snapShot.val()["type"] === "1") {
                        resolve("helper");
                    } else {
                        resolve("admin");
                    }
                })
                .catch(function (error) {
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
                        if (userInfo.val()["type"] === "2") {
                            resolve({
                                type: userInfo.val()["type"],
                                isDisabled: userInfo.val()["disable"],
                                firstLogin: userInfo.val()["firstLogin"]
                            });
                        } else {
                            resolve({
                                type: userInfo.val()["type"],
                                isDisabled: userInfo.val()["disable"],
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
            }).then(() => {});
        }).then(() => {});
    }

    getProfile(userID) {
        return new Promise(((resolve, reject) => {
            admin.database().ref('user/' + userID)
                .once("value")
                .then((userInfo) => {
                    resolve({
                        "name": userInfo.val()["name"],
                        "national_id": userInfo.val()["national_id"],
                        "phone": userInfo.val()["phone"],
                        "birthdate": userInfo.val()["birthdate"],
                        "country": userInfo.val()["country"],
                        "city": userInfo.val()["city"],
                        "street": userInfo.val()["street"],
                        "buildNumber": userInfo.val()["buildNumber"],
                        "gender": userInfo.val()["gender"],
                        "image": userInfo.val()["image"],
                        "chronicDiseases": userInfo.val()["chronicDiseases"]
                    });
                })
                .catch((error) => {
                    reject(error);
                })
        }));
    }

    banUser(userId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userId).transaction(function (snapShot) {
                if (snapShot !== null) {
                    snapShot["disable"] = "true";
                }
                return snapShot;
            })
                .then(function () {
                    resolve();
                })
                .catch(function (error) {
                    reject(error);
                });
        });
    }

    sendWarining(complaintObject) {
        return new Promise((resolve, reject) => {
            admin.database().ref('complaints/' + complaintObject["complaintID"] + '/' + complaintObject["complainedUID"])
                .limitToLast(1).once('value')
                .then(function (snapshot) {
                    snapshot.forEach(function (childSnapshot) {
                        admin.auth().getUser(complaintObject["complainedUID"])
                            .then((userData) => {
                                let mailSubject = childSnapshot.val()["subject"];
                                let mailBody = childSnapshot.val()["subject"];

                                mailer.sendMail(userData.email, mailSubject, mailBody)
                                    .then(() => {
                                    }).catch(() => {
                                });
                            });
                    });
                    resolve();
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }

    archiveComplaint(complaintObject) {
        return new Promise((resolve, reject) => {
            admin.database().ref('complaints/' + complaintObject["complaintID"] + '/' + complaintObject["complainedUID"] + '/' + complaintObject["date"])
                .transaction(function (snapshot) {
                    if (snapshot !== null) {
                        admin.database().ref('complaintsArchive/').update(snapshot)
                            .then(function () {
                            })
                            .catch(function (error) {
                                reject(error);
                            })
                    }
                    return snapshot;
                })
                .then(function () {
                    admin.database().ref('complaints/' + complaintObject["complaintID"] + '/' + complaintObject["complainedUID"] + '/' + complaintObject["date"]).remove();
                    resolve();
                })
                .catch(function (error) {
                    reject(error);
                })
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
            if (status !== 'Available') {
                admin.database().ref('activeMonqez/' + userID).remove().then(() => {
                });
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

    editAccount(userID, userObject) {
        return new Promise((resolve, reject) => {
            admin.database().ref('user/' + userID).update({
                "name": userObject["name"],
                "national_id": userObject["national_id"],
                "phone": userObject["phone"],
                "gender": userObject["gender"],
                "birthdate": userObject["birthdate"],
                "country": userObject["country"],
                "city": userObject["city"],
                "street": userObject["street"],
                "buildNumber": userObject["buildNumber"],
                "image": userObject["image"],
                "chronicDiseases": userObject["chronicDiseases"]
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
        return new Promise((resolve, reject) => {
            admin.database().ref('applicationQueue/' + applicationJSON.userID).transaction(function (snapshot) {
                if (snapshot !== null) {
                    admin.database().ref('applicationApproval/' + applicationJSON.userID)
                        .set({
                            "adminUID": adminID,
                            "date": applicationJSON.date,
                            "result": applicationJSON.result
                        })
                        .then(() => {
                        });

                    if (applicationJSON.result === 'true') {
                        admin.database().ref('user/' + applicationJSON.userID).update({
                            "disable": "false"
                        }).then(() => {
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
                return snapshot;
            })
                .then(function () {
                    resolve();
                })
                .catch(function (error) {
                    reject("Application not founded");
                })
        });
    }

    deleteApplication(applicationJSON) {
        admin.database().ref('applicationQueue/' + applicationJSON.userID).remove()
            .then(() => {
            })
            .catch(() => {
            });
    }

    updateLocation(userID, userJson) {
        admin.database().ref('activeMonqez/' + userID).update({
            "longitude": userJson["longitude"],
            "latitude": userJson["latitude"]
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

    insertRequest(uid, request, monqezCounter, isFirst) {
        if (isFirst === true) {
            let date_ob = new Date();

            let date = ("0" + date_ob.getDate()).slice(-2);
            let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            let year = date_ob.getFullYear();
            let hours = ("0" + date_ob.getHours()).slice(-2);
            let minutes = ("0" + date_ob.getMinutes()).slice(-2);
            let seconds = ("0" + date_ob.getSeconds()).slice(-2);
            let timeID = year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;

            admin.database().ref('requests/' + uid + '/' + timeID)
                .update(request)
                .then(() => {
                    admin.database().ref('requests/' + uid + '/' + timeID + '/' + "rejected").set({"counter": 0}).then(() => {
                    });
                    admin.database().ref('requests/' + uid + '/' + timeID + '/' + "accepted").set({"counter": 0}).then(() => {
                    });
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"monqezCounter": monqezCounter}).then(() => {
                    });
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"isFirst": true}).then(() => {
                    });
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"longitude": request["longitude"]}).then(() => {
                    });
                    admin.database().ref('requests/' + uid + '/' + timeID).update({"latitude": request["latitude"]}).then(() => {
                    });

                });
        } else {
            admin.database().ref('requests/' + uid).limitToLast(1).once('value')
                .then(function (snapshot) {
                    snapshot.forEach(function (childSnapshot) {
                        admin.database().ref('requests/' + uid + '/' + childSnapshot.key)
                            .update({
                                "monqezCounter": monqezCounter,
                                "rejected/counter": 0,
                                "isFirst": false
                            })
                            .then(() => {
                            });
                    });
                });
        }
    }

    insertRequestAdditional(uid, request) {
        admin.database().ref('requests/' + uid).limitToLast(1).once('value')
            .then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    admin.database().ref('requests/' + uid + '/' + childSnapshot.key)
                        .update(request)
                        .then(() => {
                        });
                });
            });
    }

    getRequests(userID) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userID).once("value", function (snapshot) {
                resolve(snapshot.val());
            }).catch((error) => {
                reject(error);
            });
        });
    }

    getRequestsHelper(helperId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('monqezRequests/' + helperId).once("value", function (snapshot) {
                resolve(snapshot.val());
            }).catch((error) => {
                reject(error);
            });
        });
    }

    requestDecline(monqezId, userJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userJson["uid"]).limitToLast(1).once('value')
                .then(function (snapshot) {
                    snapshot.forEach(function (childSnapshot) {
                        let allDecline = false;
                        admin.database().ref('requests/' + userJson["uid"] + '/' + childSnapshot.key).transaction(function (current_value) {
                            if (current_value !== null) {

                                if (current_value["status"] === 'closed') {
                                    reject('closed');
                                } else {
                                    current_value["rejected"]["counter"]++;
                                    current_value["rejected"]['uid_' + current_value["rejected"]["counter"]] = monqezId;
                                    if (current_value["rejected"]["counter"] === current_value["monqezCounter"]) {
                                        allDecline = true;

                                        if (current_value["isFirst"] === false && allDecline === true) {
                                            current_value["status"] = "closed";
                                        }
                                    }
                                }
                            }
                            return current_value;
                        }).then(() => {
                            resolve(allDecline);
                        })
                            .catch(() => {
                                reject()
                            });

                    });
                });
        });

    }

    requestAccept(monqezId, monqezName, userJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userJson["uid"]).limitToLast(1).once('value')
                .then(function (snapshot) {
                    snapshot.forEach(function (childSnapshot) {
                        admin.database().ref('requests/' + userJson["uid"] + '/' + childSnapshot.key)
                            .transaction(function (current_value) {
                                if (current_value !== null) {
                                    if (current_value["status"] === 'closed' || current_value["status"] === 'cancelled') {
                                        reject('closed');
                                    } else {
                                        if (current_value["accepted"]["counter"] === 1) {
                                            reject();
                                        } else {
                                            current_value["accepted"]["counter"]++;
                                            current_value["accepted"]['uid_' + current_value["counter"]] = monqezId;
                                            current_value["status"] = "Accepted";
                                            current_value["accepted"]["name"] = monqezName;

                                            admin.database().ref('monqezRequests/' + monqezId + '/' + userJson["uid"])
                                                .push(childSnapshot.key)
                                                .then(() => {
                                                    resolve();
                                                })
                                                .catch(function (error) {
                                                    reject(error);
                                                });
                                        }
                                    }
                                }

                                return current_value;
                            }).then(() => {
                            resolve()
                        });
                    });
                });
        });
    }

    requestAcceptCount(userID) {
        return new Promise((resolve, _) => {
            admin.database().ref('requests/' + userID).limitToLast(1).once('value')
                .then(function (snapshot) {
                    snapshot.forEach(function (childSnapshot) {
                        admin.database().ref('requests/' + userID + '/' + childSnapshot.key + '/' + "accepted")
                            .transaction(function (current_value) {
                                if (current_value !== null) {
                                    resolve(current_value["counter"]);
                                }
                                return current_value;
                            })
                            .then(() => {
                            });
                    });
                });
        });
    }

    getLongLat(uid) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + uid).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    resolve(snapshot.val()[childSnapshot.key]);
                });
            });
        });
    }

    insertCall(userId, dataJson) {
        return new Promise((resolve, _) => {
            let date_ob = new Date();

            let date = ("0" + date_ob.getDate()).slice(-2);
            let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            let year = date_ob.getFullYear();
            let hours = ("0" + date_ob.getHours()).slice(-2);
            let minutes = ("0" + date_ob.getMinutes()).slice(-2);
            let seconds = ("0" + date_ob.getSeconds()).slice(-2);
            let timeID = year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;

            dataJson["channelId"] = userId + "_" + date_ob.getTime().toString();
            dataJson["date"] = timeID;

            admin.database().ref('user/' + userId).once("value", function (snapShot) {
                dataJson["name"] = snapShot.val()["name"];
                admin.database().ref('callsQueue/' + userId).update(dataJson).then(() => {
                });
                resolve(dataJson["channelId"]);
            });
        });
    }

    getCalls() {
        return new Promise((resolve, _) => {
            admin.database().ref('callsQueue/').orderByChild("date").limitToLast(20)
                .once("value", function (snapshot) {
                    let table = [];
                    table.push(snapshot.val());
                    resolve(JSON.stringify(table));
                }).then(() => {
            });
        });
    }

    callAccept(monqezId, userJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('callsQueue/' + userJson["uid"]).transaction(function (current_value) {
                if (current_value !== null) {
                    if (current_value["status"] === "Accepted") {
                        reject();
                    } else {
                        current_value["status"] = "Accepted";
                        current_value["monqezId"] = monqezId;
                        resolve();
                    }
                }
                return current_value;
            }).then(() => {
            })
                .catch(() => {
                });

        });
    }

    getAdditionalInfo(userId) {
        return new Promise((resolve, _) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    resolve(snapshot.val()[childSnapshot.key]["additionalInfo"]);
                });
            });
        });
    }

    cancel_request(userId) {
        return new Promise((resolve, _) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    admin.database().ref('requests/' + userId + '/' + childSnapshot.key)
                        .update({"status": "cancelled"}).then(function () {
                        resolve()
                    })
                });
            });
        });
    }

    archiveCallRequest(userJson) {
        return new Promise((resolve, _) => {
            let date_ob = new Date();

            let date = ("0" + date_ob.getDate()).slice(-2);
            let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
            let year = date_ob.getFullYear();
            let hours = ("0" + date_ob.getHours()).slice(-2);
            let minutes = ("0" + date_ob.getMinutes()).slice(-2);
            let seconds = ("0" + date_ob.getSeconds()).slice(-2);
            let timeID = year + "-" + month + "-" + date + " " + hours + ":" + minutes + ":" + seconds;

            admin.database().ref('callsQueue/' + userJson["uid"]).once("value")
                .then(function (snapshot) {
                    admin.database().ref('callsArchive/' + userJson["uid"] + '/' + timeID)
                        .update(snapshot.val())
                        .then(() => {
                        });

                    admin.database().ref('callsQueue/' + userJson["uid"]).remove()
                        .then(() => {
                        });

                    resolve()
                });
        });
    }

    callOut(userId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('callsQueue/' + userId).transaction(function (current_value) {
                if (current_value !== null) {
                    if (current_value["status"] === "Accepted") {
                        reject();
                    } else {
                        current_value["status"] = "not responding";
                        resolve();
                    }
                }
                return current_value;
            })
                .then(() => {
                })
                .catch(() => {
                });

        });
    }

    setRequestRate(uid, json) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + uid + '/' + json["time"] + '/' + 'ratingInfo/')
                .update({"rate": json["ratingInfo"]["rate"], "comment": json["ratingInfo"]["comment"]})
                .then(function () {
                    resolve();
                })
                .catch(function (error) {
                    reject(error);
                });
        });
    }

    setMonqezRate(json) {
        return new Promise((resolve, reject) => {
            admin.database().ref('monqez/' + json["uid"]).transaction(function (current_value) {
                if (current_value !== null) {
                    current_value["sum"] = current_value["sum"] + json["ratingInfo"]["rate"];
                    current_value["total"] = current_value["total"] + 1;
                }
                return current_value;
            })
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error)
                });
        });
    }

    addComplaint(userId, json) {
        return new Promise((resolve, reject) => {

            let uid = json["uid"];
            delete json["uid"];

            let time = json["time"];
            delete json["time"];

            admin.database().ref('complaints/' + userId + '/' + uid + '/' + time).set(json)
                .then(function () {
                    resolve();
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }

    async getRequestBody(normalUserId, time) {
        return await admin.database().ref('requests/' + normalUserId + '/' + time).once("value")
            .then(function (snapShot) {
                return snapShot.val();
            })
    }

    async getuser(userId) {
        return await admin.database().ref('user/' + userId).once("value")
            .then(function (snapShot) {
                return snapShot.val();
            })
    }

    getAllComplaints() {
        async function getNormalName(normalUid) {
            return await admin.database().ref('user/' + normalUid).once("value")
                .then(function (snapShot) {
                    return snapShot.val()["name"];
                });
        }

        return new Promise((resolve, reject) => {
            admin.database().ref('complaints').once("value")
                .then(async function (snapShot) {
                    let complaints = [];

                    for (let normalUid in snapShot.val()) {
                        let name = await getNormalName(normalUid);

                        for (let helperUid in snapShot.val()[normalUid]) {
                            for (let time in snapShot.val()[normalUid][helperUid]) {

                                let currentComp = {
                                    "nuid": normalUid,
                                    "huid": helperUid,
                                    "date": time,
                                    "name": name
                                };

                                complaints.push(currentComp);
                            }
                        }
                    }
                    resolve(complaints);
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }

    getComplaint(compJson) {
        return new Promise((resolve, reject) => {
            admin.database().ref('complaints/' + compJson["nuid"] + '/' + compJson["huid"] + '/' + compJson["date"]).once("value")
                .then(function (complaint) {
                    resolve(complaint.val());
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }

    getInstructions() {
        return new Promise(((resolve, reject) => {
            admin.database().ref('injuries/')
                .once("value", function (snapshot) {
                    resolve(JSON.stringify(snapshot));
                })
                .then((userInfo) => {
                })
                .catch((error) => {
                    reject(error);
                })
        }));
    }

    isCancelled(userId) {
        return new Promise((resolve, _) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {
                    resolve(snapshot.val()[childSnapshot.key]["status"]);
                });
            });
        });
    }

    cancel_request_helper(userId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {

                    admin.database().ref('requests/' + userId + '/' + childSnapshot.key).update({"status": "cancelled"})
                        .then(function () {
                            resolve();
                        })
                        .catch(function (error) {
                            reject(error);
                        });
                });
            }).catch(function (error) {
                reject(error);
            });
        });
    }

    complete_request_helper(userId, monqezId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {

                    admin.database().ref('monqez/' + monqezId).once("value").then(function (snapshot) {
                        admin.database().ref('monqez/' + monqezId).update({"points": snapshot.val()["points"] + 100})
                            .then(function () {
                            });
                    }).catch(function (error) {
                        reject(error);
                    })

                    admin.database().ref('requests/' + userId + '/' + childSnapshot.key).update({"status": "completed"})
                        .then(function () {
                            resolve();
                        })
                        .catch(function (error) {
                            reject(error);
                        });
                });
            }).catch(function (error) {
                reject(error);
            });
        });
    }

    validRequest(userId) {
        return new Promise((resolve, reject) => {
            admin.database().ref('requests/' + userId).limitToLast(1).once('value').then(function (snapshot) {
                snapshot.forEach(function (childSnapshot) {

                    if (snapshot.val()[childSnapshot.key]["status"] === null) {
                        reject();
                    } else if (snapshot.val()[childSnapshot.key]["status"] === "Accepted") {
                        reject();
                    } else {
                        resolve();
                    }
                });
            }).catch(function (error) {
                resolve();
            })
        });
    }

}

module.exports = Database;












