import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Models/Normal.dart';
import 'package:monqez_app/Screens/NormalUser/NormalHomeScreen.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class NormalUserNotification extends NotificationRoute {
  NormalUserNotification(RemoteMessage message, bool isBackground) : super(message, isBackground) {
    var data = message.data;
    showNotification();
    if (data["description"] == "accept") {

      NotificationRoute.selectNavigate = NormalHomeScreen(token);
      Provider.of<Normal>(navigatorKey.currentContext, listen: false).setAccepted(data["phone"], data["name"]);
    } else if (data["description"] == "cancel" || data["description"] == "completed" || data["description"] == "timeout" ) {
      NotificationRoute.selectNavigate = NormalHomeScreen(token);
      Provider.of<Normal>(navigatorKey.currentContext, listen: false).setFinished();



    }
  }

  @override
  Future onSelectNotification(String payload) async {
    navigate(NotificationRoute.selectNavigate, null, true);
  }
}