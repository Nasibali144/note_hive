import 'package:flutter/material.dart';
import 'package:note_hive/services/db_service.dart';

import '../models/note_model.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";

  // for edit
  final Note? note;
  const DetailPage({Key? key, this.note}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  Future<void> _storeNote() async {
    if(widget.note == null) {
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
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      List<Note> noteList = DBService.loadNotes();
      Note note = Note(
          id: widget.note!.id,
          title: title,
          content: content,
          createTime: widget.note!.createTime,
          editTime: DateTime.now(),
      );
      noteList.removeWhere((element) => element.id == note.id);
      if(content.isNotEmpty || title.isNotEmpty) {
        noteList.add(note);
        await DBService.storeNotes(noteList);
      }
    }
    Navigator.pop(context, true);
  }

  void loadNote(Note? note) {
    if(note != null) {
      setState(() {
        titleController.text = note.title;
        contentController.text = note.content;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadNote(widget.note);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _storeNote();
        print("On Will POP");
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
