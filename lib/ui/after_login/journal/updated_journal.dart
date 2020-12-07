import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/services/database.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';
import 'package:intl/intl.dart';

class UpdatedJournalScreen extends StatefulWidget {
  @override
  _UpdatedJournalScreenState createState() => _UpdatedJournalScreenState();
}

class _UpdatedJournalScreenState extends State<UpdatedJournalScreen> {
  final AuthenticationService _authenticationService = AuthenticationService();
  DatabaseService _databaseService = DatabaseService();
  DateTime _dateTimebefore;
  String dateTimeAfter;
  Future _getJournal() async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      var id = (await _firebaseAuth.currentUser()).uid;
      QuerySnapshot querySnapshot = await Firestore.instance
          .collection('journal')
          .document(id)
          .collection('user_journal')
          .getDocuments();
      for (int i = 0; i < querySnapshot.documents.length; i++) {}
    } catch (e) {
      return e.message;
    }
  }

  @override
  initState() {
    super.initState();
    _getJournal();
  }

  _getdate(DateTime input) {
    var _formatter = new DateFormat('dd MMMM yyyy');
    String _formattedTime = DateFormat('k:mm a').format(input);
    String _formattedDate = _formatter.format(input);
    dateTimeAfter = _formattedDate + "|" + _formattedTime;
    return dateTimeAfter;
  }

  Widget updatedjournal(BuildContext context) {
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
                child: FutureBuilder(
                    future: _authenticationService.getJournal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var journal = snapshot.data;
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: journal.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                var title =
                                    journal.documents[index].data['title'];
                                var description = journal
                                    .documents[index].data['description'];
                                var id = journal.documents[index].data['id'];
                                Timestamp timestamp =
                                    journal.documents[index].data['created'];
                                _dateTimebefore = timestamp.toDate();
                                _getdate(_dateTimebefore);
                                return GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                            context, AppRoutes.editjournal,
                                            arguments: {
                                              'description': description,
                                              'title': title,
                                              'datetime': dateTimeAfter,
                                              'id': id
                                            }),
                                    child: Dismissible(
                                      key: ObjectKey(
                                          journal.documents[index].data.keys),
                                      direction: DismissDirection.startToEnd,
                                      onDismissed: (direction) {
                                        _databaseService.deleteJournal(id);
                                        _getJournal();
                                      },
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, top: 20, right: 20),
                                          child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                color: AppColor.textwhite,
                                                border: Border.all(
                                                    color: AppColor.grey300),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              top: 0,
                                                              right: 20,
                                                            ),
                                                            child: Stack(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    width: 60,
                                                                    height: 100,
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          AppColor
                                                                              .cyan200,
                                                                          AppColor
                                                                              .blue50
                                                                        ],
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight,
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                        '  ')),
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                    child: Icon(
                                                                      Icons
                                                                          .speaker_notes,
                                                                      color: AppColor
                                                                          .textwhite,
                                                                      size: 30,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                title ?? "",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .textgrey,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 5.0),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.45,
                                                              child: Text(
                                                                dateTimeAfter ??
                                                                    " ",
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColor
                                                                      .bluegrey,
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 40.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () =>
                                                                Navigator.pushNamed(
                                                                    context,
                                                                    AppRoutes
                                                                        .editjournal,
                                                                    arguments: {
                                                                      'description':
                                                                          description,
                                                                      'title':
                                                                          title,
                                                                      'datetime':
                                                                          dateTimeAfter
                                                                    }),
                                                            child: Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color:
                                                                  AppColor.blue,
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ])),
                                        ),
                                      ),
                                    ));
                              });
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: AppBar(
              elevation: 0,
              backgroundColor: AppColor.backgroundcolor,
              title: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    AppStrings.Journal1,
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
                    Navigator.pushNamed(context, AppRoutes.underdevelopment);
                  },
                  child: Icon(
                    Icons.search,
                    color: AppColor.textwhite,
                  ),
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: CircleAvatar(
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                          AppAssets.calender,
                        ),
                        radius: 16,
                        backgroundColor: AppColor.textwhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
          body: updatedjournal(context)),
    );
  }
}
