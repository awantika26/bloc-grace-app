import 'package:flutter/material.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class UnderDevelopmentAfterLoginScreen extends StatefulWidget {
  @override
  _UnderDevelopmentAfterLoginScreenState createState() =>
      _UnderDevelopmentAfterLoginScreenState();
}

class _UnderDevelopmentAfterLoginScreenState
    extends State<UnderDevelopmentAfterLoginScreen> {
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
        backgroundColor: AppColor.backgroundcolor,
        body: underdevelopment(context));
  }
}
