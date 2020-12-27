const User = require("./user");

class HelperUser extends User{
    constructor(userJson) {
        super(userJson);
        this.rates = [];
        this.longitude = 0.0;
        this.latitude  = 0.0;

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

    submitApplication(){
        User._database.createUser(this)
            .then( () => {
                User._database.changeToMonqez(this);
            } )
            .catch((error) => {

            })
    }
    setStatus(statusNumber){
        this.status = statusNumber;
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
}

module.exports = HelperUser;