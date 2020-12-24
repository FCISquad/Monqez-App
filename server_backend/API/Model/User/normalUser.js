const User = require("./user");
const Database = require('../../Database/database');
const Address = require("../address");

class NormalUser extends User{
    #database = new Database();
    #uid;
    constructor(userJson) {
        super();
        this.userID = userJson.id;
        this.userName = userJson.name;
        this.userEmail = userJson.email;
        this.userAddress = new Address(userJson.country , userJson.city , userJson.street , userJson.buildNumber);
        this.userNationalID = userJson.national_id;
        this.userPhoneNumber = userJson.phone_number;
        this.userGender = userJson.gender;
        this.userDOB = userJson.dob;
        this.isDisable = userJson.isDisable;
        this.isBanned = userJson.isBanned;
        this.#uid = userJson.uid;
    }
    setIsBanend(isBanned){
        this.isBanned = isBanned;
    }
    signUp(){
        this.#database.createUser(this);
    }
}

module.exports = NormalUser;