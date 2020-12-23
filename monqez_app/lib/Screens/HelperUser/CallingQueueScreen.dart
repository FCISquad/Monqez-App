import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CallingQueueScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ratings',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: CallingQueueScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  _CallingQueueScreenState createState() => _CallingQueueScreenState();
}


class _CallingQueueScreenState extends State<CallingQueueScreen> with SingleTickerProviderStateMixin {
  List<Widget> _calls = <Widget>[];
  double _helperRating = 4.4;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _calls = <Widget>[
        getCard("Khaled Ezzat", "Lorem ipsum dolor sit amet", null, 5, MediaQuery.of(context).size.width ),
        getCard("Hussien Ashraf", "Lorem ipsum dolor sit amet, consectet", null, 4, MediaQuery.of(context).size.width),
        getCard("Hatem Mamdoh", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felis, tristique vel fringilla sed, suscipit sit amet orci. Sed dapibus mass", null, 4, MediaQuery.of(context).size.width),
        getCard("Ehab Fawzy", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nisl felci. Sed dapibus mass", null, 4, MediaQuery.of(context).size.width),
      ];
      setState(() {
      });
      _isLoading = false;
    });

    //callController.addListener();
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
                title: getTitle(name, 24, Colors.deepOrangeAccent, TextAlign.start, true),
                trailing: Icon(Icons.call, size: 45, color: Colors.deepOrangeAccent,),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(10,0,10,10),
                title: getTitle(comment, 16, Colors.deepOrangeAccent, TextAlign.start, false),
                trailing: getTitle("Severity: " + rating.toString(), 16, Colors.deepOrangeAccent, TextAlign.end, true),
              ),
              //ListT
            ],
          ),
        ),
      ),
    );
  }
  Widget getTitle(String title, double size, Color color, TextAlign align, bool isBold){
    return Text(
      title,
      style: TextStyle(
          color: color,
          fontSize: size,
          letterSpacing: 1.5,
          fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal
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
    if(_isLoading) {
      return CircularProgressIndicator();
    } else return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
          title: getTitle("Call Queue", 22.0, Colors.deepOrangeAccent, TextAlign.start, true),
          shadowColor: Colors.black,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.deepOrangeAccent),
          elevation: 30,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, true),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,15,0),
              child: Center(
                  child: getTitle(_calls.length.toString(), 22, Colors.deepOrangeAccent, TextAlign.center, true)
              ),
            ),
          ],
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
                vertical: 20.0,
              ),

              child: Column(
                   children:[
                     ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _calls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _calls[index];
                        }
                      )
                   ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}