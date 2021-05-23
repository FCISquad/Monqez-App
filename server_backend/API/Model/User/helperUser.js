const User = require("./user");
const normalUser = require('../User/normalUser');
const helper = require('../../Tools/RequestFunctions');

class HelperUser extends User{
    constructor(userJson) {
        super(userJson);
        this.rates = [];
        this.longitude = userJson.longitude;
        this.latitude  = userJson.latitude;

        this.certificate = userJson.certificate;
        this.certificateName = userJson.certificateName
    }
    setIsApproval(isApproval){
        this.isApproval = isApproval;
    }
    setIsBanend(isBanned){
        this.isBanned = isBanned;
    }
    setLongitude(longitude){
        this.longitude = longitude;
    }
    setLongitude(latitude){
        this.latitude = latitude;
    }

    submitApplication(subDate){
        User._database.createUser(this)
            .then( () => {
                User._database.changeToMonqez(this , subDate);
            } )
            .catch((error) => {

            })
    }
    setStatus(userID , status){
        return new Promise( (resolve, reject) => {
            User._database.setHelperStatus(userID , status)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                })
        } );
    }
    getState(userID){
        return new Promise( (resolve, reject) => {
            User._database.getMonqezState(userID)
                .then((status) => {
                    resolve(status);
                })
                .catch((error) => {
                    reject(error);
                })
        } );
    }
    getCertificate(userID){
        return new Promise( (resolve, reject) => {
            User._database.getCertificate(userID)
                .then((certificate) => {
                    resolve(certificate);
                })
                .catch( (error) => {
                    reject(error);
                } );
        } );
    }

    updateLocation(userID){
        User._database.updateLocation(userID, this.longitude, this.latitude);
    }

    requestDecline(monqezId, userJson){
        return new Promise( (resolve, reject) => {
            User._database.requestDecline(monqezId, userJson)
                .then( (allDecline) => {
                    resolve(allDecline);
                } )
                .catch((err) => {reject(err);});
        } );
    }
    requestAccept(monqezId, userJson){
        return new Promise( ((resolve, reject) => {
            User._database.requestAccept(monqezId, userJson)
                .then( () => { resolve() } )
                .catch( () => { reject() } );
        }) );
    }
    rerequest(userJson){
            let user = new normalUser(userJson);
            user.getLongLat(userJson["uid"]).then( (locationJson) => {
                // let cur = locationJson.val();
                // let key = Object.keys(cur)[0];

                if ( locationJson['isFirst'] === false ){
                    const payload = {
                        notification: {
                            title: 'No monqez nearby',
                            body: 'We apologize, there is no available monqez nearby'
                        },
                        data:{
                            type: 'normal',
                            description: 'message'
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
                }
                else{
                    user.request(userJson["uid"], locationJson , false)
                        .then(() => {})
                        .catch(() => {}
                        );
                }
            } );
    }

    getCalls(){
        return new Promise( (resolve, _) => {
            User._database.getCalls().then( (snapShot) => {
                resolve(snapShot);
            } )
        } )
    }

    acceptCall(monqezId, userJson){
        return new Promise( ((resolve, reject) => {
            User._database.callAccept(monqezId, userJson)
                .then( () => { console.log(1); resolve() } )
                .catch( () => {console.log(2); reject() } );
        }) );
    }

    get_additional_information(userId){
        return new Promise( (resolve, _) => {
            User._database.getAdditionalInfo(userId).then( (additionalInfo) => {
                resolve(additionalInfo);
            } )
        } );
    }

    logCallRequest(userJson){
        return new Promise( (resolve, _) => {
            User._database.archiveCallRequest(userJson).then(()=>{ resolve() });
        } );
    }
}

module.exports = HelperUser;