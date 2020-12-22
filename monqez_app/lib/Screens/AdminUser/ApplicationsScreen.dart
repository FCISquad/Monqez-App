import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
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
          onTap: () => print("Tapped"),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
