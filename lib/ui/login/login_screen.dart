import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/auth/social_login.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/dashboard/dashboard_screen.dart';
import 'package:todo_app/ui/signup/signup_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = "";
  bool isChangeButton = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var pwdController = TextEditingController();

  // Firebase email & password custom login
  redirectToHomeScreen() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      showLoading();
      loginWithEmail(
        context: context,
        email: emailController.text,
        password: pwdController.text,
        onSuccess: (value) async {
          saveUserData(
              email: emailController.text,
              logintype: "email",
              isuserlogged: true,
              facebookid: "",
              profileurl: "",
              name: "");
          hideLoading(true, Strings.successfullylogin);
          setState(() {
            isChangeButton = true;
          });
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                  child: const DashboradScreen(),
                  type: PageTransitionType.rightToLeft),
              (route) => false);
        },
        onError: (value) {
          hideLoading(false, value);
          setState(() {
            isChangeButton = false;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      color: MyTheme.primaryColor,
      home: Scaffold(
        appBar: AppBar(
          title: Strings.login.text.bold.center.xl4
              .color(MyTheme.darkBlusishColor)
              .make(),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: MyTheme.darkBlusishColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: MyTheme.primaryColor,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: MyTheme.darkBlusishColor),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Hero(
                      tag: "applogo",
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 40, 0, 10),
                        child: Image.asset(AppAssets.applogoBlueIcon).wh(150, 150),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: (value) {
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.toString());
                            if (!emailValid) {
                              return Strings.errentervalidemail;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              hintText: Strings.hintenteryourregistereamil,
                              labelText: Strings.email),
                          onChanged: (value) {
                            name = value;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: pwdController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            prefixIcon: Icon(Icons.lock_outline),
                            hintText: Strings.hintenteryourpassword,
                            labelText: Strings.password,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Strings.errenteryourpassword;
                            } else if (value.length < 6) {
                              return Strings.errpasswordlength;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  loginButtonWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  signupButtonWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButtonWidget() {
    return InkWell(
      onTap: () {
        redirectToHomeScreen();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: isChangeButton ? 50 : MediaQuery.of(context).size.width,
        height: 50,
        alignment: Alignment.center,
        child: isChangeButton
            ? const Icon(Icons.done, color: Colors.white)
            : const Text(
                Strings.login,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
        decoration: BoxDecoration(
          color: MyTheme.primaryColor,
          borderRadius: BorderRadius.circular(
            isChangeButton ? 30 : 50,
          ),
        ),
      ),
    );
  }

  Widget signupButtonWidget() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: MyTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            )),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
                child: const SignupScreen(),
                type: PageTransitionType.rightToLeft),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: Strings.signup.text.bold.xl.make(),
        )).wh(
      MediaQuery.of(context).size.width,
      50,
    );
  }
}
