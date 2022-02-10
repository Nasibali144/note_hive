import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_hive/services/db_service.dart';

import '../models/note_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  static const String id = "/detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _storeNote() async {
    String title = titleController.text.trim().toString();
    String content = contentController.text.trim().toString();
    if (content.isNotEmpty) {
      Note note = Note(
          id: title.hashCode,
          title: title,
          content: content,
          createTime: DateTime.now());
      List<Note> noteList = DBService.loadNotes();
      noteList.add(note);
      await DBService.storeNotes(noteList);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _storeNote();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: _storeNote,
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // #title
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: TextField(
                controller: titleController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                cursorColor: Colors.orange,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),

            // #content
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: TextField(
                controller: contentController,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  isCollapsed: true,
                  border: InputBorder.none,
                ),
                cursorColor: Colors.orange,
                showCursor: true,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
