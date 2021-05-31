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

    setApproval(adminID , applicationJson){
        User._database.setApproval(adminID , applicationJson);
    }
    
    getApplication(userID){
        return new Promise((resolve, _) => {
            User._database.getApplication(userID , function (applicationJson){
                resolve(applicationJson);
            })
        });
    }

    getAllApplicationRequests(){
        return new Promise( (resolve, _) => {
            User._database.getApplicationQueue(function (json){
                resolve(json);
            });
        } );
    }

    getState(){
        return new Promise( (resolve, reject) => {
            User._database.getState().then( (stateJSON) => {
                resolve(stateJSON);
            } ).catch( (error) => {
                reject(error);
            } );
        } );
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

    banUser(userId){
        return new Promise( (resolve, reject) => {
            User._database.banUser(userId).then(function (){
                resolve();
            }).catch(function (error){
                    reject(error);
            })
        } );
    }

    getAllComplaints(){
        return new Promise( (resolve, reject) => {
            User._database.getAllComplaints()
                .then( function (comps){
                    resolve(comps);
                } )
                .catch( function (error){
                    reject(error);
                } )
        } );
    }

    getComplaint(compJson){
        return new Promise( (resolve, reject) => {
            User._database.getComplaint(compJson)
                .then(async function (complaint){
                    complaint["complainerUID" ] = compJson["nuid"];
                    complaint["complainerName"] = (await User._database.getuser(compJson["nuid"]))["name"];

                    complaint["complainedUID" ] = compJson["huid"];
                    complaint["complainedName"] = (await User._database.getuser(compJson["huid"]))["name"];
                    resolve(complaint);
                })
                .catch(function (error){
                    reject(error);
                })
        } );
    }
}

module.exports = Admin;