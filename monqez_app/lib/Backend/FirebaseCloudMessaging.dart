import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Backend/NotificationRoutes/HelperUserNotification.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'dart:convert';
import 'dart:async';
import '../main.dart';
import 'NotificationRoutes/AdminUserNotification.dart';
import 'NotificationRoutes/NormalUserNotification.dart';



void firebaseMessagingBackground() async {
  if (Firebase.apps.length == 0)
    await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background notification");
  //HelperRequestNotificationScreenState.hideBackButton = true;
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

}

class FirebaseCloudMessaging {

  String _fcmToken;
  String _token;
  static NotificationRoute route;
  static bool tokenTaken = false;
  FirebaseCloudMessaging(String token) {
    _token = token;

      FirebaseMessaging.instance.getToken().then((fcmToken) async {
      _fcmToken = fcmToken;
      print("FCM:" + fcmToken);
      await updateRegistrationToken();
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      initalizeRoutes(message, true);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message != null) {
        print("on Message");
        initalizeRoutes(message, false);
      }
    });
    firebaseMessagingBackground();
  }

  void initalizeRoutes(RemoteMessage message, bool isBackground) {
    var data = message.data;
    if (data['type'] == "helper") {
      print("Helper");
      route = new HelperUserNotification(message, isBackground);
    } else if (data['type'] == "normal") {
      print("Normal");
      route = new NormalUserNotification(message, isBackground);
    } else if (data['type'] == "admin"){
      route = new AdminUserNotification(message, false);
    } else {
      makeToast("Invalid notification received");
    }
  }
  Future<void> updateRegistrationToken() async {
    final http.Response response = await http.post(
      Uri.parse('$url/user/update_registration_token/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{'token': _fcmToken}),
    );

    if (response.statusCode == 200) {
      makeToast("Submitted");
    } else {
      makeToast('Failed to submit user.');
    }
  }
}
