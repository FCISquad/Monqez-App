import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Screens/LoginScreen.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  _ComplaintsScreenState createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Monqez - Complaints'),
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
          title: Text('Complaint from Name'),
          subtitle: Text('Title of the Complaint'),
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
