import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/utils/helper/permission.dart';
import 'package:grace_app_project/widgets/textformfields.dart';
import 'package:image_picker/image_picker.dart';

class SignIn extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<SignIn> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthenticationService _authenticationService = AuthenticationService();
  FirebaseUser _firebaseUser;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailController1 = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passController1 = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameController1 = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _emailFocusNode1 = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _passwordFocusNode1 = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _nameFocusNode1 = FocusNode();
  File _image;
  var _error;
  TabController _controller;
  bool _autoValidate = false,
      _autoValidate1 = false,
      _passwordVisible = true,
      _passwordVisible1 = true;

  _checkverifieduser() async {
    try {
      FirebaseAuth.instance.currentUser().then((value) {
        _firebaseUser = value;
        _firebaseUser.reload();
        if (_firebaseUser.isEmailVerified) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(AppStrings.verifyemail),
            duration: Duration(seconds: 3),
          ));
        }
      });
    } catch (e) {
      return e.message;
    }
  }

  void _signin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_emailController.text != null && _passController.text != null) {
        try {
          showLoaderDialog(context);
          String uid = await _authenticationService.signin(
              _emailController.text.trim(), _passController.text);
          _error = uid.toString();
          Navigator.pop(context);

          print(_error);

          if (_error.toString().contains(RegExp(r'[0-9]'))) {
            _checkverifieduser();
          } else {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(_error),
              duration: Duration(seconds: 3),
            ));
          }
        } catch (e) {}
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _signup() async {
    if (_formKey1.currentState.validate()) {
      _formKey1.currentState.save();

      if (_nameController1.text != null &&
          _emailController1.text != null &&
          _passController1.text != null) {
        try {
          if (_image == null) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(AppStrings.updateprofile),
              duration: Duration(seconds: 3),
            ));
          } else {
            showLoaderDialog(context);

            String uid = await _authenticationService.signUp(
                _emailController1.text.trim(),
                _passController1.text,
                _nameController1.text,
                _image.toString());
            _error = uid.toString();
            Navigator.pop(context);
            print(_error);

            setState(() {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(_error),
                duration: Duration(seconds: 3),
              ));
            });

            if (_error.toString().contains(RegExp(r'[0-9]'))) {
              Navigator.pushReplacementNamed(
                  context, AppRoutes.accountverification);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } else {
      setState(() {
        _autoValidate1 = true;
      });
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    _emailController1.dispose();
    _passController1.dispose();
    _nameController1.dispose();
    super.dispose();
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

  Widget login(BuildContext context) {
    var _blankfocusnode = new FocusNode();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_blankfocusnode);
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.textwhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 15, right: 15, bottom: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Form(
                                key: _formKey,
                                autovalidate: _autoValidate,
                                child: Column(children: <Widget>[
                                  Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: AppTextFromField(
                                        controller: _emailController,
                                        validator: AppMethods.validateemail,
                                        focusNode: _emailFocusNode,
                                        onFieldSubmitted: (_) {
                                          AppMethods.fieldFocusChange(
                                              context,
                                              _emailFocusNode,
                                              _passwordFocusNode);
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        labelText: AppStrings.emailstar,
                                        hintText: AppStrings.emailhint,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: AppTextFromField(
                                        maxlines: 1,
                                        controller: _passController,
                                        validator: AppMethods.validatePassword,
                                        focusNode: _passwordFocusNode,
                                        keyboardType: TextInputType.text,
                                        obscureText: !_passwordVisible,
                                        suffixIcon: FlatButton.icon(
                                          label: _passwordVisible
                                              ? Icon(
                                                  Icons.visibility,
                                                  color: AppColor.textgrey,
                                                )
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: AppColor.textgrey,
                                                ),
                                          icon: Icon(
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: AppColor.transparent),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                        labelText: AppStrings.passwordfieldtext,
                                        hintText: AppStrings.passwordhint,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 0, left: 140, bottom: 20),
                                    child: GestureDetector(
                                      child: Center(
                                          child: Text(
                                        AppStrings.forgettext1,
                                        style: TextStyle(
                                            color: AppColor.textgrey,
                                            fontSize: 16),
                                      )),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.forgetpassword);
                                      },
                                    ),
                                  ),
                                  _emailController.text.isNotEmpty &&
                                          _passController.text.isNotEmpty
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: RaisedButton(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            color: AppColor.backgroundcolor,
                                            textColor: AppColor.textwhite,
                                            onPressed: () {
                                              _signin();
                                            },
                                            child: Text(
                                              AppStrings.Signin,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: RaisedButton(
                                            shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                            ),
                                            color: AppColor.buttongrey,
                                            textColor: AppColor.textwhite,
                                            onPressed: () {
                                              _signin();
                                            },
                                            child: Text(
                                              AppStrings.Signin,
                                            ),
                                          ),
                                        ),
                                ])),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget registration(BuildContext context) {
    var _blankfocusnode1 = new FocusNode();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_blankfocusnode1);
      },
      child: Padding(
        padding:
            const EdgeInsets.only(top: 90.0, left: 15, right: 15, bottom: 20),
        child: Column(
          children: <Widget>[
            Stack(
                overflow: Overflow.visible,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.textwhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15, bottom: 20),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Form(
                              key: _formKey1,
                              autovalidate: _autoValidate1,
                              child: Column(children: <Widget>[
                                Center(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: AppTextFromField(
                                      controller: _nameController1,
                                      validator: AppMethods.validatetext,
                                      focusNode: _nameFocusNode,
                                      onFieldSubmitted: (_) {
                                        AppMethods.fieldFocusChange(context,
                                            _nameFocusNode1, _emailFocusNode1);
                                      },
                                      keyboardType: TextInputType.text,
                                      labelText: AppStrings.Username,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: AppTextFromField(
                                      controller: _emailController1,
                                      validator: AppMethods.validateemail,
                                      focusNode: _emailFocusNode1,
                                      onFieldSubmitted: (_) {
                                        AppMethods.fieldFocusChange(
                                            context,
                                            _emailFocusNode1,
                                            _passwordFocusNode1);
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      labelText: AppStrings.emailstar,
                                      hintText: AppStrings.emailhint,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: AppTextFromField(
                                      maxlines: 1,
                                      controller: _passController1,
                                      validator: AppMethods.validatePassword,
                                      focusNode: _passwordFocusNode1,
                                      keyboardType: TextInputType.text,
                                      obscureText: !_passwordVisible1,
                                      suffixIcon: FlatButton.icon(
                                        label: _passwordVisible1
                                            ? Icon(
                                                Icons.visibility,
                                                color: AppColor.textgrey,
                                              )
                                            : Icon(
                                                Icons.visibility_off,
                                                color: AppColor.textgrey,
                                              ),
                                        icon: Icon(
                                            _passwordVisible1
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: AppColor.transparent),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible1 =
                                                !_passwordVisible1;
                                          });
                                        },
                                      ),
                                      labelText: AppStrings.passwordfieldtext,
                                      hintText: AppStrings.passwordhint,
                                    ),
                                  ),
                                ),
                                _emailController1.text.isNotEmpty &&
                                        _passController1.text.isNotEmpty &&
                                        _nameController1.text.isNotEmpty
                                    ? Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          color: AppColor.backgroundcolor,
                                          textColor: AppColor.textwhite,
                                          onPressed: () {
                                            _signup();
                                          },
                                          child: Text(
                                            AppStrings.signupbutton,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                15,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: RaisedButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0),
                                          ),
                                          color: AppColor.buttongrey,
                                          textColor: AppColor.textwhite,
                                          onPressed: () {
                                            _signup();
                                          },
                                          child: Text(
                                            AppStrings.signupbutton,
                                          ),
                                        ),
                                      ),
                              ])),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -80,
                    bottom: 350,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: _image != null
                              ? CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColor.textwhite,
                                  backgroundImage: FileImage(_image),
                                )
                              : CircleAvatar(
                                  backgroundColor: AppColor.avtargrey,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Icon(
                                        Icons.person,
                                        color: AppColor.textgrey,
                                      )),
                                )),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          elevation: 0,
          backgroundColor: AppColor.backgroundcolor,
          leading: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          bottom: TabBar(
            controller: _controller,
            unselectedLabelColor: AppColor.textgrey,
            indicatorColor: AppColor.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    AppStrings.Signin,
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(AppStrings.signupbutton),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.backgroundcolor,
      body: TabBarView(
        controller: _controller,
        children: [login(context), registration(context)],
      ),
    );
  }
}
