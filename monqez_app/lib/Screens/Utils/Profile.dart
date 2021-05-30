import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monqez_app/Screens/Utils/MaterialUI.dart';
import 'package:monqez_app/Screens/Model/User.dart';

class ProfileScreen extends StatefulWidget {
  User user;
  ProfileScreen(User user) {
    this.user = user;
  }
  @override
  _ProfileScreenState createState() => _ProfileScreenState(user);
}

enum ScreenState {
  Viewing,
  Editing,
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  User user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nationalIDController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _streetController = TextEditingController();
  TextEditingController _buildNumberController = TextEditingController();
  TextEditingController _diseasesController = TextEditingController();

  String gender = "";

  ScreenState state = ScreenState.Viewing;

  bool _isLoading = true;

  _ProfileScreenState(User user) {
    this.user = user;
    gender = user.gender;
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Widget _buildField(String title, String value,
      TextEditingController textController, double width, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getTitle(title, 16, getMainColor(), TextAlign.center, true),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: getMainColor(),
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
          width: width,
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.name,
            enabled: state == ScreenState.Editing,
            //controller: _nameController,
            //onChanged: _validateFullName,
            style: TextStyle(
              color: secondColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
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

  Future<void> save() async {
    if (_nameController.text.isNotEmpty) user.name = _nameController.text;
    if (_nationalIDController.text.isNotEmpty)
      user.nationalID = _nationalIDController.text;
    if (_phoneController.text.isNotEmpty) user.phone = _phoneController.text;
    if (_countryController.text.isNotEmpty)
      user.country = _countryController.text;
    if (_cityController.text.isNotEmpty) user.city = _cityController.text;
    if (_streetController.text.isNotEmpty) user.street = _streetController.text;
    if (_buildNumberController.text.isNotEmpty)
      user.buildNumber = _buildNumberController.text;
    if (gender.isNotEmpty) user.gender = gender;
    if (_diseasesController.text.isNotEmpty)
      user.diseases = _diseasesController.text;
    else
      user.diseases = " ";

    bool success = await user.saveUser();
    if (success) {
      state = ScreenState.Viewing;
      setState(() {});
    }
  }

  void edit() {
    state = ScreenState.Editing;
    setState(() {});
  }

  Widget _buildSubmitBtn() {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      width: MediaQuery.of(context).size.width / 2,
      height: 45,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          state == ScreenState.Editing ? save() : edit();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: firstColor,
        child: Text(
          getButtonText(),
          style: TextStyle(
            color: secondColor,
            letterSpacing: 1,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color getMainColor() {
    return state == ScreenState.Editing ? firstColor : Colors.grey;
  }

  String getButtonText() {
    return state == ScreenState.Editing ? "Save" : "Edit";
  }

  Widget addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: firstColor,
          focusColor: firstColor,
          value: title,
          groupValue: gender,
          onChanged: (value) {
            setState(() {
              gender = value;
            });
          },
        ),
        Text(
          title,
          style: TextStyle(
              color: firstColor, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _addRadioGroup() {
    return Row(
      children: <Widget>[
        addRadioButton(1, "Male"),
        addRadioButton(2, "Female"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    } else
      return Scaffold(
        backgroundColor: secondColor,
        appBar: AppBar(
          title: getTitle("Profile", 22.0, secondColor, TextAlign.start, true),
          shadowColor: Colors.black,
          backgroundColor: firstColor,
          iconTheme: IconThemeData(color: secondColor),
          elevation: 4,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
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
                    children: [
                      Center(
                        child: Stack(children: [
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
                              borderColor: getMainColor(),
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
                                child: getIcon(
                                    Icons.add_a_photo, 26, getMainColor())),
                          )
                        ]),
                      ),
                      SizedBox(height: 10.0),
                      _buildField(
                          "Name",
                          user.name,
                          _nameController,
                          MediaQuery.of(context).size.width,
                          Icons.account_circle_sharp),
                      SizedBox(height: 20.0),
                      _buildField(
                          "National ID",
                          user.nationalID,
                          _nationalIDController,
                          MediaQuery.of(context).size.width,
                          Icons.assignment_ind_outlined),
                      SizedBox(height: 20.0),
                      _buildField("Phone Number", user.phone, _phoneController,
                          MediaQuery.of(context).size.width, Icons.phone),
                      //_buildIDNumberTF(),
                      _buildField(
                          "Diseases",
                          user.diseases,
                          _diseasesController,
                          MediaQuery.of(context).size.width,
                          Icons.accessibility_outlined),
                      SizedBox(height: 15.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildField(
                              "Country",
                              user.country,
                              _countryController,
                              (MediaQuery.of(context).size.width - 30) / 2,
                              Icons.pin_drop),
                          _buildField(
                              "City",
                              user.city,
                              _cityController,
                              (MediaQuery.of(context).size.width - 30) / 2,
                              Icons.pin_drop)
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildField(
                              "Street",
                              user.street,
                              _streetController,
                              (MediaQuery.of(context).size.width - 30) / 2,
                              Icons.pin_drop),
                          _buildField(
                              "Build Number",
                              user.buildNumber,
                              _buildNumberController,
                              (MediaQuery.of(context).size.width - 30) / 2,
                              Icons.pin_drop)
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Visibility(
                          visible: state == ScreenState.Viewing,
                          child: _buildField(
                              "Gender",
                              user.gender,
                              _genderController,
                              MediaQuery.of(context).size.width,
                              Icons.account_circle_sharp)),

                      Visibility(
                        visible: state == ScreenState.Editing,
                        child: _addRadioGroup(),
                      ),
                      SizedBox(height: 20.0),
                      _buildSubmitBtn()
                    ]),
              ),
            ),
          ),
        ),
      );
  }
}
