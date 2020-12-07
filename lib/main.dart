import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grace_app_project/model/user.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/ui/onboarding/splash_screen.dart';
import 'package:grace_app_project/utils/app_resources/app_routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthenticationService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        home: SplashScreen(),
      ),
    );
  }
}
