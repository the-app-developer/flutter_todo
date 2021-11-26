import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/pref/shared_pref.dart';

class Utils {
  static void clearPrefLoginData() {
    savePrefBoolData(Constant.isUserLoggedInStr, false);
    removePrefData(Constant.email);
    removePrefData(Constant.name);
    removePrefData(Constant.userProfileUrl);
  }

  static void redirectToNextScreen(BuildContext context, Widget routeWidget) {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            child: routeWidget, type: PageTransitionType.rightToLeft),
        (route) => false);
  }

  static void redirectToScreen(BuildContext context, Widget routeWidget) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: routeWidget,
      ),
    );
  }
}
