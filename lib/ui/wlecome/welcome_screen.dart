import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/auth/social_login.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:todo_app/ui/wlecome/widgets/login_with_button.dart';
import 'package:velocity_x/velocity_x.dart';

class WelomeScreen extends StatefulWidget {
  const WelomeScreen({Key? key}) : super(key: key);

  @override
  State<WelomeScreen> createState() => _WelomeScreenState();
}

class _WelomeScreenState extends State<WelomeScreen> {
  // Signin with facebook

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showLoading() {
    EasyLoading.show(status: Strings.loading);
  }

  void dismissLoading() {
    EasyLoading.dismiss();
  }

  void hideLoading(bool isSucuess, String message) {
    EasyLoading.dismiss();
    if (isSucuess) {
      EasyLoading.showSuccess(message);
    } else {
      EasyLoading.showError(message);
    }
  }

  void nextScreen() {
    Timer(const Duration(seconds: 1), () async {
      Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
              child: const DashboradScreen(),
              type: PageTransitionType.rightToLeft),
          (route) => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      color: Colors.white,
      home: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Strings.welcome.text.black.xl4.bold.make(),
          Container(
            child: Image.asset(AppAssets.logincenterImg),
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Column(
            children: [
              Strings.pleaselogintoorganisingday.text.black.lg.bold.center
                  .make(),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                child: Column(
                  children: [
                    loginWithButtonWidget(
                      context: context,
                      title: Strings.loginwithemail,
                      iconPath: AppAssets.loginwithemailIcon,
                      bgColor: Colors.grey,
                      shadowColor: Colors.grey,
                      callback: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: const LoginScreen(),
                                type: PageTransitionType.rightToLeft),
                            (route) => true);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    loginWithButtonWidget(
                      context: context,
                      title: Strings.loginwithgoogle,
                      iconPath: AppAssets.loginwithgoogleIcon,
                      bgColor: Colors.red,
                      shadowColor: Colors.red,
                      callback: () {
                        showLoading();
                        loginWithGoogle(
                          context: context,
                          onSuccess: (value) {
                            dismissLoading();
                            hideLoading(true, Strings.successfullyloginenjoyapp);
                            nextScreen();
                          },
                          onError: (value) {
                            dismissLoading();
                            hideLoading(false, value);
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    loginWithButtonWidget(
                      context: context,
                      title: Strings.loginwithfacebook,
                      iconPath: AppAssets.loginwithfacebookIcon,
                      bgColor: const Color(0xff2F58E2),
                      shadowColor: Colors.blue,
                      callback: () {
                        showLoading();
                        loginwithFacebook(
                          context: context,
                          onSuccess: (value) {
                            dismissLoading();
                            hideLoading(
                                true, Strings.successfullyloginenjoyapp);
                            nextScreen();
                          },
                          onError: (value) {
                            dismissLoading();
                            hideLoading(false, value);
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


