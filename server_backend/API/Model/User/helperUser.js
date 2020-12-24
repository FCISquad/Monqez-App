const Database = require('../../Database/database');

const User = require("./user");

class HelperUser extends User{
    constructor(userJson) {
        super(userJson);
        this.rates = [];
        this.longitude = 0.0;
        this.latitude  = 0.0;
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
        this.#database.createUserPromise(this)
            .then( () => {
                this.#database.changeToMonqez(this);
            } )
            .catch((error) => {

            })
    }
    setStatus(statusNumber){
        this.status = statusNumber;
    }
}

module.exports = HelperUser;