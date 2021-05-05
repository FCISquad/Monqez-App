import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';
import 'package:monqez_app/Screens/HelperUser/HelperHomeScreen.dart';
import 'package:provider/provider.dart';
import 'Screens/Model/Helper.dart';
import 'Screens/SplashScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();


main() {

  runApp(
    ChangeNotifierProvider(
    create: (context) => Helper.empty(),
    child: MyApp(),
  ),);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monqez',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      //home: Splash(),
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
    return MaterialPageRoute(builder: (context)=>HelperRequestNotificationScreen());
  }


}


