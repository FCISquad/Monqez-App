

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';

import '../../main.dart';

class HelperUserNotification extends NotificationRoute {
  HelperUserNotification(RemoteMessage message) : super(message) {
    var data = message.data;
    if (data["description"] == "request") {
      request();
    } else {

    }
  }
  request() {
    String requestID;
    var data = message.data;
    if (data != null){
      requestID = data['userId'];
      HelperRequestNotificationScreen.requestID = requestID;
      HelperRequestNotificationScreen.longitude = double.parse(data['longitude']) ;
      HelperRequestNotificationScreen.latitude = double.parse(data['latitude']);
    }
    navigatorKey.currentState.pushNamed('notification');
    HelperRequestNotificationScreen.hideBackButton = false;
    showNotification();
  }

  @override
  Future onSelectNotification(String payload) async {
    if (message.data["description"] == "request") {
      navigatorKey.currentState.pushNamed('notification');
    }
  }
}