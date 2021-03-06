import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var university,
      mobile,
      dorm,
      location,
      email,
      id,
      _imageurl,
      _photo,
      _username,
      _picture,
      _name,
      _length;

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
      var a = querySnapshot.documents[i];
      setState(() {
        university = a.data['university'];
        mobile = a.data['mobile'];
        dorm = a.data['dorm'];
        location = a.data['location'];
        email = a.data['email'];
        id = a.data['id'];
      });
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
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        _length = querySnapshot.documents.length;
      }
    } catch (e) {
      return e.message;
    }
  }

  Widget profile(BuildContext context) {
    _getCurrentUser();
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: _imageurl != null
                        ? CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(_imageurl),
                          )
                        : CircleAvatar(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Icon(Icons.photo_camera)),
                          )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Text(
                      _username ?? " ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.textblack,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Text(
                                _length.toString() == 'null'
                                    ? '0'
                                    : _length.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.textgrey,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Text(
                                AppStrings.Journal,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.textblack,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
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
                  padding: const EdgeInsets.only(right: 240, top: 10),
                  child: Text(
                    AppStrings.University,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textgrey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 10, left: 40),
                  child: Text(
                    university ?? " ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 270, top: 10),
                  child: Text(
                    AppStrings.Dorm,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textgrey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 10, left: 40),
                  child: Text(
                    dorm ?? " ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 10),
                  child: Text(
                    AppStrings.Universitye,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textgrey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 80,
                    top: 10,
                  ),
                  child: Text(
                    email ?? " ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 250, top: 10),
                  child: Text(
                    AppStrings.Location,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textgrey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 10, left: 40),
                  child: Text(
                    location ?? " ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 260, top: 10),
                  child: Text(
                    AppStrings.Mobile,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textgrey,
                      fontSize: 17.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 140, top: 10),
                  child: Text(
                    mobile ?? " ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.textblack,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.textwhite,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  AppStrings.Profile,
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
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.editprofile,
                      arguments: {
                        'university': university,
                        'mobile': mobile,
                        'dorm': dorm,
                        'location': location,
                        'email': email,
                        'id': id
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 10),
                  child: Image.asset(
                    AppAssets.edit,
                    width: 20,
                    height: 30,
                    fit: BoxFit.contain,
                    color: AppColor.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor.textwhite,
        body: profile(context));
  }
}
