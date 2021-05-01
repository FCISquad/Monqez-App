import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/FirebaseCloudMessaging.dart';
import 'package:monqez_app/Backend/NotificationRoutes/HelperUserNotification.dart';
import 'package:monqez_app/Backend/NotificationRoutes/NotificationRoute.dart';
import 'package:monqez_app/Screens/HelperUser/CallingQueueScreen.dart';
import 'package:monqez_app/Screens/HelperUser/ChatQueue.dart';
import 'package:monqez_app/Screens/HelperUser/RatingsScreen.dart';
import 'package:monqez_app/Screens/Model/Helper.dart';
import 'package:monqez_app/Screens/Utils/Profile.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Backend/Authentication.dart';




// ignore: must_be_immutable
class HelperHomeScreen extends StatelessWidget {
  String token;

  HelperHomeScreen(String token) {
    this.token = token;
  }

  List<String> _statusDropDown = <String>["Available", "Contacting only", "Busy"];

  List<Icon> icons;
  bool _isLoaded = false ;
  String messageTitle = "Empty";
  String notificationAlert = "alert";



  Widget getCard(String title, String trail, Widget nextScreen, IconData icon,
      double width,BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: firstColor,
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                onTap: () => navigate(nextScreen, context, false),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                title: Icon(
                  icon,
                  size: 70,
                  color: secondColor,
                ),
              ),
              ListTile(
                onTap: () => navigate(nextScreen, context, false),
                leading:
                    getTitle(title, 16, secondColor, TextAlign.center, true),
                trailing:
                    getTitle(trail, 16, secondColor, TextAlign.center, true),
              ),
            ],
          ),
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      Provider.of<Helper>(context, listen: true).setToken(token);
      checkNotification(context);
    }
    if ( Provider.of<Helper>(context, listen: true).status == null) {
          return Scaffold(
              backgroundColor: secondColor,
              body: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        backgroundColor: secondColor,
                        strokeWidth: 5,
                        //    valueColor:
                        //      new AlwaysStoppedAnimation<Color>(firstColor)
                      ))));
        } else

        if(!_isLoaded) _isLoaded = true;
        return Scaffold(
          backgroundColor: secondColor,
          appBar: AppBar(
            title: getTitle("Monqez", 22.0, secondColor, TextAlign.start, true),
            shadowColor: Colors.black,
            backgroundColor: firstColor,
            iconTheme: IconThemeData(color: secondColor),
            elevation: 5,
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: firstColor,
                    //hint: Text('Status'), // Not necessary for Option 1
                    value: Provider.of<Helper>(context, listen: true).status,
                    onChanged: (newValue) {
                      Provider.of<Helper>(context, listen: false).status = newValue;
                      Provider.of<Helper>(context, listen: false).changeStatus(newValue);
                    },
                    items: _statusDropDown.map((location) {
                      return DropdownMenuItem(
                          child: SizedBox(
                            width: 140,
                            child: getTitle(
                                location, 16, secondColor, TextAlign.end, true),
                          ),
                          value: location);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
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
                            getTitle( Provider.of<Helper>(context, listen: true).name, 26, secondColor, TextAlign.start,
                                true),
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
                        Navigator.pop(context);
                        navigate(ProfileScreen( Provider.of<Helper>(context, listen: false)), context, false);
                      },
                    ),
                    ListTile(
                      title: getTitle(
                          'Call Queue', 18, firstColor, TextAlign.start, true),
                      leading: Icon(Icons.call, size: 30, color: firstColor),
                      onTap: () {
                        Navigator.pop(context);
                        navigate(CallingQueueScreen(), context, false);
                      },
                    ),
                    ListTile(
                      title: getTitle(
                          'Chat Queue', 18, firstColor, TextAlign.start, true),
                      leading: Icon(Icons.chat, size: 30, color: firstColor),
                      onTap: () {
                        Navigator.pop(context);
                        navigate(ChatQueueScreen(), context, false);
                      },
                    ),
                    ListTile(
                      title: getTitle(
                          'My Ratings', 18, firstColor, TextAlign.start, true),
                      leading: Icon(Icons.star_rate, size: 30, color: firstColor),
                      onTap: () {
                        Navigator.pop(context);
                        navigate(HelperRatingsScreen(), context, false);
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
                                if (Provider.of<Helper>(context, listen: true).status == "Available") {
                                  Provider.of<Helper>(context, listen: true).stopBackgroundProcess();
                                }
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
          ),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          getCard(
                              "Call Queue",
                              "4",
                              CallingQueueScreen(),
                              Icons.call,
                              (MediaQuery.of(context).size.width - 40) / 2,context),
                          getCard(
                              "Chat Queue",
                              "3",
                              ChatQueueScreen(),
                              Icons.chat,
                              (MediaQuery.of(context).size.width - 40) / 2,context),
                        ],
                      ),
                      getCard("Request Queue", "6", null, Icons.local_hospital,
                          MediaQuery.of(context).size.width,context),
                      getCard("My Ratings", "4.4", HelperRatingsScreen(),
                          Icons.star_rate, MediaQuery.of(context).size.width,context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
  }

  void checkNotification(BuildContext context) async {
    print("Check Helper 1");

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      FirebaseCloudMessaging.route = new HelperUserNotification(message);
      navigate(NotificationRoute.selectNavigate, context, false);
    });
}
