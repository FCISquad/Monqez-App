const Address = require("../address");
const Database = require('../../Database/database');

class User{
    // abstract class definition
    static _database = new Database();

    #uid;
    constructor(userJson ) {
        if (this.constructor == User) {
            throw new Error("Abstract classes can't be instantiated.");
        }
        this.userID = userJson.userID;
        this.userName = userJson.name;
        this.userEmail = userJson.email;
        this.userAddress = new Address(userJson.country , userJson.city , userJson.street , userJson.buildNumber);
        this.userNationalID = userJson.national_id;
        this.userPhoneNumber = userJson.phone_number;
        this.userGender = userJson.gender;
        this.userDOB = userJson.dob;
        this.isDisable = userJson.isDisable;
        this.#uid = userJson.uid;
    }
    setUserId(userID){
        this.userID = userID;
    }
    setName(userName){
        this.userName = userName;
    }
    setEmail(userEmail){
        this.userEmail = userEmail;
    }
    setAddress(addressObject){
        this.userAddress = addressObject;
    }
    setNationalID(userNationalID){
        this.userNationalID = userNationalID;
    }
    setPhoneNumber(userPhoneNumber){
        this.userPhoneNumber = userPhoneNumber;
    }
    setGender(userGender){
        this.userGender = userGender;
    }
    setDOB(userDOB){
        this.userDOB = userDOB;
    }
    setIsDisable(isDisable){
        this.isDisable = isDisable;
    }
    static getUser(userID){
        return new Promise( (resolve, reject) => {
            User._database.getUser(userID)
                .then( (userJson) =>{
                    resolve(userJson);
                } )
                .catch( (error) => {
                    reject(error);
                } )
        } );

    }
}

module.exports = User;