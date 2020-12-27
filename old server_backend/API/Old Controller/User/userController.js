const User = require("../../Model/User/user");

class userController{
    signin(accessToken){}
    getUser(userID){
        return new Promise((resolve, reject) => {
            User.getUser(userID)
                .then( (userJson) => {
                    resolve(userJson);
                } )
                .catch( (error) => {
                    reject(error);
                } );
        })
    }
}

module.exports = userController;