const NormalUser = require("../../Model/User/normalUser");

class normalUserController{
    signup(requestJson){
        let user = new NormalUser(requestJson);
        user.signUp();
    }
}
module.exports = normalUserController;