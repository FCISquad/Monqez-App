const User = require("./user");

class Admin extends User{
    constructor(userJson) {
        super(userJson);
    }

    addAdmin(userID){
        return new Promise( (resolve, reject) => {
            User._database.addAdmin(userID , {
                "type": "2",
                "disable": "false",
                "firstLogin": "true"
            }).then( () => {
                resolve();
            } ).catch( (error) => {
                    reject(error);
                } );
        } );
    }
    setApproval(helperID){}
    getApplication(userID){}
    getAllApplicationRequests(){}
    getState(){}

    addAdditionalInformation(userJson){}
}

module.exports = Admin;