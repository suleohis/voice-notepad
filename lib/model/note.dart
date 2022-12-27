import 'package:cloud_firestore/cloud_firestore.dart';

const String tableNotes = 'notes';

class NoteFields{
  static final List<String> value = [
    id,isImportant,number,title,description,time,uploaded,updated,docId,deleted
  ];

  static const String id = '_id';
  static const String isImportant =  'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String time = 'time';
  static const String uploaded = 'uploaded';
  static const String updated = 'updated';
  static const String deleted = 'deleted';
  static const String docId = 'docId';
}


class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;
  final String uploaded;
  final String updated;
  final String docId;
  final String deleted;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.uploaded,
    required this.updated,
    required this.docId,
    required this.deleted
  });

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
    String? uploaded,
    String? updated,
    String? docId,
    String? deleted
  })=>
      Note(
          id:id??this.id,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime?? this.createdTime,
          uploaded: uploaded ?? this.uploaded,
          updated: updated ?? this.updated,
          docId: docId ?? this.docId,
          deleted: deleted ?? this.deleted
      );

  static Note fromJson(Map<String,Object?> json) =>Note(
      id: json[NoteFields.id] as int,
      isImportant: json[NoteFields.isImportant] == 1,
      number: json[NoteFields.number] as int,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.time] as String),
      uploaded: json[NoteFields.uploaded] as String,
      updated: json[NoteFields.updated] as String,
      docId: json[NoteFields.docId] as String,
      deleted: json[NoteFields.deleted] as String
  );
  static Note infoFrom(DocumentSnapshot doc) =>Note(
      id: doc[NoteFields.id] as int,
      isImportant: doc[NoteFields.isImportant] == 1,
      number: doc[NoteFields.number] as int,
      title: doc[NoteFields.title] as String,
      description: doc[NoteFields.description] as String,
      createdTime: DateTime.parse(doc[NoteFields.time].toDate().toString()) ,
      uploaded: doc[NoteFields.uploaded] as String,
      updated: doc[NoteFields.updated] as String,
      docId: doc[NoteFields.docId] as String,
    deleted: doc[NoteFields.deleted] as String
  );

  Map<String, Object?> toJson() =>{
    NoteFields.id:id,
    NoteFields.title:title,
    NoteFields.isImportant: isImportant ? 1: 0,
    NoteFields.number:number,
    NoteFields.description:description,
    NoteFields.time:createdTime.toIso8601String(),
    NoteFields.uploaded:uploaded,
    NoteFields.updated:updated,
    NoteFields.docId:docId,
    NoteFields.deleted:deleted
  };
}