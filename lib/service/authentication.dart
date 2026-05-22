import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_notepad/function/print_fun.dart';

import '../db/sharedpref.dart';
import 'database.dart';

class Authentication{
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';
  static String sharedPreferenceMaxWaitTime = 'MAXWAITTIME';
  static String sharedPreferenceMaxTime = 'MAXTIME';
  static String sharedPreferenceListType = 'ListType';
  static String sharedPreferenceLang = 'Language';
  static Future<FirebaseApp> initializeFirebase()async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  static Future<void> signWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn.instance;

    try {
      await googleSignIn.initialize(
        serverClientId: "743406536407-k69acd79fk9ec6mr9p3uegiasoftldce.apps.googleusercontent.com",
      );

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.authenticate();

      if (googleSignInAccount == null) return;

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user == null) return;

      final Map<String, dynamic> userMap = {
        'name': user.displayName,
        'email': user.email,
        'Log check': 'Sign In',
        'LogOut time': DateTime.parse(DateTime.now().toIso8601String()),
      };

      await HelperFunction.saveUserLoggedInSharedPreference(true);
      await HelperFunction.saveUserNameSharedPreference(user.displayName);
      await HelperFunction.saveUserEmailSharedPreference(user.email);
      DatabaseMethods().uploadUserInfo(userMap, context);

    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return;
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Google Sign In failed. Try again.',
        ),
      );
    } on FirebaseAuthException catch (e) {
      final String message = switch (e.code) {
        'account-exists-with-different-credential' =>
        'The account already exists with a different credential.',
        'invalid-credential' =>
        'Error occurred while accessing credentials. Try again.',
        _ => 'Firebase error: ${e.message}',
      };
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(content: message),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Google Sign In. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}){
    return SnackBar(
      backgroundColor: Colors.black,
        content: Text(
            content,
          style: const TextStyle(color: Colors.redAccent,letterSpacing: 0.5),
        )
    );
  }

  static Future<void> signOUt({required BuildContext context})async{
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      String? email = await HelperFunction.getUserEmailSharedPreference();
      String? name = await HelperFunction.getUserNameSharedPreference();
      // if(!KIsWeb){
      //   await googleSignIn.signOut();
      // }
      // await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();

      Map<String, dynamic> userMap ={
        'name':name,
        'email':email,
        'Log check': 'Sign Out',
        'LogOut time':  DateTime.parse(DateTime.now().toIso8601String())
      };
      DatabaseMethods().updateUserInfo(userMap,context);
      pref.remove(sharedPreferenceUserNameKey);
      pref.remove(sharedPreferenceUserEmailKey);
      ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
              content: 'Done Thanks.'
          )
      );
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
            content: 'Error signing out. Try again.'
        )
      );
    }
  }
}