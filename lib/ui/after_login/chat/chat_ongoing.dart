import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/widgets/textformfields.dart';
import 'package:intl/intl.dart';

class ChatOngoingScreen extends StatefulWidget {
  @override
  _ChatOngoingScreenState createState() => _ChatOngoingScreenState();
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.bluegrey50,
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          color: sendByMe ? AppColor.backgroundcolor : AppColor.textwhite,
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: sendByMe ? AppColor.textwhite : AppColor.textblack,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}

class _ChatOngoingScreenState extends State<ChatOngoingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _chatController = TextEditingController();
  Firestore _firestore = Firestore.instance;
  Map arguments;
  DateTime _dateTime;
  bool _autoValidate = false;
  var time, text, _from, groupchatId, userId, message, senderId;

  Future _getCurrentID() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      userId = (await _firebaseAuth.currentUser()).uid;
      arguments = ModalRoute.of(context).settings.arguments as Map;

      String anotheruserid = arguments['id'];
      if (userId.compareTo(anotheruserid) > 0) {
        groupchatId = '$userId -$anotheruserid';
      } else {
        groupchatId = '$anotheruserid -$userId';
      }
      setState(() {});
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _getCurrentID();
  }

  _getdate(DateTime input) {
    String _formattedTime = DateFormat('k:mm a').format(input);
    time = _formattedTime;
    return time;
  }

  void _send() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_chatController.text != null) {
        try {
          arguments = ModalRoute.of(context).settings.arguments as Map;
          setState(() {
            message = _chatController.text.trim();
          });
          var ref = Firestore.instance
              .collection('messages')
              .document(groupchatId)
              .collection(groupchatId)
              .document(DateTime.now().millisecondsSinceEpoch.toString());

          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(ref, {
              'senderId': userId,
              'content': message,
              'anotheruserid': arguments['id'],
              'timestamp': DateTime.now(),
              'type': 'text',
              'anotherusername': arguments['username'],
              'anotheruserimage': arguments['image']
            });
          });
          var ref1 = Firestore.instance
              .collection('inbox')
              .document(userId)
              .collection(userId)
              .document(groupchatId);

          Firestore.instance.runTransaction((transaction) async {
            await transaction.set(ref1, {
              'chatroomId': groupchatId,
              'anotheruserid': arguments['id'],
            });
          });
          setState(() {
            _chatController.text = "";
          });

          Navigator.pushNamed(context, AppRoutes.chatlisting, arguments: {
            'to': arguments['id'],
            'from': userId,
            'message': message,
            'groupchatid': groupchatId,
            'time': time,
          });
        } catch (e) {}
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget chatongoing(BuildContext context) {
    var _blankfocusnode1 = new FocusNode();

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_blankfocusnode1),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.bluegrey50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .document(groupchatId)
                    .collection(groupchatId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 15.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        _from = snapshot
                            .data.documents[index].data['anotheruserid'];
                        text = snapshot.data.documents[index].data['content'];
                        senderId =
                            snapshot.data.documents[index].data['senderId'];
                        Timestamp t =
                            snapshot.data.documents[index].data['timestamp'];

                        _dateTime = t.toDate();
                        _getdate(_dateTime);

                        return MessageTile(
                          message: text,
                          sendByMe: _from != userId,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: AppColor.bluegrey50,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(children: <Widget>[
                    Center(
                      child: AppTextFromField(
                        controller: _chatController,
                        validator: AppMethods.validatetext,
                        keyboardType: TextInputType.text,
                        hintText: AppStrings.typing,
                      ),
                    ),
                  ]))),
          CircleAvatar(
            backgroundColor: AppColor.backgroundcolor,
            radius: 20,
            child: IconButton(
              icon: Icon(Icons.send),
              iconSize: 25.0,
              color: AppColor.textwhite,
              onPressed: () {
                _send();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.textwhite,
            leading: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: AppColor.textblack,
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 170),
                child: Text(
                  arguments['username'] ?? " ",
                  style: TextStyle(color: AppColor.textblack),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor.bluegrey50,
        body: chatongoing(context));
  }
}
