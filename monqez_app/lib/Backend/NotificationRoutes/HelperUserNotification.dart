

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import '../../main.dart';

class HelperUserNotification extends NotificationRoute {
  HelperUserNotification(RemoteMessage message, bool isBackground) : super(message, isBackground){
    print("Helper Constructor");
    var data = message.data;
    print(data);
    if (data["description"] == "request") {
      NotificationRoute.selectNavigate = HelperRequestNotificationScreen();
      print("Check Helper 2");
      request();
    } else {
      NotificationRoute.selectNavigate = HelperHomeScreen(token);
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
    showNotification();
    navigatorKey.currentState.pushNamed('notification');
    //HelperRequestNotificationScreen.hideBackButton = false;
  }

  @override
  Future onSelectNotification(String payload) async {
    print("Helper on select");
    //HelperRequestNotificationScreen.hideBackButton = true;
    navigate(NotificationRoute.selectNavigate, null, true);
    /*if (message.data["description"] == "request") {
      navigatorKey.currentState.pushNamed('notification');
    }*/
  }

}