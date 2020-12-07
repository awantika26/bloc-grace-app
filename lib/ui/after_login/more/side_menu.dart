import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class SideMenuScreen extends StatefulWidget {
  @override
  _SideMenuScreenState createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  var _imageurl, _photo, _username, _picture, _name, _length;

  @override
  void initState() {
    _getCurrentUser();
    _getDocs();
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
      setState(() {
        _imageurl = _picture[1];
        _username = _name;
      });
    } catch (e) {
      print(e);
    }
  }

  Future _getDocs() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    var ids = (await _firebaseAuth.currentUser()).uid;
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('profile')
        .document(ids)
        .collection('user_profile')
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      _length = querySnapshot.documents.length;
    }
  }

  Widget sidemenu(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                height: 150,
                child: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(
                          20.0,
                        ),
                        child: _photo != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundColor: AppColor.textwhite,
                                child: CircleAvatar(
                                  radius: 48,
                                  backgroundImage: AssetImage(_imageurl),
                                ),
                              )
                            : CircleAvatar(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Icon(Icons.photo_camera)),
                              )),
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            _username ?? " ",
                            style: TextStyle(
                                fontSize: 25,
                                color: AppColor.textwhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 60,
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: OutlineButton(
                            borderSide:
                                BorderSide(width: 1, color: AppColor.textwhite),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            highlightColor: AppColor.textwhite,
                            onPressed: () {
                              if (_length == null)
                                DatabaseService()
                                    .createProfile(' ', ' ', ' ', ' ', ' ');
                              Navigator.pushNamed(context, AppRoutes.myprofile);
                            },
                            child: Text(
                              AppStrings.ViewProfile,
                              style: TextStyle(color: AppColor.textwhite),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(top: 0),
                child: ClipRRect(
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                    child: Center(
                        child: Container(
                      color: AppColor.textwhite,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.blue50,
                                child: Icon(
                                  Icons.contacts,
                                  color: AppColor.blue,
                                ),
                              ),
                              title: Text(AppStrings.Contacts),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.pink50,
                                child: Icon(Icons.attach_money,
                                    color: AppColor.orange),
                              ),
                              title: Text(AppStrings.Donuts),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.red50,
                                child:
                                    Icon(Icons.contacts, color: AppColor.pink),
                              ),
                              title: Text(AppStrings.Events),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.blue50,
                                child: Icon(Icons.content_copy,
                                    color: AppColor.blue),
                              ),
                              title: Text(AppStrings.Resources),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.purple50,
                                child: Icon(Icons.speaker_notes,
                                    color: AppColor.blue400),
                              ),
                              title: Text(AppStrings.Notes),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.blue50,
                                child: Icon(Icons.share, color: AppColor.green),
                              ),
                              title: Text(AppStrings.Share),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.green50,
                                child: Icon(Icons.info,
                                    color: AppColor.greenAccent),
                              ),
                              title: Text(AppStrings.About),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.yellow50,
                                child: Icon(Icons.question_answer,
                                    color: AppColor.yellow),
                              ),
                              title: Text(AppStrings.FAQ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.pink50,
                                child:
                                    Icon(Icons.settings, color: AppColor.pink),
                              ),
                              title: Text(AppStrings.Settings),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.underdevelopment);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                          Divider(
                            color: AppColor.grey300,
                            indent: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColor.grey50,
                                child: Icon(Icons.move_to_inbox,
                                    color: AppColor.textgrey),
                              ),
                              title: Text(AppStrings.Logout),
                              onTap: () async {
                                await _authenticationService.signOut();
                                Navigator.pushNamed(context, AppRoutes.welcome);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ],
                      ),
                    ))))
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: AppColor.backgroundcolor, body: sidemenu(context)),
    );
  }
}
