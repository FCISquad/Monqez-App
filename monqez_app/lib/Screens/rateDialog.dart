import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


// ignore: camel_case_types
class ratingDialog extends StatefulWidget {
  @override
  _ratingDialogState createState() => _ratingDialogState();
}
// ignore: camel_case_types
class _ratingDialogState extends State<ratingDialog> {


  Widget buildScreen(){
    return RatingDialog(
      ratingColor: Colors.amber,
      title: 'Rate your monqez',
      message: 'Rating your monqez and tell us what you think.'
          ' Add more description here if you want.',
      submitButton: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        _rateRequest (response) ;
      }, image: null,
    );
  }
  Future<void> _rateRequest(RatingDialogResponse dialogResponse) async {
    var _prefs = await SharedPreferences.getInstance();
    String tempToken  = _prefs.getString("userToken");

    final http.Response response = await http.post(
      Uri.parse('$url/helper/rate_request/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode(<String, int>{
        'rate': dialogResponse.rating,
      }),
    );
    if (response.statusCode == 200) {
      makeToast("Submitted");
    }
    else {
      makeToast('Failed to submit rating.');
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
            body: buildScreen()),
        );
  }

}
