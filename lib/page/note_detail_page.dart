import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_notepad/db/notes_database.dart';
import 'package:voice_notepad/model/note.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  ///This is used to get the note that have been click
  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushNamed(context, 'home');
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          actions: [saveButton(), shareButton(), editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMMMd().format(note.createdTime),
                      style: const TextStyle(color: Colors.white38),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      note.description,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 18),
                    )
                  ],
                ),
              ),
      );

  ///This is used to go the 'AddEditNotePage' to edit the note
  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        refreshNote();
      });

  ///This is used to delete a note
  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          ask();
        },
      );
  ifLogin() {
    final auth = FirebaseAuth.instance.currentUser;
    if (auth == null) {
      return true;
    } else {
      return false;
    }
  }

  ask() => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are You Sure?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey.shade800),
                    child: const Text('No')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey.shade800),
                    onPressed: () async {
                      bool check = ifLogin();
                      if (check) {
                        NotesDatabase.instance.delete(note.id!);
                      } else {
                        Note notes = note.copy(deleted: 'Yes');
                        await NotesDatabase.instance.update(notes);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, 'home');
                    },
                    child: const Text('Yes')),
              ],
            )
          ],
        );
      });

  ///This is used to save a note
  Widget saveButton() => IconButton(
        icon: const Icon(Icons.save),
        color: Colors.white,
        onPressed: () {
          save('.txt');
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Save Successfully')));
        },
      );

  ///This is used to share a note
  Widget shareButton() => PopupMenuButton(
        icon: const Icon(Icons.share),
        color: Colors.transparent,
        itemBuilder: (context) {
          return [
            const PopupMenuItem<int>(
              value: 0,
              child: Text(
                'Text',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Text('txt.file', style: TextStyle(color: Colors.white)),
            )
          ];
        },
        onSelected: (item) {
          if (item == 0) {
            Share.share(note.title + '\n\n' + note.description);
          }
          if (item == 1) {
            _write();
          }
        },
      );
  // IconButton(
  // icon: Icon(Icons.share),
  // onPressed:_write,
  // );

  File? file;

  ///This is used to create a txt file
  saveWord() async {
    await checkPermission();
    final f = File("assets/template.docx");
    final docx = await DocxTemplate.fromBytes(await f.readAsBytes());
    Content c = Content();
    c
      ..add(TextContent('bold', note.title))
      ..add(TextContent('normal', note.description));
    final d = await docx.generate(c);
    final of = File('generated.docx');
    if (d != null) await of.writeAsBytes(d);

    Directory directory = Directory('/storage/emulated/0/Documents');
    file = await File('${directory.path}/${note.title}.docx').copy(of.path);
    print(file!.path);
  }

  save(String extension) async {
    await checkPermission();
    Directory directory = Directory('/storage/emulated/0/Documents');
    file = File('${directory.path}/${note.title}$extension');
    await file!.writeAsString('${note.title}\n\n${note.description}');
    print(file!.path);
  }

  ///This is used to create a txt file
  _write() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    file = File('${directory.path}/${note.title}.txt');
    await file!.writeAsString('${note.title}\n\n${note.description}');
    await Share.shareFiles(
      [file!.path],
      text: note.title,
    );
  }

  checkPermission() async {
    if (await Permission.storage.isGranted) {
    } else {
      Permission.storage.request();
    }
  }
}
