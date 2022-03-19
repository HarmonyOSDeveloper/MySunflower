import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mysunflower/addorremove.dart';
import 'package:mysunflower/harmony_nav1_icons.dart';
import 'package:mysunflower/history.dart';
import 'package:mysunflower/home.dart';
import 'package:mysunflower/my.dart';
import 'package:mysunflower/screen_management/screen_manager.dart';
import 'package:provider/provider.dart';

import 'user_config/my_button.dart';

var api2;

class NavBase extends StatefulWidget {
  final api;
  final user;

  const NavBase({Key? key, required this.api, required this.user})
      : super(key: key);
  @override
  _NavBaseState createState() => _NavBaseState();
}

class _NavBaseState extends State<NavBase> {
  late final List<Widget> _children;
  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _children = [
      HomePage(api: widget.api, user: widget.user),
      MoneyMgr(api:widget.api,user: widget.user,),
      History(
        api: widget.api,
        user: widget.user,
      ),
      MyScreen(user: widget.user, api: widget.api)
    ];
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final isTablet = shortestSide > 550;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<ScreenManager>(
        builder: (context, screenManager, child) => (isTablet && !isPortrait)
            ? Scaffold(
                body:
                    buildTabletHorizontal(isTablet, isPortrait, screenManager),
                //floatingActionButton: buildReportBug(context)
              )
            : Scaffold(
                body: Container(child: _children[screenManager.screenIndex]),
                floatingActionButton: buildReportBug(context),
                bottomNavigationBar:
                    buildBottomNav(isTablet, isPortrait, screenManager)),
      ),
    );
  }

  buildReportBug(BuildContext context) {
    return Container(
      height: 37,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 10,
            blurRadius: 50,
            offset: Offset(3, 5),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        elevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, '/bug');
        },
        label: Text("Report A Bug",
            style: TextStyle(
                letterSpacing: .5, fontSize: 15, color: Colors.black)),
      ),
    );
  }

  buildTabletNavBtn(
    int buttonId,
    IconData iconData,
    String label,
    ScreenManager screenManager,
  ) {
    return TextButton(
        onPressed: () {
          screenManager.changeScreen(buttonId);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)))),
            minimumSize: MaterialStateProperty.all(Size(90, 45)),
            foregroundColor: (buttonId == screenManager.screenIndex)
                ? MaterialStateProperty.all(Color.fromARGB(255, 10, 89, 247))
                : MaterialStateProperty.all(
                    Color.fromARGB(255, 144, 145, 147))),
        child:
            Row(children: [Icon(iconData), SizedBox(width: 5), Text(label)]));
  }

  buildPhoneNavBtn(
    int buttonId,
    IconData iconData,
    String label,
    ScreenManager screenManager,
  ) {
    //Build Phone Bottom Nav Buttons
    return MyButton(
        onPressed: () {
          screenManager.changeScreen(buttonId);
        },
        backgroundColor: Colors.transparent,
        borderRadius: 7,
        height: 50,
        textColor: buttonId == screenManager.screenIndex
            ? Color.fromARGB(255, 10, 89, 247)
            : Color.fromARGB(255, 144, 145, 147),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(iconData,
              color: buttonId == screenManager.screenIndex
                  ? Color.fromARGB(255, 10, 89, 247)
                  : Color.fromARGB(255, 144, 145, 147)),
          //SizedBox(width: 5),
          Text(label)
        ]));
  }

  buildTablet2NavBtn(
    int buttonId,
    IconData iconData,
    String label,
    ScreenManager screenManager,
  ) {
    //Build Phone Bottom Nav Buttons
    return TextButton(
        onPressed: () {
          screenManager.changeScreen(buttonId);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)))),
            minimumSize: MaterialStateProperty.all(Size(100, 100)),
            foregroundColor: (buttonId == screenManager.screenIndex)
                ? MaterialStateProperty.all(Color.fromARGB(255, 10, 89, 247))
                : MaterialStateProperty.all(
                    Color.fromARGB(255, 144, 145, 147))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(iconData),
          //SizedBox(width: 5),
          Text(label)
        ]));
  }

  bottomNavPhone(ScreenManager screenManager) {
    return Container(
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            //NavBar Item
            Row(
              children: [
                buildPhoneNavBtn(
                    0, HarmonyNav1.ic_public_home, 'Home', screenManager),
                Spacer(),
                buildPhoneNavBtn(1, Icons.attach_money_rounded, 'Transactions',
                    screenManager),
                Spacer(),
                buildPhoneNavBtn(2, Icons.history, 'History', screenManager),
                Spacer(),
                buildPhoneNavBtn(
                    3, Icons.account_circle_rounded, 'My', screenManager),
              ],
            )
          ]),
    );
  }

  bottomNavTabletVerical(ScreenManager screenManager) {
    return Container(
        height: 40,
        width: double.infinity,
        child: Column(children: [
          //NavBar Item
          Container(
            height: 39,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Row(
                children: [
                  buildTabletNavBtn(0, Icons.home, 'Home', screenManager),
                  Spacer(),
                  buildTabletNavBtn(1, Icons.attach_money_rounded,
                      'Transactions', screenManager),
                  Spacer(),
                  buildTabletNavBtn(2, Icons.history, 'History', screenManager),
                  Spacer(),
                  buildTabletNavBtn(
                      3, Icons.account_circle_rounded, 'My', screenManager),
                ],
              ),
            ),
          )
        ]));
  }

  bottomNavTabletHorizontal(ScreenManager screenManager) {
    return Container(
        height: double.infinity,
        width: 97,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //NavBar Item
          Container(
            height: 500,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTablet2NavBtn(0, Icons.home, 'Home', screenManager),
                Spacer(),
                buildTablet2NavBtn(1, Icons.attach_money_rounded,
                    'Transactions', screenManager),
                Spacer(),
                buildTablet2NavBtn(2, Icons.history, 'History', screenManager),
                Spacer(),
                buildTablet2NavBtn(
                    3, Icons.account_circle_rounded, 'My', screenManager),
              ],
            ),
          )
        ]));
  }

  buildBottomNav(bool isTablet, bool isPortrait, ScreenManager screenManager) {
    if (!isTablet) {
      return bottomNavPhone(screenManager);
    } else if (isTablet && isPortrait) {
      return bottomNavTabletVerical(screenManager);
    } else {
      return bottomNavTabletHorizontal(screenManager);
    }
  }

  buildTabletHorizontal(
      bool isTablet, bool isPortrait, ScreenManager screenManager) {
    return Row(
      children: [
        buildBottomNav(isTablet, isPortrait, screenManager),
        Expanded(child: _children[screenManager.screenIndex]),
      ],
    );
  }
}
