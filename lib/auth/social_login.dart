import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/database/data_store.dart';
import 'package:todo_app/common/constant.dart';
import 'package:todo_app/core/task_notifier.dart';
import 'package:todo_app/pref/shared_pref.dart';

class SocialLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  static String fbAppID = "610038953703199";

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    await FacebookAuth.instance.logOut();
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

//SIGN UP METHOD
  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHODJ
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //SIGN OUT METHOD
  Future<void> signOut(BuildContext context) async {
    String? loginType = await getPrefStirngData(Constant.loginType);
    if (loginType == "email") {
      await FirebaseAuth.instance.signOut();
    }
    if (loginType == "google") {
      GoogleSignIn googleSignIn = GoogleSignIn();
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
    }
    if (loginType == "facebook") {
      await FacebookAuth.i.logOut();
      await FirebaseAuth.instance.signOut();
    }
  }
}

signupWithEmail(
    {required BuildContext context,
    required String email,
    required String password,
    required String fullname,
    required Function(String value) onSuccess,
    required Function(String value) onError}) {
  DatabaseStore databaseStore = DatabaseStore();
  databaseStore.firebaseInit();

  SocialLogin()
      .signUp(email: email, password: password)
      .then((value) {
        // get result from facebook login
        if (value == null) {
          String facebookId = "";
          String profilePic = "";
          String loginType = "";

          loginType = "email";

          Provider.of<TaskNotifier>(context, listen: false).addUserToFireStore(
              fullname, email, loginType, facebookId, profilePic);

          Provider.of<TaskNotifier>(context, listen: false).getCurrentDate();

          onSuccess.call("");
        } else {
          onError.call(value.toString());
        }
      })
      .onError((error, stackTrace) {
        onError.call(error.toString());
      })
      .whenComplete(() => {})
      .catchError((error) {
        onError.call(error.toString());
      });
}

loginWithEmail(
    {required BuildContext context,
    required String email,
    required String password,
    required Function(String value) onSuccess,
    required Function(String value) onError}) {
  DatabaseStore databaseStore = DatabaseStore();
  databaseStore.firebaseInit();

  SocialLogin()
      .signIn(email: email, password: password)
      .then((value) {
        // get result from facebook login
        if (value == null) {
          onSuccess.call("");
        } else {
          onError.call(value.toString());
        }
      })
      .onError((error, stackTrace) {
        onError.call(error.toString());
      })
      .whenComplete(() => {})
      .catchError((error) {
        onError.call(error.toString());
      });
}

loginwithFacebook(
    {required BuildContext context,
    required Function(UserCredential value) onSuccess,
    required Function(String value) onError}) {
  DatabaseStore databaseStore = DatabaseStore();
  databaseStore.firebaseInit();

  SocialLogin()
      .signInWithFacebook()
      .then((value) {
        // get result from facebook login
        if (value != null) {
          String name = "";
          String email = "";
          String facebookId = "";
          String profilePic = "";
          String loginType = "";
          final Map<String, dynamic>? profile =
              value.additionalUserInfo!.profile;
          profile!.entries.forEach((element) {
            String key = element.key.toString();
            String value = element.value.toString();
// store picture url into local pref.
            if (key == "picture") {
              Map map = element.value;
              profilePic = map["data"]["url"];
            }
            // store name url into local pref.
            if (key == "name") {
              name = value;
            }
            if (key == "id") {
              facebookId = value;
            }
          });
          loginType = "facebook";

          saveUserData(
              name: name,
              email: email,
              profileurl: profilePic,
              facebookid: facebookId,
              isuserlogged: true,
              logintype: loginType);

          Provider.of<TaskNotifier>(context, listen: false)
              .addUserToFireStore(name, "", loginType, facebookId, profilePic);

          Provider.of<TaskNotifier>(context, listen: false).getCurrentDate();
          Constant.initUserData();

          onSuccess.call(value);
        } else {
          onError.call(value.toString());
        }
      })
      .onError((error, stackTrace) {
        onError.call(error.toString());
      })
      .whenComplete(() => {})
      .catchError((error) {
        onError.call(error.toString());
      });
}

loginWithGoogle(
    {required BuildContext context,
    required Function(UserCredential value) onSuccess,
    required Function(String value) onError}) {
  try {
    SocialLogin()
        .signInWithGoogle()
        .then((value) {
          if (value != null) {
            String name = "";
            String email = "";
            String facebookId = "";
            String profilePic = "";
            String loginType = "google";
            final Map<String, dynamic>? profile =
                value.additionalUserInfo!.profile;
            if (profile != null) {
              EasyLoading.dismiss();
              profile.entries.forEach((element) async {
                String paramkey = element.key.toString();
                String paramvalue = element.value.toString();

                if (paramkey == "picture") {
                  profilePic = paramvalue;
                }
                if (paramkey == "email") {
                  email = paramvalue;
                }
                if (element.key.toString() == "name") {
                  name = paramvalue;
                }
                loginType = "google";
                saveUserData(
                    name: name,
                    email: email,
                    profileurl: profilePic,
                    facebookid: facebookId,
                    isuserlogged: true,
                    logintype: loginType);

                Provider.of<TaskNotifier>(context, listen: false)
                    .addUserToFireStore(
                        name, email, loginType, facebookId, profilePic);
                Provider.of<TaskNotifier>(context, listen: false)
                    .getCurrentDate();
                Constant.initUserData();
                onSuccess.call(value);
              });
            }
          } else {
            onError.call(value.toString());
          }
        })
        .onError((error, stackTrace) {
          onError.call(error.toString());
        })
        .whenComplete(() => {})
        .catchError((error) {
          onError.call(error.toString());
        });
  } on Exception catch (e) {}
}
