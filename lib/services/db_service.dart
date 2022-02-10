import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../models/note_model.dart';

class DBService {
  static const String dbName = "db_notes";
  static Box box = Hive.box(dbName);

  static Future<void> storeNotes(List<Note> noteList) async {
    // object => map => String
    List<String> stringList = noteList.map((note) => jsonEncode(note.toJson())).toList();
    await box.put("notes", stringList);
  }

  static List<Note> loadNotes() {
    // String =>  Map => Object
    List<String> stringList = box.get("notes") ?? <String>[];
    List<Note> noteList = stringList.map((string) => Note.fromJson(jsonDecode(string))).toList();
    return noteList;
  }

  static Future<void> removeNotes() async {
    await box.delete("notes");
  }
}