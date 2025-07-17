import 'package:flutter/material.dart';
import 'package:notes_app/db/database_helper.dart';
import 'package:notes_app/model/note_model.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  // Controllers
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  // Add note function
  void saveNote() async {
    final String title = titleController.text.trim();
    final String body = bodyController.text.trim();
    final DateTime date = DateTime.now();

    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and body cannot be empty')),
      );
      return;
    }

    NoteModel newNote = NoteModel(
      title: title,
      body: body,
      creation_date: date,
    );

    await DatabaseHelper.db.addNewNote(newNote);
    print('Note added successfully');

    Navigator.pop(context); // Go back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Note')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Your Note",
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveNote,
        label: const Text('Save Note'),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }
}
