class HelperUser extends User{
    constructor() {
        super();
        this.rates = [];
        this.longitude = 0.0;
        this.latitude  = 0.0;
    }
    setIsApproval(isApproval){
        this.isApproval = isApproval;
    }
    setIsBanend(isBanned){
        this.isBanned = isBanned;
    }
    setLongitude(longitude){
        this.longitude = longitude;
    }
    setLongitude(latitude){
        this.latitude = latitude;
    }

    submitApplication(){

    }
    setStatus(statusNumber){
        this.status = statusNumber;
    }
}

