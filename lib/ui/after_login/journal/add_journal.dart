import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_globalmethods.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:grace_app_project/widgets/textformfields.dart';

class AddJournalScreen extends StatefulWidget {
  @override
  _AddJournalScreenState createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  FocusNode _titleFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  bool _autoValidate = false;
  var uid, id;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future _getCurrentUser() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      uid = (await _firebaseAuth.currentUser()).uid;

      setState(() {
        id = uid;
      });
    } catch (e) {
      print(e);
    }
  }

  Widget addjournal(BuildContext context) {
    var _blankfocusnode = new FocusNode();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(_blankfocusnode);
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 230, bottom: 10),
                      child: Text(
                        AppStrings.Title,
                        style:
                            TextStyle(color: AppColor.textwhite, fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 8,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: AppTextFromField(
                        controller: _titleController,
                        validator: AppMethods.validatetext,
                        focusNode: _titleFocusNode,
                        onFieldSubmitted: (_) {
                          AppMethods.fieldFocusChange(
                              context, _titleFocusNode, _descriptionFocusNode);
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 200, bottom: 10),
                      child: Text(
                        AppStrings.Description,
                        style:
                            TextStyle(color: AppColor.textwhite, fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: AppTextFromField(
                        controller: _descriptionController,
                        validator: AppMethods.validatetext,
                        focusNode: _descriptionFocusNode,
                        keyboardType: TextInputType.multiline,
                        hintText: AppStrings.writehere,
                        maxlines: 700,
                      ),
                    ),
                  ],
                ),
              ),
            ])),
      ),
    );
  }

  void _addjournal() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_titleController.text != null &&
          _descriptionController.text != null) {
        try {
          DatabaseService().createJournal(
              _titleController.text, _descriptionController.text, id);
          Navigator.pushReplacementNamed(context, AppRoutes.journal);
        } catch (e) {
          print(e);
        }
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          titleSpacing: 2,
          backgroundColor: AppColor.blueaccent100,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                AppStrings.Journal3,
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.textwhite,
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
                color: AppColor.textwhite,
              ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: GestureDetector(
                onTap: () {
                  _addjournal();
                },
                child: Icon(
                  Icons.check,
                  color: AppColor.textwhite,
                ),
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
      ),
      backgroundColor: AppColor.blueaccent100,
      body: addjournal(context),
    );
  }
}
