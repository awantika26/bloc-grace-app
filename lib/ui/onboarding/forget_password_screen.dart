import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/widgets/textformfields.dart';
import 'package:grace_app_project/services/auth.dart';

class Forgetpassword extends StatefulWidget {
  Forgetpassword({Key key}) : super(key: key);

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _error;
  final TextEditingController _emailController = TextEditingController();
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _autoValidate = false;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  void _proceed() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_emailController.text != null) {
        var uid = await _authenticationService
            .sendPasswordResetEmail(_emailController.text);
        _error = uid.toString();
        print(_error);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(_error),
          duration: Duration(seconds: 3),
        ));
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              elevation: 0,
              centerTitle: true,
              titleSpacing: 2,
              backgroundColor: AppColor.backgroundcolor,
              leading: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColor.textwhite,
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: AppColor.backgroundcolor,
          body: forgetpassword(context)),
    );
  }

  Widget forgetpassword(BuildContext context) {
    var _blankfocusnode1 = new FocusNode();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankfocusnode1);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    AppStrings.forgettext,
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColor.textwhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    AppStrings.forgettexts1,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColor.textwhite,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                          labelText: AppStrings.emailid,
                                          hintText: AppStrings.emailhint,
                                        ),
                                      ),
                                    ),
                                    _emailController.text.isNotEmpty
                                        ? Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              color: AppColor.backgroundcolor,
                                              textColor: AppColor.textwhite,
                                              onPressed: () {
                                                _proceed();
                                              },
                                              child: Text(
                                                AppStrings.Proceed,
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
                                                    .height /
                                                3,
                                            child: RaisedButton(
                                              shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        30.0),
                                              ),
                                              color: AppColor.buttongrey,
                                              textColor: AppColor.textwhite,
                                              onPressed: () {
                                                _proceed();
                                              },
                                              child: Text(
                                                AppStrings.Proceed,
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
        ));
  }
}
