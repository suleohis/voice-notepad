
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:voice_notepad/page/profilePage.dart';

import '../db/notes_database.dart';
import '../db/sharedpref.dart';
import '../function/uploadFuntion.dart';
import '../model/note.dart';
import '../widget/note_card_widget.dart';
import 'edit_note_page.dart';
import 'note_detail_page.dart';

class NotesPage extends StatefulWidget{
 final bool getNote ;
  const NotesPage(this.getNote, {Key? key}): super(key: key);
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>{
  List<Note> notes = [];
  bool isLoading = false;
  late bool test;
  bool listType = false;
  bool searchTextFieldAppear = false;
  TextEditingController searchTextController = TextEditingController();
  final auth = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    checkPermission();
    er();
    checkFirstTime();
    super.initState();
    refreshNotes();

  }
  checkPermission() async{
    if (await Permission.storage.isGranted) {

    } else {
      Permission.storage.request();
    }
  }
  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  ///This is used to got the notes from the database
  ///And from firebase if just logging in
  Future refreshNotes()async{

    if(false){
      setState(() =>isLoading=true);
        setState(() {});
        if(test){
          UploadNote(notes: notes,context: context).getNotes();
        }
      setState(() => isLoading =false);
    }else{
      setState(() => isLoading =true);
      this.notes =  await NotesDatabase.instance.readAllNotes().then((value){
        setState(() {});
        if(test){
          UploadNote(notes: value,context: context).checkInternetConnection
            (widget.getNote);
        }


        return value;
      });
      notes = notes.reversed.toList();
      listType = (await HelperFunction.getListTypeSharedPreference())!;
      setState(() => isLoading =false);
      getSearchAlgorithm();
    }
  }

