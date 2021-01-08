import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grace_app_project/services/auth.dart';
import 'package:grace_app_project/ui/after_login/chat/chat.dart';
import 'package:grace_app_project/ui/after_login/home.dart';
import 'package:grace_app_project/ui/after_login/journal/journal.dart';
import 'package:grace_app_project/ui/after_login/more/side_menu.dart';
import 'package:grace_app_project/ui/underdevelopment_page/underdevelopment_afterlogin.dart';
import 'package:grace_app_project/utils/app_resources/app_colors.dart';
import 'package:grace_app_project/utils/app_resources/app_strings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

enum MenuOption { Edit, Delete }

class _HomeState extends State<Home> {
  int _currenttab = 0;

  final List<Widget> _children = [
    HomeScreen(),
    UnderDevelopmentAfterLoginScreen(),
    ChatScreen(),
    JournalScreen(),
    SideMenuScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currenttab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            bottomNavigationBar: new BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text(AppStrings.Home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.card_membership),
                  title: Text(AppStrings.Learn),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  title: Text(AppStrings.Chat),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.collections_bookmark),
                  title: Text(AppStrings.Journal),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz),
                  title: Text(AppStrings.More),
                ),
              ],
              currentIndex: _currenttab,
              unselectedItemColor: AppColor.textscolorgrey,
              showUnselectedLabels: true,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
            body: _children[_currenttab]));
  }
}
