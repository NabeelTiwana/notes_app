import 'package:notes_app/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper db = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), "note_app.db"),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            creation_date TEXT
          )
        ''');
      },
    );
  }

  // ✅ Add new note
  Future<void> addNewNote(NoteModel note) async {
    final db = await database;
    await db.insert(
      'notes',
      note.toMap(),   
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ Get all notes
  Future<List<NoteModel>> getNotes() async {
    final db = await database;
    final res = await db.query('notes');

    if (res.isEmpty) return [];
    return res.map((map) => NoteModel.fromMap(map)).toList();
  }

  // ✅ Update note
  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // ✅ Delete note
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
