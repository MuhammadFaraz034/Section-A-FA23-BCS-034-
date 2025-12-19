
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertNote(String title, String desc) async {
    final db = await database();
    await db.insert('notes', {'title': title, 'description': desc});
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database();
    return db.query('notes');
  }

  static Future<void> deleteNote(int id) async {
    final db = await database();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
