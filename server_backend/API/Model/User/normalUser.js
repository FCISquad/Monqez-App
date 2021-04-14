const User = require("./user");
const sphericalGeometry = require('spherical-geometry-js');
const {latLng} = require("@google/maps/lib/internal/convert");

const xx = require("@google/maps");


class NormalUser extends User{
    constructor(userJson) {
        super(userJson);
        this.isBanned = userJson.isBanned;

        // this.userID = userJson.id;
        // this.userName = userJson.name;
        // this.userEmail = userJson.email;
        // this.userAddress = new Address(userJson.country , userJson.city , userJson.street , userJson.buildNumber);
        // this.userNationalID = userJson.national_id;
        // this.userPhoneNumber = userJson.phone_number;
        // this.userGender = userJson.gender;
        // this.userDOB = userJson.dob;
        // this.isDisable = userJson.isDisable;
        // this.isBanned = userJson.isBanned;
        // this.#uid = userJson.uid;
    }
    setIsBanend(isBanned){
        this.isBanned = isBanned;
    }
    signUp(){
        User._database.createUser(this)
            .then(() => {})
            .catch( (error) => {
                console.log(error);
            });
    }

    request(userID, userJson){
        User._database.getAllActiveMonqez().then( (activeMonqez) => {
            let distance = [];
            let normalUserLocation = [userJson["latitude"], userJson["longitude"]];
            for ( let uid in activeMonqez.val() ){
                let longitude   = activeMonqez.val()[uid]["longitude"];
                let latitude    = activeMonqez.val()[uid]["latitude"];

                let monqezLocation = [latitude, longitude];
                distance.push({
                    "distance" : sphericalGeometry.computeDistanceBetween(monqezLocation, normalUserLocation),
                    "uid" : uid
                });
            }

            distance.sort( (a, b) => {
                if ( a['distance'] == b['distance'] ){
                    return 0;
                }
                return (a['distance'] < b['distance'] ? -1 : 1);
            });
            console.log(distance);
            console.log("------");

            let min_three = []
            for (let i = 0; i < Math.min(3, distance.length); ++i){
                min_three.push(distance[i]);
            }

            console.log(min_three);
        } );
    }
}

module.exports = NormalUser;