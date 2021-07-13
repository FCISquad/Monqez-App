import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Backend/Authentication.dart';
import 'package:monqez_app/Models/Helper.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HelperRatingsScreen extends StatefulWidget {
  double rating;
  HelperRatingsScreen(this.rating);
  @override
  _HelperHomeScreenState createState() => _HelperHomeScreenState();
}

class _Rating {
  _Rating();
  _Rating.init(this.name, this.comment, this.rate);
  String name;
  String comment;
  double rate;
  isValid(){
    return name != null && comment != null && rate != null;
  }
}

class _HelperHomeScreenState extends State<HelperRatingsScreen> with SingleTickerProviderStateMixin {
  List<Widget> _ratingsList;
  double _helperRating = 0;
  bool _isLoading = true;

  @override
  void initState() {
    _helperRating = widget.rating;
    _ratingsList = <Widget>[];
    super.initState();

    Future.delayed(Duration.zero, () async {
      await getRatings();
      /*_ratingsList = <Widget>[
        getCard(_Rating.init("Khaled Ezzat", "Great Person! I suggest him.",5), null, MediaQuery.of(context).size.width ),
        getCard(_Rating.init("Hussien Ashraf", "He was late, but he saved my life !",5 ), null, MediaQuery.of(context).size.width),
        getCard(_Rating.init("Hatem Mamdoh", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felis, tristique vel fringilla sed, suscipit sit amet orci. Sed dapibus mass",5), null, MediaQuery.of(context).size.width),
        getCard(_Rating.init("Ehab Fawzy", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felci. Sed dapibus mass",5), null, MediaQuery.of(context).size.width),
      ];*/
      _isLoading = false;
      setState((){});
    });
  }

  void _iterateJson(String jsonStr) {
    if (jsonStr.isNotEmpty) {
      List<dynamic> requestsJson = json.decode(jsonStr);
      for(int i=0; i<requestsJson.length; i++){
        _Rating rating = _Rating();
        requestsJson[i].forEach((key, value) {
          if (key == 'request') {
            if (value != null)
            value.forEach((reqKey, reqVal){
              if (reqKey == 'ratingInfo') {
                reqVal.forEach((infoKey, infoVal){
                  if (infoKey == "rate")
                    rating.rate = infoVal.toDouble();
                  else if (infoKey == "comment")
                    rating.comment = infoVal;
                });
              }
            });
          } else if (key == 'user') {
            rating.name = value['name'];
          }
        });
        if (rating.isValid())
          _ratingsList.add(getCard(rating, null, MediaQuery.of(context).size.width ));
      }

    }
  }

  getRatings() async{
    // will be http request
    String token = Provider.of<Helper>(context, listen: false).token;
    http.Response response = await http.get(
      Uri.parse('$url/helper/get_requests'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      _iterateJson(response.body);
    } else {
      print(response.statusCode);
      makeToast("Error!");
    }
  }
  Widget getCard(_Rating rating, Widget nextScreen, double width) {
    return Card (
      elevation: 0,
      color: Colors.transparent,
      child: Container(
        width: width,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: firstColor,
          elevation: 6,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(10,10,10,0),
                leading: getTitle(rating.name, 16, secondColor, TextAlign.center, true),
                title: getTitle(rating.comment, 16, secondColor, TextAlign.center, true),

              ),
              ListTile(
                leading: getRatingBar(rating.rate, 30, secondColor),
                trailing: getTitle(rating.rate.toString(), 16, secondColor, TextAlign.center, true),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
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
                      valueColor:
                      new AlwaysStoppedAnimation<Color>(firstColor)))));
    } else return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        title: getTitle("Ratings", 22.0, secondColor, TextAlign.start, true),
        shadowColor: Colors.black,
        backgroundColor: firstColor,
        iconTheme: IconThemeData(color: secondColor),
        elevation: 5,
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0,15,15,0),
              child: DropdownButtonHideUnderline(
                child: getTitle(_ratingsList.length.toString(), 22, secondColor, TextAlign.center, true)
              ),
            ),
          ],
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, true),
        )
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
                  getRatingBar(_helperRating, (MediaQuery.of(context).size.width-60)/5, firstColor),
                  Center(
                    child: getTitle(_helperRating.toStringAsFixed(2), 18, firstColor, TextAlign.center, true),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _ratingsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _ratingsList[index];
                      }
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}