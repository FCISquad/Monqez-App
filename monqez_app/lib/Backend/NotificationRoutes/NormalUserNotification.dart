
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:monqez_app/Screens/Model/Normal.dart';

import '../../main.dart';

/*
  

 */
class NormalUserNotification extends NotificationRoute {
  NormalUserNotification(RemoteMessage message, bool isBackground) : super(message, isBackground) {
    print("Normal Constructor");
    var data = message.data;
    if (data["description"] == "message") {
      showNotification();
      NotificationRoute.selectNavigate = NormalHomeScreen(token);
      Provider.of<Normal>(navigatorKey.currentContext, listen: false).setAccepted(data["phone"]);
    } else {

    }
  }

  @override
  Future onSelectNotification(String payload) async {
    print("Normal On Select");
    navigate(NotificationRoute.selectNavigate, null, true);
  }
}