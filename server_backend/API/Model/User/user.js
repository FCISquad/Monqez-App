 class User{
    // abstract class definition
    constructor() {
        if (this.constructor == User) {
            throw new Error("Abstract classes can't be instantiated.");
        }
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
}

 module.exports = User;