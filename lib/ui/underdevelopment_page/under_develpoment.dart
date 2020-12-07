import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class UnderDevelopmentScreen extends StatefulWidget {
  @override
  _UnderDevelopmentScreenState createState() => _UnderDevelopmentScreenState();
}

class _UnderDevelopmentScreenState extends State<UnderDevelopmentScreen> {
  Widget underdevelopment(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height / 2.5),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              AppStrings.underdevelopment,
              style: TextStyle(color: AppColor.textwhite, fontSize: 25),
              textAlign: TextAlign.justify,
            ),
          ),
        )
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.backgroundcolor,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
        backgroundColor: AppColor.backgroundcolor,
        body: underdevelopment(context));
  }
}
