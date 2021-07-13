const Address = require("../address");
const Database = require('../../Database/database');

class User{
    // abstract class definition
    static _database = new Database();

    constructor() {
        if (this.constructor == User) {
            throw new Error("Abstract classes can't be instantiated.");
        }
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

    static getProfile(userID) {
        return new Promise( ((resolve, reject) => {
            User._database.getProfile(userID)
                .then( (userJson) =>{
                    resolve(userJson);
                } )
                .catch( (error) => {
                    reject(error);
                } )
        }));
    }

    static editAccount(userID, userData){
        return new Promise( (resolve, reject) => {
            User._database.editAccount(userID , userData)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                })
        } );
    }

    static registrationToken(userID, registrationToken){
        return new Promise( (resolve, reject) => {
            User._database.registerToken(userID , registrationToken)
                .then(() => {
                    resolve();
                })
                .catch((error) => {
                    reject(error);
                })
        } );
    }

    static getInstructions(){
        return new Promise( ((resolve, reject) => {
            User._database.getInstructions()
                .then( (userJson) =>{
                    resolve(userJson);
                } )
                .catch( (error) => {
                    reject(error);
                } )
        }));
    }
}

module.exports = User;