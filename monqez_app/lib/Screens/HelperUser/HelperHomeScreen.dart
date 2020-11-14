import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';

class HelperHomeScreen extends StatefulWidget {
  @override
  _HelperHomeScreenState createState() => _HelperHomeScreenState();
}
class _HelperHomeScreenState extends State<HelperHomeScreen> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Widget _buildBtn(String text){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ()
        {
          logout();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(1.0, 0.0), end: Offset.zero).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.ease,
                      )),
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, animationTime) {
                    return LoginScreen();
                  }));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(text, style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 16,
            fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = new Tween(begin: 0.0, end: 200.0).animate(controller);
    animation.addListener(() {
      setState(() {
        //The state of the animation has changed
      });
    });

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 70.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                      'Monqez', style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold)),
                  new Container(
                    padding: new EdgeInsets.all(32.0),
                    height: animation.value,
                    width: animation.value,
                    child: new Center(
                      child: new Image(
                          image: new AssetImage('images/firstaid.png')),
                    ),
                  ),
                  _buildBtn('Logout'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}