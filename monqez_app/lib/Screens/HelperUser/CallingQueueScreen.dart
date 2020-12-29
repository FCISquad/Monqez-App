import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MaterialUI.dart';

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
      setState(() {});
      _isLoading = false;
    });

    //callController.addListener();
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
                title: getTitle(name, 24, secondColor, TextAlign.start, true),
                trailing: Icon(Icons.call, size: 45, color: secondColor,),
              ),
              ListTile(
                contentPadding: EdgeInsets.fromLTRB(10,0,10,10),
                title: getTitle(comment, 16, secondColor, TextAlign.start, false),
                trailing: getTitle("Severity: " + rating.toString(), 16, secondColor, TextAlign.end, true),
              ),
              //ListT
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return CircularProgressIndicator();
    } else return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
          title: getTitle("Call Queue", 22.0, secondColor, TextAlign.start, true),
          shadowColor: Colors.black,
          backgroundColor: firstColor,
          iconTheme: IconThemeData(color: secondColor),
          elevation: 4,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, true),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0,0,15,0),
              child: Center(
                  child: getTitle(_calls.length.toString(), 22, secondColor, TextAlign.center, true)
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