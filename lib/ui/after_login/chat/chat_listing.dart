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
import 'package:intl/intl.dart';

class ChatListingScreen extends StatefulWidget {
  @override
  _ChatListingScreenState createState() => _ChatListingScreenState();
}

class _ChatListingScreenState extends State<ChatListingScreen> {
  Firestore _firestore = Firestore.instance;
  var _myimage, _text, _username, _time, content, userId;
  DateTime _dateTime;

  _getdate(DateTime input) {
    String _formattedTime = DateFormat('k:mm a').format(input);
    _time = _formattedTime;
    return _time;
  }

  Future _getCurrentID() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      userId = (await _firebaseAuth.currentUser()).uid;
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _getCurrentID();
  }

  Widget chatlist(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('inbox')
          .document(userId)
          .collection(userId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: EdgeInsets.only(top: 15.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              _myimage =
                  snapshot.data.documents[index].data['anotheruserimage'];
              _username =
                  snapshot.data.documents[index].data['anotherusername'];
              _text = snapshot.data.documents[index].data['content'];
              Timestamp t = snapshot.data.documents[index].data['timestamp'];

              _dateTime = t.toDate();
              _getdate(_dateTime);

              return GestureDetector(
                  child: ListTile(
                leading: _myimage != null
                    ? CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(_myimage),
                      )
                    : CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage(AppAssets.faceimage1),
                      ),
                title: new Text(_username ?? " "),
                subtitle: Text(_text ?? "-"),
                trailing: Text(_time ?? "-"),
              ));
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              elevation: 0,
              backgroundColor: AppColor.backgroundcolor,
              leading: Text(''),
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 40),
                  child: Text(
                    AppStrings.Chat,
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColor.textwhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 10),
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
          backgroundColor: AppColor.textwhite,
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.userlist);
            },
            child: Image.asset(
              AppAssets.floatchat,
              fit: BoxFit.contain,
              width: 80,
              height: 80,
            ),
          ),
          body: chatlist(context)),
    );
  }
}
