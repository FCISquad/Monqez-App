import 'package:flutter/material.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/Utils/Profile.dart';
import '../../Backend/Authentication.dart';
import '../LoginScreen.dart';
import 'package:monqez_app/Screens/Model/User.dart';


class InstructionsScreen extends StatefulWidget {
  String token;
  InstructionsScreen(String token) {
    this.token = token;
  }
  @override
  _InstructionsScreenState createState() => _InstructionsScreenState(token);
}
class _InstructionsScreenState extends State<InstructionsScreen> {

  static User user;
  bool _isLoading = true;

  _InstructionsScreenState (String token){
    Future.delayed(Duration.zero, () async {
      user = new User(token);
      await user.getUser();
    });

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:
            getTitle("Monqez", 22.0, secondColor, TextAlign.start, true),
            shadowColor: Colors.black,
            backgroundColor: firstColor,
            iconTheme: IconThemeData(color: secondColor),
            elevation: 5),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            getTitle(user.name, 26, secondColor,
                                TextAlign.start, true),
                            Icon(Icons.account_circle_rounded,
                                size: 90, color: secondColor),
                          ])),
                  decoration: BoxDecoration(
                    color: firstColor,
                  ),
                ),
                Container(
                  color: secondColor,
                  height: (MediaQuery.of(context).size.height) - 200,
                  child: Column(children: [
                    ListTile(
                      title: getTitle(
                          'My Profile', 18, firstColor, TextAlign.start, true),
                      leading: Icon(Icons.account_circle_rounded,
                          size: 30, color: firstColor),
                      onTap: () {
                        //Navigator.pop(context);
                        navigate(ProfileScreen(user), context, false);
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          width: 120,
                          child: RaisedButton(
                              elevation: 5.0,
                              onPressed: () {
                                logout();
                                navigate(LoginScreen(), context, true);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: firstColor,
                              child: getTitle("Logout", 18, secondColor,
                                  TextAlign.start, true)),
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          )

    ),
    );


  }


}