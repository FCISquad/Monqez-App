const User = require("./user");
const normalUser = require('../User/normalUser');
const helper = require('../../Tools/requestFunctions');

const sphericalGeometry = require('spherical-geometry-js');
const max_distance = 1000; // 1 Km = 1000 Meter

class HelperUser extends User {
    constructor(userJson) {
        super(userJson);
    }

    submitApplication(userId, userObject) {
        return new Promise((resolve, reject) => {
            User._database.createUser(userId, userObject)
                .then(() => {
                    User._database.changeToMonqez(userId, userObject)
                        .then(() => {
                            resolve();
                        })
                        .catch((error) => {
                            reject(error);
                        })
                })
                .catch((error) => {
                    reject(error);
                })
        });
    }

    setStatus(userID, status) {
        return new Promise((resolve, reject) => {
            User._database.setHelperStatus(userID, status)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                })
        });
    }

    getState(userID) {
        return new Promise((resolve, reject) => {
            User._database.getMonqezState(userID)
                .then((status) => {
                    resolve(status);
                })
                .catch((error) => {
                    reject(error);
                })
        });
    }

    updateLocation(userID, userJson) {
        User._database.updateLocation(userID, userJson);
    }

    requestDecline(monqezId, userJson) {
        return new Promise((resolve, reject) => {
            User._database.requestDecline(monqezId, userJson)
                .then((allDecline) => {
                    resolve(allDecline);
                })
                .catch((err) => {
                    reject(err);
                });
        });
    }

    requestAccept(monqezId, userJson) {
        return new Promise(((resolve, reject) => {
            User._database.getProfile(monqezId)
                .then(function (snapShot) {
                    User._database.requestAccept(monqezId, snapShot["name"], userJson)
                        .then(() => {
                            resolve();
                        })
                        .catch(() => {
                            reject()
                        });
                })
                .catch(function (error) {
                    reject(error);
                })
        }));
    }

    rerequest(userJson) {
        let user = new normalUser(userJson);
        user.getLongLat(userJson["uid"]).then((locationJson) => {

            if (locationJson['isFirst'] === false) {
                const payload = {
                    notification: {
                        title: 'No monqez nearby',
                        body: 'We apologize, there is no available monqez nearby'
                    },
                    data: {
                        type: 'normal',
                        description: 'timeout'
                    }
                };

                const options = {
                    priority: 'high',
                    timeToLive: 60 * 60
                };

                helper.send_notifications(
                    userJson["uid"],
                    payload,
                    options
                );
            } else {
                user.request(userJson["uid"], locationJson, false)
                    .then(() => {
                    })
                    .catch(() => {
                        }
                    );
            }
        });
    }

    getCalls() {
        return new Promise((resolve, _) => {
            User._database.getCalls().then((snapShot) => {
                resolve(snapShot);
            })
        })
    }

    acceptCall(monqezId, userJson) {
        return new Promise(((resolve, reject) => {
            User._database.callAccept(monqezId, userJson)
                .then(() => {
                    resolve()
                })
                .catch(() => {
                    reject()
                });
        }));
    }

    get_additional_information(userId) {
        return new Promise((resolve, _) => {
            User._database.getAdditionalInfo(userId).then((additionalInfo) => {
                resolve(additionalInfo);
            })
        });
    }

    logCallRequest(userJson) {
        return new Promise((resolve, _) => {
            User._database.archiveCallRequest(userJson).then(() => {
                resolve()
            });
        });
    }

    getRequests(monqezId) {
        return new Promise((resolve, reject) => {
            User._database.getRequestsHelper(monqezId)
                .then(function (snapShot) {
                    resolve(snapShot);
                })
                .catch(function (error) {
                    reject(error);
                })
        });
    }


    async getRequestBody(userId, time) {
        return await User._database.getRequestBody(userId, time);
    }

    async getUser(userId) {
        return await User._database.getuser(userId);
    }

    cancel_request(userId) {
        return new Promise((resolve, reject) => {
            User._database.cancel_request_helper(userId).then(function () {
                resolve();
            }).catch(function (error) {
                reject(error);
            })
        });
    }

    complete_request(userJson, monqezId) {
        return new Promise((resolve, reject) => {
            User._database.getLongLat(userJson["uid"]).then(function (snapshot) {
                let normalUserLocation = [snapshot["latitude"], snapshot["longitude"]];
                let monqezUserLocation = [userJson["latitude"], userJson["longitude"]];
                let distance = sphericalGeometry.computeDistanceBetween(monqezUserLocation, normalUserLocation);

                if (distance <= max_distance) {
                    User._database.complete_request_helper(userJson["uid"], monqezId).then(function () {
                        resolve();
                    }).catch(function (error) {
                        reject(error);
                    });
                } else {
                    reject('Complete request in other location');
                }
            });
        });
    }
}

module.exports = HelperUser;