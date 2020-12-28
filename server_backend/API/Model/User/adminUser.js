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

    getState(){
        return new Promise( (resolve, reject) => {
            User._database.getState().then( (stateJSON) => {
                resolve(stateJSON);
            } ).catch( (error) => {
                reject(error);
            } );
        } );
    }

    getApplicationQueue(){
        return new Promise( ((resolve, reject) => {
            User._database.getApplicationQueue().then(
                (queue) => {
                    resolve (queue);
                }
            ).catch((error) => {
                reject(error);
            });
        }));
    }

    addAdditionalInformation(userID, userObject){
        return new Promise( (resolve, reject) => {
            User._database.addAdminAdditionalInformation(userID , {
                name: userObject.name,
                national_id: userObject.national_id,
                phone: userObject.phone,
                gender: userObject.gender,
                birthdate: userObject.birthdate,
                country: userObject.country,
                city: userObject.city,
                street: userObject.street,
                buildNumber: userObject.buildNumber,
                chronicDiseases: "",
                firstLogin: "false",
            }).then( () => {
                resolve();
            } ).catch( (error) => {
                reject(error);
            } );
        } );

    }
}

module.exports = Admin;