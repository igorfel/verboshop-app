import 'dart:async';
import 'blocProvider.dart';
import '../models/signInInfo.dart';
import '../models/signUpInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authbloc extends BlocBase {
  static const String USER_DB = "users";
  Firestore database;
  FirebaseAuth auth;
  FirebaseUser user;

  Authbloc() {
    database = Firestore.instance;
    auth = FirebaseAuth.instance;
  }

  Future signIn(SignInInfo loginInfo) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Retrieve user info from the database
    DocumentSnapshot dbUserInfo =
        await database.collection(USER_DB).document(loginInfo.user).get();

    if (dbUserInfo.exists) {
      // Login user with email and password
      this.user = await auth.signInWithEmailAndPassword(
          email: dbUserInfo['email'], password: loginInfo.pass);
    }
  }

  Future signUp(SignUpInfo signUpInfo) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Try to create a new user
    FirebaseUser newUser = await auth.createUserWithEmailAndPassword(
        email: signUpInfo.email, password: signUpInfo.password);

    // after registering the new user add his info to the database
    database.collection(USER_DB).document(signUpInfo.user).setData({
      'uid': newUser.uid,
      'user': signUpInfo.user,
      'email': newUser.email,
      'isPremium': false,
      'created_at': FieldValue.serverTimestamp()
    });

    // TODO: trigger new user success event
  }

  //To sign out the current User
  Future signOut() async {
    await auth.signOut();

    // TODO: trigger sign out event
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
