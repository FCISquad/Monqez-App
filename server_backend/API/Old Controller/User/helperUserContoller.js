const HelperUser = require("../../Model/User/helperUser");

class helperController{
    submitApplication(requestJson){
        let user = new HelperUser(requestJson);
        user.submitApplication();
    }
    setStatus(statusNumber){}
}

module.exports = helperController;