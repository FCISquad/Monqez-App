import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/HelperUser/HelperRequestNotificationScreen.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import '../../main.dart';

class HelperUserNotification extends NotificationRoute {
  HelperUserNotification(RemoteMessage message, bool isBackground) : super(message, isBackground){
    var data = message.data;
    if (data["description"] == "request") {
      NotificationRoute.selectNavigate = HelperRequestNotificationScreen();
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
      HelperRequestNotificationScreen.reqLongitude = double.parse(data['longitude']) ;
      HelperRequestNotificationScreen.reqLatitude = double.parse(data['latitude']);
    }
    showNotification();
    navigatorKey.currentState.pushNamed('notification');
  }

  @override
  Future onSelectNotification(String payload) async {
    navigate(NotificationRoute.selectNavigate, null, true);
  }
}