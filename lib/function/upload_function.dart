import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:voice_notepad/function/print_fun.dart';

import '../db/notes_database.dart';
import '../model/note.dart';
import '../service/database.dart';

class UploadNote with ChangeNotifier{
  final List<Note>? notes;
  final BuildContext? context;
  UploadNote( { this.notes, this.context});

  List<Note> listOfUpdatedNotes = [];
  List <Note> listOfLocalNotes = [];
  bool syncing = false;
  ///This is used to check if all the notes are updated
  ///and if the delete notes have been deleted from the database
  Future checkIfUploaded()async{


    try{
      if(notes!.isNotEmpty){
        ///This is to upload and update to firebase
        for(int i = 0; i<notes!.length ; i++){
          if(notes![i].uploaded == 'No'){
            Map<String,dynamic>userMap ={
              NoteFields.id:notes![i].id,
              NoteFields.docId:notes![i].docId,
              NoteFields.title:notes![i].title,
              NoteFields.isImportant: notes![i].isImportant,
              NoteFields.number:notes![i].number,
              NoteFields.description:notes![i].description,
              NoteFields.deleted:notes![i].deleted,
              NoteFields.time:notes![i].createdTime,
              NoteFields.uploaded:'Yes',
              NoteFields.updated:'Yes'
            };
            DatabaseMethods().uploadNotes(userMap).then((value) {
              final note= notes![i].copy(
                  uploaded: 'Yes',
                  updated: 'Yes'
              );
              NotesDatabase.instance.update(note);

            });
          }
          if(notes![i].updated == 'No'){
            Map<String,dynamic>userMap ={
              NoteFields.id:notes![i].id,
              NoteFields.title:notes![i].title,
              NoteFields.isImportant: notes![i].isImportant,
              NoteFields.number:notes![i].number,
              NoteFields.description:notes![i].description,
              NoteFields.time:notes![i].createdTime,
              NoteFields.deleted:notes![i].deleted,
              NoteFields.uploaded:'Yes',
              NoteFields.updated:'Yes',
              NoteFields.docId:notes![i].docId
            };
            DatabaseMethods().updateNotes(userMap).then((value) {
              final note= notes![i].copy(
                  uploaded: 'Yes',
                  updated: 'Yes'
              );
              NotesDatabase.instance.update(note);

            });
          }
          if(notes![i].deleted == 'Yes'){
            DatabaseMethods().deleteANote(notes![i].docId);
             NotesDatabase.instance.delete(notes![i].id!);
          }
        }
      }
      // if(notes.isEmpty){
      //   await DatabaseMethods().deleteANote(listOfUpdatedDocId[0].docId);
      //   listOfUpdatedDocId.remove(0);
      // }

    }on SocketException catch(e){
      printError(e);
    }
    catch(e){
      printError(e);
    }
  }

  ///This is used to check for network
  checkInternetConnection(bool test)async{
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        syncing = true;
        getListOfUploadedNotes().whenComplete(() {
          if(test){
            getNotes().whenComplete(() {
              checkIfUploaded().whenComplete(() {
                syncing= false;
              });
            });
          }else{
            checkIfUploaded().whenComplete(() {
              syncing= false;
            });
          }


        });
        printInfo('connected');
      }
    } on SocketException catch (_) {
      printError('not connected');
    }
  }

  ///This is used to get the list of updatedNotes
  Future getListOfUploadedNotes()async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user =  auth.currentUser;
    QuerySnapshot list;
    list = await FirebaseFirestore.instance.collection('users')
        .doc(user!.uid).collection('notes').get();

    List<DocumentSnapshot> documentSnapshot = list.docs.toList();
    for (var element in documentSnapshot) {
      listOfUpdatedNotes.add(Note.infoFrom(element));
    }

  }

  ///This is used to sort the list of local notes and updated notes
  sortList(){
    listOfLocalNotes.sort((a,b)=> a.docId.compareTo(b.docId));
    listOfUpdatedNotes.sort((a,b)=>a.docId.compareTo(b.docId));
  }

  ///This is used to check list if the first check failed
  checkList(String string)async{
    sortList();
    bool failed =false;
    int count  = 0;
    if(string == 'local'){
      for(int i = 0; i<listOfUpdatedNotes.length;i++){
        if(!(listOfUpdatedNotes[i].docId == listOfLocalNotes[i].docId)){
          await DatabaseMethods().deleteANote(listOfUpdatedNotes[i].docId);
          listOfUpdatedNotes.remove(i);
          sortList();
          i = i -1;
          count++;
          if(count > 5){
            sortList();
            failed = true;
            return null;
          }
        }
      }

    }
    if(string == 'firebase'){
      int counts = 0;
      for(int i = 0; i<listOfLocalNotes.length;i++){

        if(!(listOfLocalNotes[i].docId == listOfUpdatedNotes[i].docId)){
          await DatabaseMethods().uploadNotes(listOfLocalNotes[i].toJson());
          listOfUpdatedNotes.add(listOfLocalNotes[i]);
          sortList();
          i = i -1;
          counts++;
          if(counts > 5){
            sortList();
            failed = true;
            return null;
          }
        }
      }
    }
    if(failed){
      printError('second check have failed, Restarting');
      failed = false;
      if(string == 'local'){
        return checkList('local');
      }
      if(string == 'firebase'){
        return checkList('local');
      }
    }
  }

  ///This is used to retrieve notes while signing
  Future getNotes()async{
    List<Note>notes = [];
    List listOfDocId = [];
    notes =  await NotesDatabase.instance.readAllNotes();
    notes.sort((a,b)=> a.docId.compareTo(b.docId));
    getListOfUploadedNotes();
    sortList();
    if(notes.isEmpty){
      for (var element in listOfUpdatedNotes) {
        NotesDatabase.instance.create(element);
      }
      Navigator.pop(context!);
      Navigator.pushNamed(context!, 'home');
    }
    for (var element in notes) {
      listOfDocId.add(element.docId);
    }

    if(notes.isNotEmpty){
     for (var element in listOfUpdatedNotes) {
       if(listOfDocId.contains(element.docId)){
         notes.sort((a,b)=> a.docId.compareTo(b.docId));
         listOfUpdatedNotes.sort((a,b)=>a.docId.compareTo(b.docId));
       }else{
         Note note = Note(
             isImportant: element.isImportant,
             number: element.number,
             title: element.title,
             description: element.description,
             createdTime: element.createdTime,
             uploaded: element.uploaded,
             updated: 'No',
             docId: element.docId,
             deleted: 'No'
         );
         NotesDatabase.instance.create(note);
       }
     }
     Navigator.pop(context!);
     Navigator.pushNamed(context!, 'home');

    }
   //     for(int i = 0; i<listOfUpdatedNotes.length;i++){
   //
   //
   //     //  if(!(listOfDocId.contains(listOfUpdatedNotes[i].docId))){
   //     //    NotesDatabase.instance.create(listOfUpdatedNotes[i]);
   //     //  }
   //     //  else{
   //     //    notes.sort((a,b)=> a.docId.compareTo(b.docId));
   //     //    sortList();
   //     //  }
   //     // }
   //
   // }
  }
}