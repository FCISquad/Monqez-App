
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';

class AdminUserNotification extends NotificationRoute {
  AdminUserNotification(RemoteMessage message) : super(message);

  @override
  Future onSelectNotification(String payload) async {
    // TODO: implement onSelectNotification
    throw UnimplementedError();
  }

}