import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rating_dialog/rating_dialog.dart';


// ignore: camel_case_types
class ratingDialog extends StatefulWidget {
  @override
  _ratingDialogState createState() => _ratingDialogState();
}
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
        /*

     String tempToken = user.token;
    final http.Response response = await http.post(
      Uri.parse('$url/user/request/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $tempToken',
      },
      body: jsonEncode(<String, double>{
        'rating' : Response.rating
      }),
    );
    firstStatusCode = response.statusCode;
    if (response.statusCode == 200) {
      makeToast("Submitted");
    }

         */
      },
    );
  }
  /*

   */

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
            body: buildScreen()),
        );
  }

}
