import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  var _username, _name;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  Future _getCurrentUser() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      _name = (await _firebaseAuth.currentUser()).displayName;

      setState(() {
        _username = _name;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget journal(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 0),
        child: ClipRRect(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(30.0),
              topRight: const Radius.circular(30.0),
            ),
            child: Center(
              child: Container(
                  color: AppColor.textwhite,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(60, 30, 60, 0),
                        child: Image.asset(
                          AppAssets.journal1,
                          fit: BoxFit.contain,
                          height: 170,
                          width: 170,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              AppStrings.hi,
                              style: TextStyle(
                                fontSize: 25,
                                color: AppColor.textblack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              _username ?? " ",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: AppColor.textblack,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          AppStrings.journal2,
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColor.textblack,
                              fontStyle: FontStyle.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: 40,
                        margin: EdgeInsets.only(top: 20.0, left: 60, right: 60),
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                          color: AppColor.backgroundcolor,
                          textColor: AppColor.textwhite,
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.addjournal);
                          },
                          child: Text(
                            AppStrings.firstjournal,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.backgroundcolor,
            title: Center(
              child: Text(
                AppStrings.Journal1,
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.textwhite,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.underdevelopment);
              },
              child: Icon(
                Icons.search,
                color: AppColor.textwhite,
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.underdevelopment);
                },
                child: CircleAvatar(
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      AppAssets.calender,
                    ),
                    radius: 15,
                    backgroundColor: AppColor.textwhite,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.backgroundcolor,
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.addjournal);
            },
            child: Image.asset(
              AppAssets.journal2,
              fit: BoxFit.contain,
              width: 80,
              height: 80,
            ),
          ),
          body: journal(context)),
    );
  }
}
