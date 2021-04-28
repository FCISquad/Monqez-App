import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:http/http.dart' as http;
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';
import 'dart:convert';
import 'dart:async';
import '../main.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
);
AndroidInitializationSettings initializationSettingsAndroid;
InitializationSettings initializationSettings;

void initialize() {
  initializationSettingsAndroid = new AndroidInitializationSettings('launch_background');

  initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid
  );
}
/*
void firebaseMessagingBackground() async {
  if (Firebase.apps.length == 0)
    await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background notification");
  HelperRequestNotificationScreenState.hideBackButton = true;
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  RemoteNotification notification = message.notification;
  flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          icon: 'launch_background',
        ),
      ));
}
*/
class FirebaseCloudMessaging {

  String _fcmToken;
  String _token;

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
      print("HERE!!");
    }
    navigatorKey.currentState.pushNamed('notification');
  }


  FirebaseCloudMessaging(String token) {
    _token = token;
    initialize();
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onSelectNotification: onSelectNotification
    );

    FirebaseMessaging.instance.getToken().then((fcmToken) async {
      _fcmToken = fcmToken;
      print("FCM:" + fcmToken);
      await updateRegistrationToken();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      /*
      var data = message.data;
      String requestID;
      if (data != null){
        requestID = data['userId'];
        HelperRequestNotificationScreenState.requestID = requestID;
        print("Request ID: "+ requestID);
      }

       */
      navigatorKey.currentState.pushNamed('notification');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      var data = message.data;
      String requestID;
      if (data != null){
        requestID = data['userId'];
        HelperRequestNotificationScreen.requestID = requestID;
        HelperRequestNotificationScreen.longitude = double.parse(data['longitude']) ;
        HelperRequestNotificationScreen.latitude = double.parse(data['latitude']);
      }
      if (data != null){
        requestID = data['userId'];
      }
      if (notification != null && android != null) {
        HelperRequestNotificationScreen.hideBackButton = false;
        print ("Received notification");
        onSelectNotification(requestID);
        flutterLocalNotificationsPlugin.show(
            0,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                importance: Importance.max,
                priority: Priority.high,
                enableVibration: true,
                icon: 'launch_background',



              ),
            ));
      }
    });
    //firebaseMessagingBackground();
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
