
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NormalUserNotification extends NotificationRoute {
  NormalUserNotification(RemoteMessage message) : super(message) {
    var data = message.data;
    if (data["description"] == "message") {
      showNotification();
    } else {

    }
  }

  @override
  Future onSelectNotification(String payload) async {
    if (message.data["description"] == "message") {
      var _prefs = await SharedPreferences.getInstance();
      String token = _prefs.getString("userToken");
      navigate(NormalHomeScreen(token), null, true);
    }
  }
}