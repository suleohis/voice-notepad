import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///This is used to upload user data
  uploadUserInfo(userMap,context)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).set(userMap).then((value) {
          print('done');
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pushNamed(context, 'homes');
    });
  }

  ///This is used to upload user data
  updateUserInfo(userMap,context)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).update(userMap).then((value) {
      print('done');
      auth.signOut();

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, 'home');
    });
  }

  ///This is used to upload notes to firebase
   Future uploadNotes(Map<String, dynamic> userMap)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('notes').doc(userMap['docId']).set(userMap);
  }

  ///This is used to update notes in firebase
  Future updateNotes(Map<String, dynamic> userMap)async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('notes').doc(userMap['docId']).update(userMap);
  }

  ///This is used to retrieve notes
   retrieveNotes()async{
    final User? user =  auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('notes').get();
  }

  ///This is used to delete note
  Future deleteANote(String docId)async{
    final User? user = auth.currentUser;
    await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('notes').doc(docId).delete();
  }
}
