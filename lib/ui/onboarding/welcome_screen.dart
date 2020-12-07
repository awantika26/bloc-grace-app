import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

Widget welcome(BuildContext context) {
  return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              alignment: Alignment.center,
              child: Image.asset(AppAssets.googleimage,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.height / 7),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
            child: Image.asset(
              AppAssets.background,
              fit: BoxFit.fitWidth,
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text(
                AppStrings.Welcome,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.textblack,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Text(
                AppStrings.downloading,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColor.textblack,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w300),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.height / 6,
                    child: RaisedButton(
                      color: AppColor.facbookbutton,
                      child: Image.asset(
                        AppAssets.facebook,
                        height: 28.0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.underdevelopment);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 15,
                    width: MediaQuery.of(context).size.height / 6,
                    child: RaisedButton(
                      color: AppColor.twitterbutton,
                      child: Image.asset(
                        AppAssets.twitter,
                        height: 20.0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AppRoutes.underdevelopment);
                      },
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              height: 40,
              child: new OutlineButton(
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.underdevelopment);
                },
                child: new Row(
                  children: <Widget>[
                    new Image.asset(
                      AppAssets.google,
                      height: 28.0,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    new Expanded(
                      child: Text(
                        AppStrings.googlesignin,
                      ),
                    ),
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
            height: 50,
            child: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.signin);
              },
              color: AppColor.signinwithemail,
              textColor: AppColor.textwhite,
              child: Text(AppStrings.emailsignin),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ),
          Container(
              child: Row(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 3.5,
              ),
              Text(AppStrings.newuser),
              FlatButton(
                child: Text(
                  AppStrings.signupcapital,
                  style: TextStyle(
                      color: AppColor.signupcapital,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
              )
            ],
          )),
        ],
      ));
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(backgroundColor: Colors.white, body: welcome(context)));
  }
}
