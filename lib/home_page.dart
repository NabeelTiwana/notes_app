import 'package:flutter/material.dart';
import 'package:notes_app/screens/display_note.dart';
import 'package:notes_app/screens/note_select.dart';
import 'constant/color.dart';
import 'db/database_helper.dart';
import 'model/note_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NoteSelectionManager selectionManager = NoteSelectionManager();

  Future<List<NoteModel>> getNotes() async {
    return await DatabaseHelper.db.getNotes();
  }

  void _deleteSelectedNotes() async {
    for (var note in selectionManager.selectedNotes) {
      await DatabaseHelper.db.deleteNote(note.id!);
    }
    selectionManager.clearSelection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectionManager.isSelectionMode
              ? '${selectionManager.selectedNotes.length} selected'
              : 'Your Notes',
        ),
        backgroundColor: Colors.redAccent,
        actions: [
          if (selectionManager.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: _deleteSelectedNotes,
            ),
        ],
      ),
      body: FutureBuilder<List<NoteModel>>(
        future: getNotes(),
        builder: (context, noteData) {
          if (noteData.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!noteData.hasData || noteData.data!.isEmpty) {
            return const Center(
              child: Text('You don\'t have any notes yet, create one'),
            );
          } else {
            final notes = noteData.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(notes.length, (index) {
                  final note = notes[index];
                  final color = NoteCardColors.cardColors[index % NoteCardColors.cardColors.length];
                  final isSelected = selectionManager.isSelected(note);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        selectionManager.toggleSelection(note);
                      });
                    },
                    onTap: () {
                      if (selectionManager.isSelectionMode) {
                        setState(() {
                          selectionManager.toggleSelection(note);
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DisplayNote(note: note),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        NoteTile(note: note, color: color),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(Icons.check_circle, color: Colors.white, size: 24),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/AddNote").then((_) => setState(() {}));
        },
        child: const Icon(Icons.note_add),
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  final NoteModel note;
  final Color color;

  const NoteTile({super.key, required this.note, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              note.body,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              note.creation_date.toString().split(" ").first,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
