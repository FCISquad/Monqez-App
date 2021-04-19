import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FirebaseCloudMessaging {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );
  String _fcmToken;
  String _token;

  FirebaseCloudMessaging(String token) {
    _token = token;
    FirebaseMessaging.instance.getToken().then((fcmToken) async {
      _fcmToken = fcmToken;
      print("FCM Token: " + _fcmToken);
      await updateRegistrationToken();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

  Future<void> updateRegistrationToken() async {
    print("here ");
    print(_fcmToken);
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
