import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/widgets/textformfields.dart';

class UserListingScreen extends StatefulWidget {
  @override
  _UserListingScreenState createState() => _UserListingScreenState();
}

class _UserListingScreenState extends State<UserListingScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  var _url, myimage, _id, _uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  bool _autoValidate = false;
  FocusNode _searchFocusNode = FocusNode();
  QuerySnapshot _searchsnapshot;

  _controlSearching() {
    _authenticationService.getUsername(_searchController.text).then((val) {
      setState(() {
        _searchsnapshot = val;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future _getCurrentUser() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      _uid = (await _firebaseAuth.currentUser()).uid;

      setState(() {
        _id = _uid;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget userlist(BuildContext context) {
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
              child: Column(children: <Widget>[
                Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Column(children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: AppTextFromField(
                                controller: _searchController,
                                validator: AppMethods.validatetext,
                                focusNode: _searchFocusNode,
                                keyboardType: TextInputType.text,
                                hintText: AppStrings.searchuser,
                                suffixIcon: FlatButton(
                                  child: Icon(Icons.close),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                ),
                                prefixicon: FlatButton(
                                  child: Icon(Icons.search),
                                  onPressed: null,
                                ),
                                onFieldSubmitted: (val) {
                                  _controlSearching();
                                }),
                          ),
                        ),
                      ),
                    ])),
                _searchsnapshot == null
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('grace')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError)
                                return new Text('Error: ${snapshot.error}');
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return new Text(AppStrings.Loading);
                                default:
                                  return ListView(
                                    children: snapshot.data.documents
                                        .map((DocumentSnapshot document) {
                                      if (document['url'] != null) {
                                        _url = document['url'].split("'");
                                        myimage = _url[1];
                                      }
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                AppRoutes.chatongoinglisting,
                                                arguments: {
                                                  'username':
                                                      document['username'],
                                                  'id': document['id'],
                                                  'image': myimage,
                                                });
                                          },
                                          child: document['id'] != _id
                                              ? ListTile(
                                                  leading: myimage != null
                                                      ? CircleAvatar(
                                                          radius: 35,
                                                          backgroundImage:
                                                              AssetImage(
                                                                  myimage),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 35,
                                                          backgroundImage:
                                                              AssetImage(AppAssets
                                                                  .faceimage1),
                                                        ),
                                                  title: new Text(
                                                      document['username']),
                                                )
                                              : Container(
                                                  height: 0,
                                                ));
                                    }).toList(),
                                  );
                              }
                            }))
                    : Expanded(
                        child: ListView.builder(
                        itemCount: _searchsnapshot.documents.length,
                        itemBuilder: (context, i) {
                          if (_searchsnapshot.documents[i].data['url'] !=
                              null) {
                            _url = _searchsnapshot.documents[i].data['url']
                                .split("'");
                            myimage = _url[1];
                          }
                          if (_searchController.text ==
                              _searchsnapshot.documents[i].data['username'])
                            return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.chatongoinglisting,
                                      arguments: {
                                        'username': _searchsnapshot
                                            .documents[i].data['username'],
                                        'id': _searchsnapshot
                                            .documents[i].data['id'],
                                        'image': myimage
                                      });
                                },
                                child:
                                    _searchsnapshot.documents[i].data['id'] !=
                                            _id
                                        ? ListTile(
                                            leading: myimage != null
                                                ? CircleAvatar(
                                                    radius: 35,
                                                    backgroundImage:
                                                        AssetImage(myimage),
                                                  )
                                                : CircleAvatar(
                                                    radius: 35,
                                                    backgroundImage: AssetImage(
                                                        AppAssets.faceimage1),
                                                  ),
                                            title: new Text(_searchsnapshot
                                                .documents[i].data['username']),
                                          )
                                        : Container(
                                            height: 0,
                                          ));
                          else
                            return Text(AppStrings.nouser);
                        },
                      ))
              ]),
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.backgroundcolor,
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 40),
                child: Text(
                  AppStrings.newChat,
                  style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textwhite,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            centerTitle: true,
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
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.home,
                    );
                  },
                  child: Icon(
                    Icons.home,
                    color: AppColor.textwhite,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor.backgroundcolor,
        body: userlist(context));
  }
}
