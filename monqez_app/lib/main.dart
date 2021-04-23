import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';
import 'Screens/SplashScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  var _initialRoute = '/';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monqez',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      //home: Splash(),
     // initialRoute: _initialRoute,
      onGenerateRoute: onGenerateRoute,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Splash(),
        'notification': (context)=> HelperRequestNotificationScreen()
      },


    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    /*Navigator.push(null,
        new MaterialPageRoute(builder: (context) => new HelperRequestNotificationScreen()));

     */
    return MaterialPageRoute(builder: (context)=>HelperRequestNotificationScreen());
  }


}


