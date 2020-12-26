import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MaterialUI.dart';

class HelperRatingsScreen extends StatefulWidget {
  @override
  _HelperHomeScreenState createState() => _HelperHomeScreenState();
}


class _HelperHomeScreenState extends State<HelperRatingsScreen> with SingleTickerProviderStateMixin {
  List<Widget> _ratingsList;
  double _helperRating = 4.4;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _ratingsList = <Widget>[
        getCard("Khaled Ezzat", "Great Person! I suggest him.", null, 5, MediaQuery.of(context).size.width ),
        getCard("Hussien Ashraf", "He was late, but he saved my life !", null, 4, MediaQuery.of(context).size.width),
        getCard("Hatem Mamdoh", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felis, tristique vel fringilla sed, suscipit sit amet orci. Sed dapibus mass", null, 4, MediaQuery.of(context).size.width),
        getCard("Ehab Fawzy", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felci. Sed dapibus mass", null, 4, MediaQuery.of(context).size.width),
      ];


      _isLoading = false;
      setState((){});
    });
  }
  Widget getCard(String name, String comment, Widget nextScreen, double rating, double width) {
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
                leading: getTitle(name, 16, secondColor, TextAlign.center, true),
                title: getTitle(comment, 16, secondColor, TextAlign.center, true),

              ),
              ListTile(
                leading: getRatingBar(rating, 30, secondColor),
                trailing: getTitle(rating.toString(), 16, secondColor, TextAlign.center, true),
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
      return CircularProgressIndicator();
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
                    child: getTitle(_helperRating.toString(), 18, firstColor, TextAlign.center, true),
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