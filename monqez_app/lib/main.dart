import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/HelperRequestNotificationScreen.dart';
import 'package:monqez_app/Screens/Instructions/ModifyInstruction.dart';
import 'package:monqez_app/Screens/Model/Instructions/InstructionsList.dart';
import 'package:monqez_app/Screens/Instructions/InjuryScreen.dart';
import 'package:monqez_app/Screens/Instructions/InstructionsScreen.dart';
import 'package:provider/provider.dart';
import 'Screens/ComplaintDialog.dart';
import 'Screens/HelperUser/HelperRequestScreen.dart';
import 'Screens/Model/Helper.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/rateDialog.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Helper>(create: (context) => Helper.empty()),
        ChangeNotifierProvider<InstructionsList>(
            create: (context) => InstructionsList()),
      ],
      child: MyApp(),
    ),
  );
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
        '/': (context) => HelperRequestScreen("010", "010", 30.0, 31.0, 30.0, 30.2),
        'notification': (context) => HelperRequestNotificationScreen(),
        'instructions': (context) => InstructionsScreen(),
        'injury': (context) => InjuryScreen(),
        'modify_instruction': (context) => ModifyInstruction()
      },
    );
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => InstructionsScreen());
      case 'notification':
        return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) =>
                HelperRequestNotificationScreen());
      case 'instructions':
        return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => InstructionsScreen());
      case 'instructions':
        return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => InjuryScreen());
      case 'modify_instruction':
        return MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ModifyInstruction());
      default:
        return null;
    }
  }
}