  ///This is used to check if you sign in
  er()async{
    bool? test = await HelperFunction.getUserLoggedInSharedPreference();
    if(test == null){
      print('true');
    }else{
      print('false');
    }
  }
  List<Map<String,dynamic>> listOfSearchAlgorithm =[];
  ///This is used to check if this is the First time opening the app
  checkFirstTime()async{
    if(await HelperFunction.getUserLoggedInSharedPreference() == null){
      print(await HelperFunction.getUserLoggedInSharedPreference());
      HelperFunction.saveUserLoggedInSharedPreference(false);
      test = (await HelperFunction.getUserLoggedInSharedPreference())!;
    }else{
      test = (await HelperFunction.getUserLoggedInSharedPreference())!;
    }
    if(await HelperFunction.getMaxWaitTimeSharedPreference() == null){
      HelperFunction.saveMaxWaitTimeSharedPreference(5);
    }
    if(await HelperFunction.getListTypeSharedPreference() == null){
      HelperFunction.saveListTypeSharedPreference(true);
    }
    if(await HelperFunction.getMaxTimeSharedPreference() ==null){
      print(await HelperFunction.getMaxTimeSharedPreference());
      HelperFunction.saveMaxTimeSharedPreference(1);
    }
    if(await HelperFunction.getUserLangSharedPreference() ==null){
      final String defaultLocale = Platform.localeName;
      HelperFunction.saveUserLangSharedPreference(defaultLocale);
    }
    if(await HelperFunction.getUserTransLangSharedPreference() ==null){
      HelperFunction.saveUserTransLangSharedPreference('en');
    }
  }
  getSearchAlgorithm (){
    for (var element in notes) {
      List<String> listOfTemp = [];
      String temp = '';
      for(int i  = 0; i < element.title.length; ++i){
        temp = temp + element.title[i].trim().toLowerCase();
        listOfTemp.add(temp);
      }
      listOfSearchAlgorithm.add({
        'id':element.id,
        'listOfTemp':listOfTemp
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar:  AppBar(
      automaticallyImplyLeading: false,
      title: searchTextFieldAppear?
      Container(
        color: Colors.blueGrey,
        padding: const EdgeInsets.only(left: 10),
        child: TextField(
          controller: searchTextController,
          onChanged: (String value){
            setState(() {});
          },
          decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(fontSize: 16,color: Colors.grey),
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        ),
      )
          : const Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),
      actions: [
        GestureDetector(
          onTap: ()async{
            setState(() {
              listType = !listType;
            });
            await HelperFunction.saveListTypeSharedPreference(listType);
          },
          child: listType ?
          const Icon(Icons.list):
          const Icon(Icons.grid_view),
        ),
        const SizedBox(
          width: 15,
        ),
        GestureDetector(
          onTap: (){
            searchTextFieldAppear = !searchTextFieldAppear;
            searchTextController.text = '';
            setState(() {});
          },
            child:
            const Icon(Icons.search)), const SizedBox(width: 12),
    const SizedBox(width: 15,),
        GestureDetector(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage(test))),
          child: ClipRRect(

            child: Container(
              height: 30,width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
              ),

                child: const Icon(Icons.person)),
          ),
        ),
        const SizedBox(width: 15,),
      ]
    ),
    body: Center(
      child: Stack(
        children: [
          isLoading ?
          const CircularProgressIndicator(): notes.isEmpty?
          const Text('No Notes', style:
          TextStyle(color: Colors.white, fontSize: 24),):buildNote(),
  Provider.of<UploadNote>(context, listen: true).syncing ?
          Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
              children: const [
                SizedBox(
                    height:20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 2,)),
                SizedBox(width: 10,),
                Text('Syncing ',style: TextStyle(color: Colors.white),),
              ],
            ),
          ) :const SizedBox(),
          // if(searchTextFieldAppear)
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: listOfSearchAlgorithm.length,
          //   itemBuilder: (context,index){
          //    if(searchTextController.text == listOfSearchAlgorithm[index]){
          //      return Padding(
          //        padding: EdgeInsets.symmetric(horizontal: 20,),
          //        child: Container(
          //          decoration: BoxDecoration(
          //            color: Colors.white,
          //            // borderRadius: BorderRadius.circular(6),
          //            border: Border(
          //              bottom: BorderSide(
          //                width: 1,color: Colors.grey
          //              )
          //            )
          //          ),
          //
          //          child: ListTile(
          //            title: Text(listOfSearchAlgorithm[index]),
          //          ),
          //        ),
          //      );
          //    }else{
          //     return Container();
          //    }
          //   },
          // )
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: const Icon(Icons.add),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddEditNotePage()),
        );

        refreshNotes();
      },
    ),
  );

  ///This is used to arrange the notes
  Widget buildNote(){
   return listType ? ListView.builder(
     padding: const EdgeInsets.all(8),
     itemCount: notes.length,
     itemBuilder: (context, index) {
       final note = notes[index];
       if(searchTextFieldAppear){
         List<String> listOfTemp = listOfSearchAlgorithm[index]['listOfTemp'];
         if(listOfTemp.contains(searchTextController.text) ){
           if(notes[index].deleted == 'No' ){
             return GestureDetector(
               onTap: () async {
                 await Navigator.of(context).push(MaterialPageRoute(
                   builder: (context) => NoteDetailPage(noteId: note.id!),
                 ));
                 refreshNotes();
               },
               child: NoteCardListWidget(note: note, index: index),
             );
           }
         }
         if(searchTextController.text.isEmpty){
           if(notes[index].deleted == 'No' ){
             return GestureDetector(
               onTap: () async {
                 await Navigator.of(context).push(MaterialPageRoute(
                   builder: (context) => NoteDetailPage(noteId: note.id!),
                 ));
                 refreshNotes();
               },
               child: NoteCardListWidget(note: note, index: index),
             );
           }
         }
       }else{
         if(notes[index].isImportant){
           if(notes[index].deleted == 'No' ){
             return GestureDetector(
               onTap: () async {
                 await Navigator.of(context).push(MaterialPageRoute(
                   builder: (context) => NoteDetailPage(noteId: note.id!),
                 ));
                 refreshNotes();
               },
               child: NoteCardListWidget(note: note, index: index),
             );
           }
         }
         if(notes[index].deleted == 'No' ){
           return GestureDetector(
             onTap: () async {
               await Navigator.of(context).push(MaterialPageRoute(
                 builder: (context) => NoteDetailPage(noteId: note.id!),
               ));

               refreshNotes();
             },
             child: NoteCardListWidget(note: note, index: index),
           );
         }
       }
       return Container();

     },
   )
   : StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8),
      itemCount: notes.length,
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];
        if(searchTextFieldAppear){
          List<String> listOfTemp = listOfSearchAlgorithm[index]['listOfTemp'];
          if(listOfTemp.contains(searchTextController.text) ){
            if(notes[index].deleted == 'No' ){
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));
                  refreshNotes();
                },
                child: NoteCardWidget(note: note, index: index),
              );
            }
          }
          if(searchTextController.text.isEmpty){
            if(notes[index].deleted == 'No' ){
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));
                  refreshNotes();
                },
                child: NoteCardWidget(note: note, index: index),
              );
            }
          }
        }else{
          if(notes[index].isImportant){
            if(notes[index].deleted == 'No' ){
              return GestureDetector(
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(noteId: note.id!),
                  ));
                  refreshNotes();
                },
                child: NoteCardWidget(note: note, index: index),
              );
            }
          }
          if(notes[index].deleted == 'No' ){
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));

                refreshNotes();
              },
              child: NoteCardWidget(note: note, index: index),
            );
          }
        }
        return Container();

      },
    );
  }

}