const User = require("./user");

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
        User._database.requestDecline(monqezId, userJson);
    }
    requestAccept(monqezId, userJson){
        User._database.requestAccept(monqezId, userJson);
    }
}

module.exports = HelperUser;