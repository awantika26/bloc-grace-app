import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class EditJournalScreen extends StatefulWidget {
  @override
  _EditJournalScreenState createState() => _EditJournalScreenState();
}

class _EditJournalScreenState extends State<EditJournalScreen> {
  TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map arguments;
  FocusNode _focusNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _edit = false, _autoValidate = false;
  DatabaseService _databaseService = DatabaseService();
  String _description, _journalID = "";

  Future getJournal() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var id = (await _firebaseAuth.currentUser()).uid;
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('journal')
          .document(id)
          .collection('user_journal')
          .getDocuments();
      for (int i = 0; i < querySnapshot.documents.length; i++) {
        var a = querySnapshot.documents[i];
        _journalID = a.documentID;
        print(_journalID);
      }
    } catch (e) {
      return e.message;
    }
  }

  @override
  initState() {
    super.initState();
    getJournal();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _saveJournal() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_descriptionController.text != null) {
        try {
          arguments = ModalRoute.of(context).settings.arguments as Map;

          _databaseService.updateJournal(arguments['id'], _description);

          Navigator.pushNamed(context, AppRoutes.journal);
        } catch (e) {}
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  Widget journal(BuildContext context) {
    var _blankfocusnode = new FocusNode();
    arguments = ModalRoute.of(context).settings.arguments as Map;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_blankfocusnode);
      },
      child: Column(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 20),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(20),
                  child: Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height / 1.3,
                        width: MediaQuery.of(context).size.width,
                        color: AppColor.textwhite,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: AppColor.blue,
                                  ),
                                ),
                                Text(
                                  arguments['datetime'] ?? " -",
                                  style: TextStyle(color: AppColor.blue),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 200.0),
                              child: Text(
                                AppStrings.Description,
                                style: TextStyle(color: AppColor.textgrey),
                              ),
                            ),
                            _edit == false
                                ? Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SingleChildScrollView(
                                        child: Text(
                                          arguments['description'] ?? " ",
                                          style: TextStyle(
                                              color: AppColor.textblack),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ),
                                  )
                                : Form(
                                    key: _formKey,
                                    autovalidate: _autoValidate,
                                    child: Column(children: <Widget>[
                                      Center(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              2,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextFormField(
                                            controller: _descriptionController,
                                            validator: AppMethods.validatetext,
                                            textInputAction:
                                                TextInputAction.newline,
                                            maxLines: 2000,
                                            onSaved: (val) {
                                              _description = val;
                                            },
                                          ),
                                        ),
                                      ),
                                    ])),
                          ],
                        )),
                  ),
                )),
          ),
          Text(
            AppStrings.pages,
            style: TextStyle(
                color: AppColor.textwhite, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.blueaccent100,
            title: Center(
              child: Text(
                arguments['title'] ?? " ",
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.textwhite,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColor.textwhite,
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _edit = true;
                      setState(() {
                        _descriptionController.text = arguments['description'];
                      });
                    });
                  },
                  child: Image.asset(
                    AppAssets.edit,
                    width: 20,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      if (_edit == false) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(AppStrings.editjournal),
                          duration: Duration(seconds: 3),
                        ));
                      } else {
                        _saveJournal();
                      }
                    },
                    child: Icon(Icons.check)),
              ),
            ],
          ),
        ),
        backgroundColor: AppColor.blueaccent100,
        body: journal(context));
  }
}
