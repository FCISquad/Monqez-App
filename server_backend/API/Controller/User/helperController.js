const express = require('express');
const app = express();

const helper = require("../../Tools/requestFunctions");
const HelperUser = require("../../Model/User/helperUser");
const tracker = require('../../Tools/debugger');
const controllerType = "helper";


app.post('/setstatus', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().setStatus(userID, request.body.status)
                .then(() => {
                    tracker.track("request finished without errors");
                    response.sendStatus(200);
                })
                .catch((error) => {
                    tracker.error(error);
                    response.send(error);
                });
        }
    })
});

app.get('/getstate', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().getState(userId).then((userJson) => {
                tracker.track("request finished without errors");
                response.send(userJson);
            })
            .catch((error) => {
                tracker.error(error);
                response.send(error);
            });
        }
    });
});

app.post('/update_location', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userID) => {
        if (userID === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().updateLocation(userID, request.body);
            response.sendStatus(200);
        }
    });
});

app.post('/decline_request', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (monqezId) => {
        if (monqezId === null) {
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            let user = new HelperUser();
            user.requestDecline(monqezId, request.body)
                .then((allDecline) => {
                    if (allDecline === true) {
                        tracker.track("All Decline - start re request");
                        user.rerequest(request.body);
                    }
                    response.sendStatus(200);
                    tracker.track("request finished without errors");
                })
                .catch((error) => {
                    tracker.error(error);
                    response.sendStatus(503);
                });
        }
    });
});

app.post('/accept_request', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (monqezId) => {
        if (monqezId === null) {
            // Forbidden
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            new HelperUser().requestAccept(monqezId, request.body)
                .then(async () => {
                    tracker.track("request finished without errors");

                    let monqezObject = await new HelperUser().getUser(monqezId);
                    let normalObject = await new HelperUser().getUser(request.body["uid"]);

                    response.status(200).send({"phone": normalObject["phone"]});

                    let normalUserId = request.body["uid"];
                    const payload = {
                        notification: {
                            title: 'Request is accepted',
                            body: 'Helper is on the way to you'
                        },
                        data: {
                            type: 'normal',
                            description: 'accept',
                            phone: monqezObject["phone"],
                            name: monqezObject["name"]
                        }
                    };

                    const options = {
                        priority: 'high',
                        timeToLive: 60 * 60
                    };

                    helper.send_notifications(normalUserId, payload, options);
                })
                .catch((error) => {
                    tracker.error(error);
                    response.sendStatus(201);
                });
        }
    });
});

app.post('/get_call_queue', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().getCalls().then((channelId) => {
                response.status(200).send(channelId);
                tracker.track("request finished without errors");
            });
        }
    });
});

app.post('/accept_call', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            let user = new HelperUser();
            user.acceptCall(userId, request.body).then(() => {
                response.sendStatus(200);

                tracker.track("Write Call Request in calls Log");
                user.logCallRequest(request.body).then(() => {
                });
                tracker.track("request finished without errors");
            })
                .catch((error) => {
                    tracker.error(error);
                    response.sendStatus(503);
                });
        }
    });
});

app.post('/get_additional_information', (request, response) => {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().get_additional_information(request.body["uid"]).then((additionalInfo) => {
                tracker.track("request finished without errors");
                response.status(200).send(additionalInfo);
            });
        }
    });
});

app.get('/get_requests', function (request, response) {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");

            let helperUser = new HelperUser();
            helperUser.getRequests(userId)
                .then(async function (snapShot) {
                    tracker.track("done, start to collect request body");

                    let requestsPool = [];
                    for (let normalUserId in snapShot) {
                        for (let requestTime in snapShot[normalUserId]) {

                            let time = snapShot[normalUserId][requestTime];

                            let requestJson = await helperUser.getRequestBody(normalUserId, time);
                            let userJson = await helperUser.getUser(normalUserId);

                            let json = {
                                "request": requestJson,
                                "user": userJson,
                                "time": time
                            }
                            requestsPool.push(json);
                        }
                    }

                    response.status(200).send(requestsPool);
                })
                .catch(function (error) {
                    tracker.error(error);
                    response.status(503).send(error);
                })
        }
    })
});

app.post('/cancel_request', function (request, response) {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().cancel_request(request.body["uid"]).then(function () {
                tracker.track("request finished without errors");
                response.sendStatus(200);

                const payload = {
                    notification: {
                        title: 'Request is cancelled',
                        body: 'The Monqez has cancel the request!'
                    },
                    data: {
                        type: 'normal',
                        description: 'cancel'
                    }
                };
                const options = {
                    priority: 'high',
                    timeToLive: 60 * 60
                };

                helper.send_notifications(request.body["uid"], payload, options);
            }).catch(function (error) {
                tracker.error(error);
                response.status(503).send(error);
            })
        }
    })
});

app.post('/complete_request', function (request, response) {
    tracker.start(request.originalUrl);
    tracker.track("Hello Request");

    helper.verifyToken(request, controllerType, (userId) => {
        if (userId === null) {
            tracker.error("Auth error, null userId");
            response.sendStatus(403);
        } else {
            tracker.track("good Auth - start process");
            new HelperUser().complete_request(request.body, userId).then(function () {
                tracker.track("request finished without errors");
                response.sendStatus(200);

                const payload = {
                    notification: {
                        title: 'Request is Completed',
                        body: 'You can rate the monqez'
                    },
                    data: {
                        type: 'normal',
                        description: 'completed'
                    }
                };
                const options = {
                    priority: 'high',
                    timeToLive: 60 * 60
                };

                helper.send_notifications(request.body["uid"], payload, options);
            }).catch(function (error) {
                tracker.error(error);
                response.sendStatus(503);
            })
        }
    })
});


module.exports = app;