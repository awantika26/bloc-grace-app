import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/widgets/textformfields.dart';

class Resetpassword extends StatefulWidget {
  Resetpassword({Key key}) : super(key: key);

  @override
  _ResetpasswordState createState() => _ResetpasswordState();
}

class _ResetpasswordState extends State<Resetpassword> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _autoValidate = false;
  FocusNode _newpasswordFocusNode = FocusNode();
  FocusNode _confirmpasswordFocusNode = FocusNode();

  void _resetpassword() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_newPasswordController.text != null &&
          _confirmPasswordController.text != null) {}
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    _newpasswordFocusNode.dispose();
    _confirmpasswordFocusNode.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _blankfocusnode = new FocusNode();

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue.shade700,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(_blankfocusnode);
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 0, top: 0),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppStrings.resetpasswordtext,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppStrings.setresetpassword,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  resetpassword(context),
                ],
              ),
            ),
          ),
        ));
  }

  Widget resetpassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0, left: 15, right: 15),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                                      MediaQuery.of(context).size.height / 8,
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  child: AppTextFromField(
                                    maxlines: 1,
                                    controller: _newPasswordController,
                                    validator: AppMethods.validatePassword,
                                    onFieldSubmitted: (_) {
                                      AppMethods.fieldFocusChange(
                                          context,
                                          _newpasswordFocusNode,
                                          _confirmpasswordFocusNode);
                                    },
                                    focusNode: _newpasswordFocusNode,
                                    autofocus: true,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    labelText: AppStrings.newpassword,
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
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return AppStrings.pleaseconfrimpassword;
                                      }

                                      if (value !=
                                          _newPasswordController.text) {
                                        return AppStrings.passwordnotmatched;
                                      }
                                    },
                                    focusNode: _confirmpasswordFocusNode,
                                    controller: _confirmPasswordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    labelText: AppStrings.confirmnewpassword,
                                  ),
                                ),
                              ),
                              _newPasswordController.text.isNotEmpty &&
                                      _confirmPasswordController.text.isNotEmpty
                                  ? Container(
                                      height: 50,
                                      width: 250,
                                      child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        color: Colors.blue.shade700,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          _resetpassword();
                                        },
                                        child: Text(
                                          AppStrings.updatepassword,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      width: 250,
                                      child: RaisedButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        color: Colors.blueGrey.shade100,
                                        textColor: Colors.white,
                                        onPressed: () {
                                          _resetpassword();
                                        },
                                        child: Text(
                                          AppStrings.updatepassword,
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
    );
  }
}
