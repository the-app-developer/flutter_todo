import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/common/constant.dart';

class DatabaseStore {
  Future<void> firebaseInit() async {
    await Firebase.initializeApp();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? currentUser;

  Future<void> addUserToFireStore(String name, String email, String logintype,
      String fbId, String pictureProfile) async {
    firebaseInit();

    Map<String, dynamic> map = HashMap();
    map.addAll(<String, dynamic>{
      'name': name,
      'email': email,
      "login_type": logintype,
      "fb_id": fbId,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'profile_url': pictureProfile,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
    });

    currentUser = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection(Constant.tbluser)
        .doc(currentUser!.uid)
        .set(map);
  }
}
