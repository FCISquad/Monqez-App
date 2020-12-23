import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HelperRatingsScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratins',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HelperRatingsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

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
                contentPadding: EdgeInsets.fromLTRB(10,10,10,0),
                leading: getTitle(name, 16, Colors.deepOrangeAccent, TextAlign.center),
                title: getTitle(comment, 16, Colors.deepOrangeAccent, TextAlign.center),

              ),
              ListTile(
                leading: getRatingBar(rating, 30, Colors.deepOrangeAccent),
                trailing: getTitle(rating.toString(), 16, Colors.deepOrangeAccent, TextAlign.center),
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
  Widget getRatingBar(double rating, double size, Color color) {
    return RatingBarIndicator(
      direction: Axis.horizontal,
      itemCount: 5,
      rating: _helperRating,
      itemSize: size,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: color,
      ),
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
    if (_isLoading) {
      return CircularProgressIndicator();
    } else return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        title: getTitle("Ratings", 22.0, Colors.deepOrangeAccent, TextAlign.start),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
        elevation: 30,
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0,15,15,0),
              child: DropdownButtonHideUnderline(
                child: getTitle(_ratingsList.length.toString(), 22, Colors.deepOrangeAccent, TextAlign.center)
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
                  getRatingBar(_helperRating, (MediaQuery.of(context).size.width-60)/5, Colors.white),
                  Center(
                    child: getTitle(_helperRating.toString(), 18, Colors.white, TextAlign.center),
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