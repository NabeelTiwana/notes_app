import '../model/note_model.dart';

class NoteSelectionManager {
  final List<NoteModel> _selectedNotes = [];

  List<NoteModel> get selectedNotes => _selectedNotes;

  bool isSelected(NoteModel note) => _selectedNotes.any((n) => n.id == note.id);

  void toggleSelection(NoteModel note) {
    final index = _selectedNotes.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      _selectedNotes.removeAt(index);
    } else {
      _selectedNotes.add(note);
    }
  }

  void clearSelection() {
    _selectedNotes.clear();
  }

  bool get isSelectionMode => _selectedNotes.isNotEmpty;
}
