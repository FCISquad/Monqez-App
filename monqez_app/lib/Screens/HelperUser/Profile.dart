import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MaterialUI.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }
  Widget _buildField(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle(title, 16, firstColor, TextAlign.center, true),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: firstColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 50.0,
          child: TextField(
            keyboardType: TextInputType.name,
            enabled: false,
            //controller: _nameController,
            //onChanged: _validateFullName,
            style: TextStyle(
              color: firstColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_circle_sharp,
                color: secondColor,
              ),
              hintText: value,
              hintStyle: TextStyle(
                color: secondColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return CircularProgressIndicator();
    } else return Scaffold(
      backgroundColor: secondColor,
      appBar: AppBar(
        title: getTitle("Profile", 22.0, secondColor, TextAlign.start, true),
        shadowColor: Colors.black,
        backgroundColor: firstColor,
        iconTheme: IconThemeData(color: secondColor),
        elevation: 4,
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed:() => Navigator.pop(context, true),
        ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Center(
                    child: Stack(
                      children: [
                        Center(
                          child: CircularProfileAvatar(
                            //'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                            null,
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.cover,
                            ),
                            radius: 100,
                            backgroundColor: Colors.transparent,
                            borderColor: firstColor,
                            elevation: 5.0,
                            cacheImage: true,
                            onTap: () {
                              print('Tabbed');
                            }, // sets on tap
                          ),
                        ),
                        Center(
                          child: Container(
                            height: 205,
                            width: 205,
                            alignment: Alignment.bottomRight,
                            child: getIcon(Icons.add_a_photo, 26, firstColor)
                          ),
                        )
                      ]
                    ),
                  ),
                  SizedBox(height: 10.0),
                  _buildField("Name", "Khaled Ezzat"),
                  SizedBox(height: 20.0),
                  _buildField("Phone Number", "01276016539"),
                  //_buildPhoneNumberTF(),
                  SizedBox(height: 20.0),
                  _buildField("National ID", "299013115118146"),
                  //_buildIDNumberTF(),
                  //_buildDatePicker(context),
                  SizedBox(height: 15.0),
                  //_buildAddress(),
                  _buildField("Gender", "Male"),
                  //Visibility(visible: _isMonqez, child: _buildCertificateTF()),
                  //_buildSubmitBtn()
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}