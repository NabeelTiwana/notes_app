import 'package:flutter/material.dart';
import 'db/database_helper.dart';
import 'model/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<NoteModel>> getNotes() async {
    return await DatabaseHelper.db.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Notes'),backgroundColor: Colors.redAccent,),
      body: FutureBuilder<List<NoteModel>>(
        future: getNotes(),
        builder: (context, noteData) {
          switch (noteData.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (!noteData.hasData || noteData.data!.isEmpty) {
                return const Center(
                  child: Text('You don\'t have any notes yet, create one'),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: noteData.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final note = noteData.data![index];
                      return Card(
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.body),
                          trailing: Text(
                            note.creation_date.toString().split(" ").first,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            default:
              return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/AddNote");
          setState(() {});
        },
        child: Icon(Icons.note_add),
      ),

    );
  }
}
