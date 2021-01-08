import 'dart:core';
import 'package:flutter/material.dart';
import 'package:grace_app_project/ui/after_login/bottom_navigation.dart';
import 'package:grace_app_project/ui/after_login/chat/chat.dart';
import 'package:grace_app_project/ui/after_login/chat/chat_listing.dart';
import 'package:grace_app_project/ui/after_login/chat/chat_ongoing.dart';
import 'package:grace_app_project/ui/after_login/chat/user_list.dart';
import 'package:grace_app_project/ui/after_login/journal/add_journal.dart';
import 'package:grace_app_project/ui/after_login/journal/edit_journal.dart';
import 'package:grace_app_project/ui/after_login/journal/journal.dart';
import 'package:grace_app_project/ui/after_login/journal/updated_journal.dart';
import 'package:grace_app_project/ui/after_login/profile/edit_profile.dart';
import 'package:grace_app_project/ui/after_login/profile/my_profile.dart';
import 'package:grace_app_project/ui/onboarding/account_verification.dart';
import 'package:grace_app_project/ui/onboarding/forget_password_screen.dart';
import 'package:grace_app_project/ui/onboarding/sign_in_screen.dart';
import 'package:grace_app_project/ui/onboarding/sign_up_screen.dart';
import 'package:grace_app_project/ui/onboarding/splash_screen.dart';
import 'package:grace_app_project/ui/onboarding/welcome_screen.dart';

import 'package:grace_app_project/ui/underdevelopment_page/under_develpoment.dart';
import 'package:grace_app_project/ui/underdevelopment_page/underdevelopment_afterlogin.dart';

class AppRoutes {
  AppRoutes._();

  static const String splashscreen = '/splash';
  static const String signup = '/signup';
  static const String signin = '/signin';
  static const String forgetpassword = '/forgetpassword';
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String journal = '/journal';
  static const String addjournal = '/addjournal';
  static const String editjournal = '/editjournal';
  static const String myprofile = '/myprofile';
  static const String editprofile = '/editprofile';

  static const String chat = '/chat';
  static const String userlist = '/userlist';
  static const String chatlisting = '/chatlisting';
  static const String nointernet = '/nointernet';
  static const String chatongoinglisting = '/chatongoinglisting';
  static const String accountverification = '/accountverification';
  static const String underdevelopment = '/underdevelopment';
  static const String underdevelopmentafterlogin =
      '/underdevelopmentafterlogin';

  static final routes = <String, WidgetBuilder>{
    splashscreen: (BuildContext context) => SplashScreen(),
    signup: (BuildContext context) => SignUp(),
    signin: (BuildContext context) => SignIn(),
    home: (BuildContext context) => Home(),
    journal: (BuildContext context) => JournalScreen(),
    addjournal: (BuildContext context) => AddJournalScreen(),
    editjournal: (BuildContext context) => EditJournalScreen(),
    welcome: (BuildContext context) => WelcomeScreen(),
    myprofile: (BuildContext context) => MyProfile(),
    editprofile: (BuildContext context) => EditProfile(),
    chat: (BuildContext context) => ChatScreen(),
    chatlisting: (BuildContext context) => ChatListingScreen(),
    userlist: (BuildContext context) => UserListingScreen(),
    chatongoinglisting: (BuildContext context) => ChatOngoingScreen(),
    forgetpassword: (BuildContext context) => Forgetpassword(),
    accountverification: (BuildContext context) => AccountVerification(),
    underdevelopment: (BuildContext context) => UnderDevelopmentScreen(),
    underdevelopmentafterlogin: (BuildContext context) =>
        UnderDevelopmentAfterLoginScreen(),
  };
}
