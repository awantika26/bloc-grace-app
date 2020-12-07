import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget chat(BuildContext context) {
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
                        height: 90,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AppAssets.chat,
                          fit: BoxFit.contain,
                          height: 100,
                          width: 100,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          AppStrings.Chat1,
                          style: TextStyle(
                              fontSize: 20,
                              color: AppColor.textgrey,
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
                            Navigator.pushNamed(
                              context,
                              AppRoutes.userlist,
                            );
                          },
                          child: Text(
                            AppStrings.chatwith,
                          ),
                        ),
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
                AppStrings.Chat,
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.textwhite,
                    fontWeight: FontWeight.bold),
              ),
            ),
            leading: GestureDetector(
                child: Icon(Icons.home),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.home,
                  );
                }),
          ),
          backgroundColor: AppColor.backgroundcolor,
          body: chat(context)),
    );
  }
}
