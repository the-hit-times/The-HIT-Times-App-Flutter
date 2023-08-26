import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:the_hit_times_app/models/notification.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();

  static Database? _database;

  NotificationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notification.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotifications ( 
  ${NotificationFields.id} $idType, 
  ${NotificationFields.imageUrl} $textType,
  ${NotificationFields.title} $textType,
  ${NotificationFields.description} $textType,
  ${NotificationFields.body} $textType,
  ${NotificationFields.htmlBody} $textType,
  ${NotificationFields.category} $integerType,
  ${NotificationFields.time} $textType
  )
''');
  }

  Future<Notification> create(Notification notifications) async {
    final db = await instance.database;

    final id = await db.insert(tableNotifications, notifications.toJson());
    return notifications.copy(id: id);
  }

  Future<Notification> readNotification(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotifications,
      columns: NotificationFields.values,
      where: '${NotificationFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Notification.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Notification>> readAllNotifications() async {
    final db = await instance.database;

    final orderBy = '${NotificationFields.time} ASC';

    final result = await db.query(tableNotifications, orderBy: orderBy);

    return result.map((json) => Notification.fromJson(json)).toList();
  }

  Future<int> update(Notification notification) async {
    final db = await instance.database;

    return db.update(
      tableNotifications,
      notification.toJson(),
      where: '${NotificationFields.id} = ?',
      whereArgs: [notification.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotifications,
      where: '${NotificationFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllNotifications() async {
    final db = await instance.database;

    return await db.delete(
      tableNotifications,
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
