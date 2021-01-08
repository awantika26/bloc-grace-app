import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/utils/helper/permission.dart';
import 'package:grace_app_project/widgets/textformfields.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfiletate createState() => _EditProfiletate();
}

enum MenuOption { Edit, Delete }

class _EditProfiletate extends State<EditProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dormController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactnameController = TextEditingController();
  TextEditingController _universityController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _mobileFocusNode = FocusNode();
  FocusNode _phoneFocusNode = FocusNode();
  FocusNode _locationFocusNode = FocusNode();
  FocusNode _dormFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _contactnameFocusNode = FocusNode();
  FocusNode _universityFocusNode = FocusNode();
  bool _autoValidate = false, _autoValidate1 = false, _updated = false;
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Map _arguments;
  File _image;
  var _imageurl, _photo, _picture, _name, _profileID;
  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future _getCurrentUser() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      _photo = (await _firebaseAuth.currentUser()).photoUrl;
      _name = (await _firebaseAuth.currentUser()).displayName;
      if (_photo != null) {
        _picture = _photo.split("'");
      }
      _arguments = ModalRoute.of(context).settings.arguments as Map;
      print(_arguments['university']);
      setState(() {
        _imageurl = _picture[1];
        _nameController.text = _name;
        _universityController.text = _arguments['university'];
        _emailController.text = _arguments['email'];
        _dormController.text = _arguments['dorm'];
        _locationController.text = _arguments['location'];
        _mobileController.text = _arguments['mobile'];
        _profileID = _arguments['id'];
      });
    } catch (e) {
      print(e);
    }
  }

  void _save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _arguments = ModalRoute.of(context).settings.arguments as Map;

      if (_universityController.text != null &&
          _emailController.text != null &&
          _dormController.text != null &&
          _locationController.text != null &&
          _mobileController.text != null) {
        try {
          DatabaseService().updateProfile(
              _profileID,
              _universityController.text,
              _emailController.text,
              _dormController.text,
              _locationController.text,
              _mobileController.text);
          FirebaseUser user = await FirebaseAuth.instance.currentUser();
          if (_image == null) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(AppStrings.updateprofile),
              duration: Duration(seconds: 3),
            ));
          }
          if (_image != null) {
            setState(() {
              _updated = true;
              if (_updated == true) {
                setState(() {
                  userUpdateInfo.displayName = _nameController.text.trim();
                  userUpdateInfo.photoUrl = _image.toString();
                  user.updateProfile(userUpdateInfo);
                });
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.myprofile,
                ).then((_) {
                  _getCurrentUser();
                });
              }
            });
          }
        } catch (e) {}
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _savecontact() async {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();
      if (_contactnameController.text != null &&
          _phoneController.text != null) {
        try {
          Navigator.pushNamed(context, AppRoutes.underdevelopment);
        } catch (e) {}
      }
    } else {
      setState(() {
        _autoValidate1 = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _universityController.dispose();
    _dormController.dispose();
    _mobileController.dispose();
    _universityFocusNode.dispose();
    _nameFocusNode.dispose();
    _dormFocusNode.dispose();
    _locationFocusNode.dispose();
    _mobileFocusNode.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  void showbottomsheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / .1,
          color: AppColor.textwhite,
          child: Form(
            key: _formKey1,
            autovalidate: _autoValidate1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      AppStrings.Information,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: AppColor.textblack,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 240, top: 10),
                    child: Text(
                      AppStrings.namefieldtext,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColor.textgrey,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: AppTextFromField(
                      controller: _contactnameController,
                      validator: AppMethods.validatename,
                      focusNode: _contactnameFocusNode,
                      keyboardType: TextInputType.text,
                      onFieldSubmitted: (_) {
                        AppMethods.fieldFocusChange(
                            context, _contactnameFocusNode, _phoneFocusNode);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 200, top: 10),
                    child: Text(
                      AppStrings.mobilenostar,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColor.textgrey,
                        fontSize: 17.0,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: AppTextFromField(
                      controller: _phoneController,
                      validator: AppMethods.validatePhone,
                      focusNode: _phoneFocusNode,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                      ),
                      Icon(
                        Icons.error_outline,
                        color: AppColor.textgrey,
                      ),
                      Text(
                        AppStrings.maximum,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColor.textgrey,
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.height / 3,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      color: AppColor.backgroundcolor,
                      textColor: AppColor.textwhite,
                      onPressed: () {
                        _savecontact();
                      },
                      child: Text(
                        AppStrings.Save,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget editprofile(BuildContext context) {
    var _blankfocusnode1 = new FocusNode();
    _arguments = ModalRoute.of(context).settings.arguments as Map;

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankfocusnode1);
        },
        child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: _image == null
                            ? Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: _photo != null
                                    ? CircleAvatar(
                                        radius: 48,
                                        backgroundImage: AssetImage(_imageurl),
                                      )
                                    : CircleAvatar(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Icon(Icons.photo_camera)),
                                      ))
                            : Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: _image != null
                                    ? CircleAvatar(
                                        radius: 48,
                                        backgroundImage: FileImage(_image),
                                      )
                                    : CircleAvatar(
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Icon(Icons.photo_camera)),
                                      ))),
                    Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 230, bottom: 10),
                                    child: Text(
                                      AppStrings.Username,
                                      style: TextStyle(
                                          color: AppColor.textgrey,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: AppTextFromField(
                                      controller: _nameController,
                                      validator: AppMethods.validatename,
                                      focusNode: _nameFocusNode,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 160),
                              child: Text(
                                AppStrings.Information,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: AppColor.textgrey,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 240, top: 10),
                              child: Text(
                                AppStrings.University,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.textgrey,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: AppTextFromField(
                                controller: _universityController,
                                validator: AppMethods.validatetext,
                                focusNode: _universityFocusNode,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  AppMethods.fieldFocusChange(context,
                                      _universityFocusNode, _emailFocusNode);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 200, top: 10),
                              child: Text(
                                AppStrings.Universitye,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.textgrey,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: AppTextFromField(
                                controller: _emailController,
                                validator: AppMethods.validateemail,
                                focusNode: _emailFocusNode,
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (_) {
                                  AppMethods.fieldFocusChange(
                                      context, _emailFocusNode, _dormFocusNode);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 250, top: 10),
                              child: Text(
                                AppStrings.Dorm,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.textgrey,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: AppTextFromField(
                                controller: _dormController,
                                validator: AppMethods.validatetext,
                                focusNode: _dormFocusNode,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  AppMethods.fieldFocusChange(context,
                                      _dormFocusNode, _locationFocusNode);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 240, top: 10),
                              child: Text(
                                AppStrings.Location,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.textgrey,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: AppTextFromField(
                                controller: _locationController,
                                validator: AppMethods.validatetext,
                                focusNode: _locationFocusNode,
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (_) {
                                  AppMethods.fieldFocusChange(context,
                                      _locationFocusNode, _mobileFocusNode);
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 260, top: 10),
                              child: Text(
                                AppStrings.Mobile,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.textgrey,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: AppTextFromField(
                                controller: _mobileController,
                                validator: AppMethods.validatePhone,
                                focusNode: _mobileFocusNode,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.height / 3,
                              child: RaisedButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: AppColor.backgroundcolor,
                                textColor: AppColor.textwhite,
                                onPressed: () {
                                  _save();
                                },
                                child: Text(
                                  AppStrings.Save,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ],
            )));
  }

  _imgFromCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image.path);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(AppStrings.Library),
                      onTap: () {
                        AppPermissions.allowAccess();
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(AppStrings.Camera),
                    onTap: () {
                      AppPermissions.allowAccess();
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.textwhite,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  AppStrings.EditProfile,
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textblack,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColor.blue,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.textwhite,
        body: editprofile(context));
  }
}
