import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/AdminUser/ViewApplicationScreen.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';

class ApplicationsScreen extends StatefulWidget {
  @override
  _ApplicationsScreenState createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Monqez - Applications'),
        ),
        body: Center(
          child: _myListView(context),
        ));
  }

  Widget _myListView(BuildContext context) {
    return ListView.separated(
      itemCount: 100,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Application from Name'),
          subtitle: Text('Name of the pdf'),
          leading: Text('$index'),
          trailing: Icon(Icons.keyboard_arrow_right),
         // onTap: () => navigate(ViewApplicationScreen()),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
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

}
