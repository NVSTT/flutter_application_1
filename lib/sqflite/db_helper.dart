import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'tasks.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE tasks(id TEXT PRIMARY KEY, title TEXT, dueDate TEXT, isCompleted INTEGER, imageUrl TEXT)',
      );
      db.execute(
        'CREATE TABLE users(username TEXT PRIMARY KEY, password TEXT, firstName TEXT, lastName TEXT, middleName TEXT, photo TEXT, rank TEXT)',
      );
      db.execute(
          'CREATE TABLE checklists(id TEXT PRIMARY KEY, title TEXT, isCompleted INTEGER, photo TEXT)', // новая таблица для чек-листов
        );
      db.execute(
          'CREATE TABLE checklist_items(itemNumber INTEGER PRIMARY KEY, description TEXT, isCompleted INTEGER, confirmationPhoto TEXT, checklistId TEXT)',
        );
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        db.execute(
          'ALTER TABLE users ADD COLUMN firstName TEXT',
        );
        db.execute(
          'ALTER TABLE users ADD COLUMN lastName TEXT',
        );
        db.execute(
          'ALTER TABLE users ADD COLUMN middleName TEXT',
        );
        db.execute(
          'ALTER TABLE users ADD COLUMN photo TEXT',
        );
        db.execute(
          'ALTER TABLE users ADD COLUMN rank TEXT',
        );
      }
    },
    version: 2,
  );
}


  static Future<void> addUser() async {
    await DBHelper.insert('users', {
    'username': 'test',
    'password': 'test',
    'firstName': 'Ярослав',
    'lastName': 'Моторный',
    'middleName': 'Евгеньевич',
    'photo': 'flutter_application_1/assets/user_photo.jpg',
    'rank': 'Бригадир',
  });
}

  static Future<Map<String, dynamic>?> getData(String table) async {
  final db = await DBHelper.database();
  final List<Map<String, dynamic>> result = await db.query(table);
  if (result.isNotEmpty) {
    return result.first;
  } else {
    return null; // или вернуть значение по умолчанию
  }
}

 static Future<void> addChecklist(Map<String, Object> data) async {
    await DBHelper.insert('checklists', data);
  }

  static Future<List<Map<String, dynamic>>> getChecklists() async {
    final db = await DBHelper.database();
    return db.query('checklists');
  }


  static Future<void> insert(String table, Map<String, Object> data) async {
      final db = await DBHelper.database();
      db.insert(
        table,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }


  static Future<List<Map<String, dynamic>>> getChecklistById(String id) async {
    final db = await DBHelper.database();
    return db.query(
      'checklists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateChecklist(String id, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.update(
      'checklists',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteChecklist(String id) async {
    final db = await DBHelper.database();
    db.delete(
      'checklists',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Добавление новой задачи в чек-лист
static Future<void> addChecklistItem(Map<String, Object> data) async {
  final db = await DBHelper.database();
  await db.insert('checklist_items', data);
}

// Получение всех задач конкретного чек-листа
static Future<List<Map<String, dynamic>>> getChecklistItems(String checklistId) async {
  final db = await DBHelper.database();
  return db.query(
    'checklist_items',
    where: 'checklistId = ?',
    whereArgs: [checklistId],
  );
}

// Обновление задачи в чек-листе
static Future<void> updateChecklistItem(int itemNumber, Map<String, Object> data) async {
  final db = await DBHelper.database();
  await db.update(
    'checklist_items',
    data,
    where: 'itemNumber = ?',
    whereArgs: [itemNumber],
  );
}

// Удаление задачи из чек-листа
static Future<void> deleteChecklistItem(int itemNumber) async {
  final db = await DBHelper.database();
  await db.delete(
    'checklist_items',
    where: 'itemNumber = ?',
    whereArgs: [itemNumber],
  );
}

static Future<List<Map<String, dynamic>>> getChecklistItemsByChecklistId(String checklistId) async {
  final db = await DBHelper.database();
  final List<Map<String, dynamic>> result = await db.query(
    'checklist_items',
    where: 'checklistId = ?',
    whereArgs: [checklistId],
  );
  return result;
}

}
