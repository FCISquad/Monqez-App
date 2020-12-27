const User = require("./user");

class Admin extends User{
    addAdmin(userObject){}
    addInjury(injuryObject){}
    getAllApplicationRequests(){}
    getAllComplaints(){}
    banAccount(userObject){}
    downloadCertificate(){}
}

module.exports = Admin;