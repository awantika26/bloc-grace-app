import 'package:flutter/material.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class AccountVerification extends StatefulWidget {
  @override
  _AccountVerificationState createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget accountverify(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(60, 50, 60, 0),
              child: Image.asset(
                AppAssets.accountverification,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  AppStrings.Verification,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColor.textwhite,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Text(
              AppStrings.verifytext,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColor.textwhite,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            )),
            SizedBox(
              height: 30,
            ),
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
                child: new RaisedButton(
                  color: AppColor.textwhite,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.signin);
                  },
                  child: Text(
                    AppStrings.gotologin,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 20.0,
                    ),
                  ),
                )),
            Container(
                child: Row(
              children: <Widget>[
                SizedBox(
                  width: 120,
                ),
                FlatButton(
                  onPressed: () {
                    _authenticationService.resendverifyemail();
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text(AppStrings.verifcationemailresend),
                      duration: Duration(seconds: 8),
                    ));
                  },
                  child: Text(
                    AppStrings.Resend,
                    style: TextStyle(
                      color: AppColor.textwhite,
                      fontSize: 20.0,
                    ),
                  ),
                )
              ],
            )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: AppColor.backgroundcolor,
            body: accountverify(context)));
  }
}
