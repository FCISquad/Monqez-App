const User = require("./user");

class NormalUser extends User{
    constructor(userJson) {
        super(userJson);
        this.isBanned = userJson.isBanned;

        // this.userID = userJson.id;
        // this.userName = userJson.name;
        // this.userEmail = userJson.email;
        // this.userAddress = new Address(userJson.country , userJson.city , userJson.street , userJson.buildNumber);
        // this.userNationalID = userJson.national_id;
        // this.userPhoneNumber = userJson.phone_number;
        // this.userGender = userJson.gender;
        // this.userDOB = userJson.dob;
        // this.isDisable = userJson.isDisable;
        // this.isBanned = userJson.isBanned;
        // this.#uid = userJson.uid;
    }
    setIsBanend(isBanned){
        this.isBanned = isBanned;
    }
    signUp(){
        User._database.createUser(this)
            .then(() => {})
            .catch( (error) => {
                console.log(error);
            });
    }
}

module.exports = NormalUser;