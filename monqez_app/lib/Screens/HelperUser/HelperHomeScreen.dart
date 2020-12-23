import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Screens/HelperUser/CallingQueueScreen.dart';
import 'package:monqez_app/Screens/HelperUser/ChatQueue.dart';
import 'package:monqez_app/Screens/HelperUser/RatingsScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monqez',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HelperHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HelperHomeScreen extends StatefulWidget {
  @override
  _HelperHomeScreenState createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> with SingleTickerProviderStateMixin {
  String _status;
  List<String> _statusDropDown;

  List<Icon> icons ;
  ScrollController _callController;
  List<String> _names;

  @override
  void initState() {
    _statusDropDown = <String> ["Available", "Contacting only", "Busy"];
    _names = <String>['Khaled1', 'Hussien', 'Ehab', 'Hatem'];
    _status = _statusDropDown[0];
    super.initState();
    //callController.addListener();
  }
  void navigate(Widget map) {
     Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, animationTime, child) {
              return SlideTransition(
                position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                    .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.ease,
                )),
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return map;
            }));
  }
  Widget getCard(String title, String trail, Widget nextScreen, IconData icon, double width) {
    return Card (
      elevation: 10,

      color: Colors.transparent,
      child: Container(

        width: width,
        child: Card(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 10,
          child: Column(

            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              ListTile(
                onTap : () => navigate(nextScreen),
                contentPadding: EdgeInsets.fromLTRB(10,10,10,0),
                title: Icon(icon, size: 70, color: Colors.deepOrangeAccent,),
              ),
              ListTile(
                onTap: () => navigate(nextScreen),
                leading: getTitle(title, 16, Colors.deepOrangeAccent, TextAlign.center),
                trailing: getTitle(trail, 16, Colors.deepOrangeAccent, TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget getTitle(String title, double size, Color color, TextAlign align){
    return Text(
        title,
        style: TextStyle(
            color: color,
            fontSize: size,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold
        ),
        textAlign: align,
    );
  }
  Widget getIcon (IconData icon) {
    return Icon(
      icon,
      color: Colors.white,
      size: 24.0,
      semanticLabel: 'Text to announce in accessibility modes',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        title: getTitle("Monqez", 22.0, Colors.deepOrangeAccent, TextAlign.start),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        elevation: 30,
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0,0,0,0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                dropdownColor: Colors.white,
                //hint: Text('Status'), // Not necessary for Option 1
                value: _status,
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue;
                    print(newValue);
                  });
                },
                items: _statusDropDown.map((location) {
                  return DropdownMenuItem(
                    child: SizedBox(
                      width: 140,
                      child: getTitle(location, 16, Colors.deepOrangeAccent, TextAlign.end),
                    ),
                    value: location
                  );
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
                        getTitle('Name', 26, Colors.deepOrangeAccent, TextAlign.start),
                        Icon(Icons.account_circle_rounded, size: 90, color: Colors.deepOrangeAccent),
                      ]
                  )
              ),
              decoration: BoxDecoration(
                color: Colors.white,

              ),
            ),

            Container(
              color: Colors.deepOrangeAccent,
              height: (MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  ListTile(
                    title: getTitle('My Profile', 18, Colors.white, TextAlign.start),
                    leading: Icon(Icons.account_circle_rounded, size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: getTitle('Call Queue', 18, Colors.white, TextAlign.start),
                    leading: Icon(Icons.call, size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pop(context);
                      navigate(CallingQueueScreen());
                    },
                  ),
                  ListTile(
                    title: getTitle('Chat Queue', 18, Colors.white, TextAlign.start),
                    leading: Icon(Icons.chat, size: 30, color: Colors.white),
                      onTap: () {
                        Navigator.pop(context);
                        navigate(ChatQueueScreen());
                      },
                  ),
                  ListTile(
                    title: getTitle('My Ratings', 18, Colors.white, TextAlign.start),
                    leading: Icon(Icons.star_rate, size: 30, color: Colors.white),
                    onTap: () {
                      Navigator.pop(context);
                      navigate(HelperRatingsScreen());
                    },
                  )
                ]
              ),
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
                      getCard("Call Queue", "4", CallingQueueScreen(), Icons.call, (MediaQuery.of(context).size.width-40) / 2),
                      getCard("Chat Queue", "3", ChatQueueScreen(), Icons.chat, (MediaQuery.of(context).size.width-40) / 2),
                    ],
                  ),
                  getCard("Request Queue", "6", null, Icons.local_hospital, MediaQuery.of(context).size.width ),
                  getCard("My Ratings", "4.4", HelperRatingsScreen(), Icons.star_rate, MediaQuery.of(context).size.width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}