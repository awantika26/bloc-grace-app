import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/ui/after_login/journal/journal.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _imageurl, _photo, _username, _picture, _name, _length, _journallength;

  @override
  void initState() {
    _getCurrentUser();
    _getDocs();
    _getJournal();
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

  Future _getJournal() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var id = (await _firebaseAuth.currentUser()).uid;
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('journal')
          .document(id)
          .collection('user_journal')
          .getDocuments();
      _journallength = querySnapshot.documents.length;
    } catch (e) {
      return e.message;
    }
  }

  Widget home(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    AppStrings.hi,
                    style: TextStyle(fontSize: 25, color: AppColor.textblack),
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
            Center(
              child: Text(
                AppStrings.talk,
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
                color: AppColor.blue,
                textColor: AppColor.textwhite,
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.userlist);
                },
                child: Text(
                  AppStrings.chatwith,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                height: 340,
                child: Swiper(
                  itemCount: 3,
                  itemWidth: MediaQuery.of(context).size.width,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 8,
                              color: AppColor.blue50,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(width: 260, height: 260),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              color: AppColor.purple50,
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: 250,
                                height: 250,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                width: 240,
                                height: 240,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColor.gradeint1,
                                      AppColor.gradeint2,
                                      AppColor.gradeint3,
                                      AppColor.gradeint4,
                                      AppColor.gradeint5,
                                      AppColor.gradeint6,
                                    ],
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                  ),
                                ),
                                child: SafeArea(
                                  child: Container(
                                    margin: EdgeInsets.all(16.0),
                                    child: OutlineButton(
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: AppColor.textwhite),
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0),
                                        ),
                                        color: AppColor.blue,
                                        textColor: AppColor.textwhite,
                                        onPressed: () {},
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: Text(
                                                AppStrings.neverbend,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: AppColor.textwhite,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: 20,
                                                  color: AppColor.textwhite,
                                                ),
                                                Center(
                                                  child: Text(
                                                    AppStrings.Joel,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.normal),
                                                  ),
                                                ),
                                                Container(
                                                  height: 1,
                                                  width: 20,
                                                  color: AppColor.textwhite,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              height: 30,
                                              width: 90,
                                              child: RaisedButton(
                                                color: AppColor.textwhite,
                                                shape:
                                                    new RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                    .circular(
                                                                30.0)),
                                                onPressed: () {},
                                                child: Text(
                                                  AppStrings.Happy,
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.textblack),
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
                leading: Image.asset(
                  AppAssets.homejournal,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  AppStrings.Hey,
                  style: TextStyle(
                      color: AppColor.textscolorblack,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  AppStrings.bestway,
                  style: TextStyle(
                    color: AppColor.textscolorblack,
                  ),
                ),
                trailing: Wrap(children: <Widget>[
                  Container(
                    height: 30,
                    width: 90,
                    child: OutlineButton(
                      borderSide: BorderSide(width: 0, color: AppColor.blue),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      highlightedBorderColor: AppColor.blue,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JournalScreen()),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit, color: AppColor.blue),
                          Text(
                            AppStrings.Write,
                            style: TextStyle(color: AppColor.blue),
                          ),
                        ],
                      ),
                    ),
                  )
                ])),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Image.asset(
                AppAssets.homehelp,
                fit: BoxFit.contain,
              ),
              title: Text(
                AppStrings.wannahelp,
                style: TextStyle(color: AppColor.textscolorblack, fontSize: 14),
              ),
              trailing: Wrap(
                children: <Widget>[
                  OutlineButton(
                    borderSide: BorderSide(width: 0, color: AppColor.blue),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    highlightColor: AppColor.blue,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.userlist);
                    },
                    child: Text(
                      AppStrings.Start,
                      style: TextStyle(color: AppColor.blue),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: AppColor.textwhite,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColor.textwhite,
            leading: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GestureDetector(
                    onTap: () {
                      if (_length == null)
                        DatabaseService()
                            .createProfile(' ', ' ', ' ', ' ', ' ');
                      Navigator.pushNamed(
                        context,
                        AppRoutes.myprofile,
                      );
                    },
                    child: _photo != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColor.blue,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: AssetImage(_imageurl),
                            ),
                          )
                        : CircleAvatar(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Icon(Icons.photo_camera)),
                          ))),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.underdevelopment);
                  },
                  child: CircleAvatar(
                    child: CircleAvatar(
                      child: Text(
                        AppStrings.SOS,
                        style: TextStyle(color: AppColor.textwhite),
                      ),
                      backgroundColor: AppColor.red,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.underdevelopment);
                  },
                  child: Icon(
                    Icons.notifications_none,
                    color: AppColor.textblack,
                  ),
                ),
              ),
            ],
          ),
          body: home(context)),
    );
  }
}
