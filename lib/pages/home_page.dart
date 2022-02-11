import 'package:flutter/material.dart';
import 'package:note_hive/models/note_model.dart';
import 'package:note_hive/pages/detail_page.dart';
import 'package:note_hive/services/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "/home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Note> listNote;

  @override
  void initState() {
    super.initState();
    loadNoteList();
  }

  void loadNoteList() {
    setState(() {
      listNote = DBService.loadNotes();
    });
  }

  void _openDetailPage() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  void _openDetailForEdit(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Note"),
        actions: [
          IconButton(
            onPressed: () {
              DBService.storeMode(!DBService.loadMode());
              setState(() {});
            },
            icon: Icon(DBService.loadMode() ? Icons.dark_mode : Icons.light_mode),
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: listNote.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _openDetailForEdit(listNote[index]);
            },
            child: Card(
              elevation: 40,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(listNote[index].title),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(listNote[index].content),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(listNote[index].createTime.toString()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _openDetailPage,
      ),
    );
  }
}
