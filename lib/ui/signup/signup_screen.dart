import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todo_app/auth/social_login.dart';
import 'package:todo_app/common/assets.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/common/strings.dart';
import 'package:todo_app/theme/app_theme.dart';
import 'package:todo_app/ui/login/login_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    Constant.configLoading();
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
          appBar: AppBar(
            title: Strings.signup.text.bold.center.xl4
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
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(color: MyTheme.darkBlusishColor),
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              children: [
                const SizedBox(
                  height: 20,
                ),
                Hero(
                    tag: "applogo",
                    child: Image.asset(AppAssets.applogoBlueIcon).wh(100, 100)),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: const SignupForm(),
                )
              ],
            ),
          )),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)));
  var space = const SizedBox(height: 20);
  final emailController = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
  final fnameController = TextEditingController();
  final mnameController = TextEditingController();
  final lnameController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextConfirmpwd = true;
  bool _isLoading = false;
  bool isPrivcyAgree = false;

  var confirmPwd;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  hintText: Strings.hintenteryouremail,
                  labelText: Strings.email,
                  border: border),
              validator: (value) {
                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value.toString());
                if (!emailValid) {
                  return Strings.errentervalidemail;
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            space,
            TextFormField(
              obscureText: _obscureText,
              controller: pass,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                  ),
                  hintText: Strings.hintenterpassword,
                  labelText: Strings.password,
                  border: border),
              validator: (value) {
                confirmPwd = value;
                if (value!.isEmpty) {
                  return Strings.errenterpassword;
                } else if (value.length < 6) {
                  return Strings.errpasswordlength;
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            space,
            TextFormField(
              obscureText: _obscureTextConfirmpwd,
              controller: confirmPass,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextConfirmpwd = !_obscureTextConfirmpwd;
                      });
                    },
                    child: Icon(_obscureTextConfirmpwd
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  hintText: Strings.errenterconfirmpassword,
                  labelText: Strings.confirmpassword,
                  border: border),
              validator: (value) {
                if (value!.isEmpty) {
                  return Strings.errpleaseenterconfirmpassword;
                } else if (value.length < 6) {
                  return Strings.errconfirmpasswordlength;
                } else if (value != confirmPwd) {
                  return Strings.errpassworddonotmatch;
                } else
                  return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            space,
            TextFormField(
              controller: fnameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.account_circle_outlined),
                border: border,
                hintText: Strings.hintenteryourfirstname,
                labelText: Strings.firstname,
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return Strings.errenteryourfirstname;
                }
              },
            ),
            space,
            TextFormField(
              controller: mnameController,
              decoration: InputDecoration(
                  labelText: Strings.middlename,
                  hintText: Strings.hintenteryourmiddlename,
                  border: border,
                  prefixIcon: const Icon(Icons.account_circle_outlined)),
              validator: (value) {
                if (value!.isEmpty) return Strings.errenteryourmiddlename;
              },
            ),
            space,
            TextFormField(
              controller: lnameController,
              decoration: InputDecoration(
                  labelText: Strings.lastname,
                  hintText: Strings.hintenteryourlastname,
                  border: border,
                  prefixIcon: const Icon(Icons.account_circle_outlined)),
              validator: (value) {
                if (value!.isEmpty) return Strings.errenteryourlastname;
              },
            ),
            space,
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: MyTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  if (formKey.currentState!.validate()) {
                    showLoading();
                    signupWithEmail(
                      context: context,
                      email: emailController.text,
                      password: pass.text,
                      fullname:
                          "${fnameController.text} ${mnameController.text} ${lnameController.text}",
                      onSuccess: (value) {
                        dismissLoading();
                        hideLoading(true, Strings.successfullysignup);
                        Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                                child: const LoginScreen(),
                                type: PageTransitionType.rightToLeft),
                            (route) => false);
                      },
                      onError: (value) {
                        dismissLoading();
                        hideLoading(false, value.toString());
                        VxToast.show(context, msg: value.toString());
                      },
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: "Submit".text.bold.xl.make(),
                )).wh(MediaQuery.of(context).size.width, 50)
          ],
        ));
  }
}
