import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/pref/shared_pref.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:todo_app/ui/wlecome/welcome_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      bool? isLoggedIn = await getPrefBoolData(Constant.isUserLoggedInStr);
      // if user logged redirect to dashboard screen
      if (isLoggedIn == true) {
        Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                child: const DashboradScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      } else {
        // if user not logged redirect to welcome screen
        Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
                child: const WelomeScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Constant.configLoading();

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
              tag: "applogo",
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Image.asset(AppAssets.applogoBlueIcon).wh(200, 200),
              )),
        ],
      ),
    );
  }
}
