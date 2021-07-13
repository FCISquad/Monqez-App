
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationRoute{
  RemoteMessage message;
  static Widget selectNavigate;
  RemoteNotification notification ;
  AndroidNotification android ;
  bool isBackground = false; // it was true, why ?
  final AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid;
  InitializationSettings initializationSettings;
  String token ;

  void getToken () async {
    var _prefs = await SharedPreferences.getInstance();
    this.token = _prefs.getString("userToken");
    print("HHH:" + (token == null).toString());
  }

  NotificationRoute(RemoteMessage message, bool isBackground) {
    getToken();
    print("Notification Route");
    this.message = message;
    notification = message.notification;
    print (notification);
    android = message.notification?.android;
    initializationSettingsAndroid = new AndroidInitializationSettings('launch_background');
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid
    );
    flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onSelectNotification
    );
  }

  Future onSelectNotification (String payload);

  showNotification() {
    print("Showed");
    if (notification != null && android != null && !isBackground) {
      flutterLocalNotificationsPlugin.show(
          0,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              timeoutAfter: 1000,
              importance: Importance.max,
              priority: Priority.high,
              enableVibration: true,
              icon: 'launch_background',
            ),
          ));
    }
  }
}