const User = require("./user");
const sphericalGeometry = require('spherical-geometry-js');
const {latLng} = require("@google/maps/lib/internal/convert");
const admin = require('firebase-admin');

const xx = require("@google/maps");


class NormalUser extends User {
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

    setIsBanend(isBanned) {
        this.isBanned = isBanned;
    }

    signUp() {
        User._database.createUser(this)
            .then(() => {
            })
            .catch((error) => {
                console.log(error);
            });
    }

    request(userID, userJson) {
        User._database.insertRequest(userID, userJson);
        User._database.getAllActiveMonqez().then((activeMonqez) => {
            let distance = [];
            let normalUserLocation = [userJson["latitude"], userJson["longitude"]];
            for (let uid in activeMonqez.val()) {
                let longitude = activeMonqez.val()[uid]["longitude"];
                let latitude = activeMonqez.val()[uid]["latitude"];

                let monqezLocation = [latitude, longitude];
                distance.push({
                    "distance": sphericalGeometry.computeDistanceBetween(monqezLocation, normalUserLocation),
                    "uid": uid
                });
            }

            distance.sort((a, b) => {
                if (a['distance'] === b['distance']) {
                    return 0;
                }
                return (a['distance'] < b['distance'] ? -1 : 1);
            });

            let min_three = []
            min_three.push(userID);
            min_three.push(userJson["latitude"]);
            min_three.push(userJson["longitude"]);
            for (let i = 0; i < Math.min(3, distance.length); ++i) {
                min_three.push(distance[i]["uid"]);
            }

            this.notify_monqez(min_three);
        });
    }

    request_additional(userID, userJson) {
        User._database.insertRequestAdditional(userID, userJson);
    }

    notify_monqez(min_three) {
        for (let i = 3; i < min_three.length; i++) {
            User._database.getFCMToken(min_three[i]).then((token) => {
                let registrationTokens = [];
                registrationTokens.push(token);

                const message = {
                    data: {score: '850', time: '2:45'},
                    tokens: registrationTokens,
                }

                console.log(message);
                const payload = {
                    notification: {
                        title: 'Urgent action needed!',
                        body: 'Urgent action is needed to prevent your account from being disabled!'
                    },
                    data : {
                        userId: min_three[0],
                        latitude: min_three[1].toString(),
                        longitude: min_three[2].toString()
                    }
                };

                // Set the message as high priority and have it expire after 24 hours.
                const options = {
                    priority: 'high',
                    timeToLive: 60 * 60
                };

                admin.messaging().sendToDevice(registrationTokens, payload, options)
                    .then(function (response) {
                        // See the MessagingDevicesResponse reference documentation for
                        // the contents of response.
                        console.log('Successfully sent message:', response);
                    })
                    .catch(function (error) {
                        console.log('Error sending message:', error);
                    });
            });
        }
    }
}

module.exports = NormalUser;