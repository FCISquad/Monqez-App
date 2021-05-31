const User = require("./user");
const sphericalGeometry = require('spherical-geometry-js');
const admin = require('firebase-admin');

const max_distance = 3000; // 3 Km = 3000 Meter
const helper = require('../../Tools/RequestFunctions');

class NormalUser extends User {
    constructor(userJson) {
        super(userJson);
    }

    checkOneTimeRequest(nationalId){
        return new Promise( (resolve, reject) => {
            User._database.checkNationalId(nationalId)
                .then( function (){
                    resolve();
                } )
                .catch( function (error){
                    reject(error);
                } )
        } );
    }

    signUp(userId, userJson) {
        return new Promise( (resolve, reject) => {
            User._database.createUser(userId, userJson)
                .then(() => {resolve();})
                .catch((error) => {
                    reject(error);
                });
        } );

    }

    request(userID, userJson, isFirst) {
        return new Promise((resolve, reject) => {
            User._database.getAllActiveMonqez().then((activeMonqez) => {
                let distance = [];
                let normalUserLocation = [userJson["latitude"], userJson["longitude"]];
                for (let uid in activeMonqez.val()) {
                    let longitude = activeMonqez.val()[uid]["longitude"];
                    let latitude = activeMonqez.val()[uid]["latitude"];

                    let monqezLocation = [latitude, longitude];
                    distance.push({
                        "distance": sphericalGeometry.computeDistanceBetween(monqezLocation, normalUserLocation),
                        "uid": uid
                    });
                }

                distance.sort((a, b) => {
                    if (a['distance'] === b['distance']) {
                        return 0;
                    }
                    return (a['distance'] < b['distance'] ? -1 : 1);
                });

                let min_three = []
                min_three.push(userID);
                min_three.push(userJson["latitude"]);
                min_three.push(userJson["longitude"]);

                let minimumHelper = 3;
                if (isFirst === false){
                    minimumHelper = 6;
                }

                for (let i = 0; i < Math.min(minimumHelper, distance.length); ++i) {
                    if ( distance[i]["uid"] <= max_distance ){
                        min_three.push(distance[i]["uid"]);
                    }
                    else{
                        // to be removed
                        min_three.push(distance[i]["uid"]);
                    }
                }

                if ( min_three.length > 3 ){
                    User._database.insertRequest(userID, userJson, min_three.length - 3, isFirst);
                    this.notify_monqez(min_three);
                }
                else{
                    reject('No avilabel helpers');
                }
                resolve(min_three);
            });
        });
    }

    request_additional(userID, userJson) {
        User._database.insertRequestAdditional(userID, userJson);
    }

    notify_monqez(min_three) {
        for (let i = 3; i < min_three.length; i++) {
            User._database.getFCMToken(min_three[i]).then((token) => {
                // let registrationTokens = [];
                // registrationTokens.push(token);

                const payload = {
                    notification: {
                        title: 'Help is needed!',
                        body: 'A person nearby requires your help!'
                    },
                    data : {
                        type: 'helper',
                        description: 'request',
                        userId: min_three[0],
                        latitude: min_three[1].toString(),
                        longitude: min_three[2].toString()
                    }
                };

                const options = {
                    priority: 'high',
                    timeToLive: 60 * 60
                };

                helper.send_notifications(min_three[i], payload, options);

                // admin.messaging().sendToDevice(registrationTokens, payload, options)
                //     .then(function (response) {
                //         // See the MessagingDevicesResponse reference documentation for
                //         // the contents of response.
                //         console.log('Successfully sent message:', response);
                //     })
                //     .catch(function (error) {
                //         console.log('Error sending message:', error);
                //     });
            });
        }
    }

    getLongLat(userId){
        return new Promise( (resolve, _) => {
            User._database.getLongLat(userId)
                .then( (location) => {
                    resolve(location);
                } )
        } );
    }

    insertCall(userId, Json){
        return new Promise( (resolve, _) => {
            User._database.insertCall(userId, Json).then( (channelId) => {
                resolve(channelId);
            } )
        } );
    }

    isTimeOut(userId){
        return new Promise((resolve, _) => {
            User._database.requestAcceptCount(userId).then( (acceptCount) => {resolve(acceptCount);} );
        } );
    }

    requestTimeOut(userId, monqezId){
        return new Promise( (resolve, reject) => {
            User._database.requestDecline(monqezId, {"uid" : userId})
                .then( (allDecline) => {
                    resolve(allDecline);
                } )
                .catch((error) => {
                    reject(error);
                });
        } );
    }

    callOut(userId){
        return new Promise( (resolve, reject) => {
            User._database.callOut(userId)
                .then( () => {
                    resolve();
                } )
                .catch((error) => {
                    reject(error);
                });
        } );
    }

    logCallRequest(userJson){
        return new Promise( (resolve, _) => {
            User._database.archiveCallRequest(userJson).then(()=>{ resolve() });
        } );
    }

    getRequestLog(userId){
        return new Promise( (resolve, reject) => {
            User._database.getRequests(userId)
                .then( function (requestLog){
                    resolve(requestLog);
                } )
                .catch( function (error){
                    reject(error);
                } );
        } );
    }

    rate(userId, json){
        return new Promise( (resolve, reject) => {
            User._database.setRequestRate(userId, json).then( ()=>{resolve();} ).catch((error) => {reject(error);});
            User._database.setMonqezRate(json)
                .then( () => {resolve();} )
                .catch( function (error){
                    reject(error);
                } )
        } );
    }

    addComplaint(userId, json){
        return new Promise( (resolve, reject) => {
            User._database.addComplaint(userId, json).then(() => {resolve();})
                .catch( function (error){
                    reject(error);
                } )
        } );
    }
}

module.exports = NormalUser;