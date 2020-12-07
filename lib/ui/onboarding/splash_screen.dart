import 'package:flutter/material.dart';
import 'package:grace_app_project/model/user.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_images.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      final _firebaseUser = Provider.of<User>(context);
      if (_firebaseUser != null) {
        return Navigator.pushNamed(context, AppRoutes.home);
      }
      return Navigator.pushNamed(context, AppRoutes.welcome);
    });
  }

  Widget splash(BuildContext context) {
    return Center(
        child: Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height / 2.5),
        Image.asset(
          AppAssets.splashlogo,
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.height / 6,
        ),
      ],
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundcolor, body: splash(context));
  }
}
