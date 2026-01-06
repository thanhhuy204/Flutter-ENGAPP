import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/entities/game_item.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "kids_vocab.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE vocab (
            id TEXT PRIMARY KEY,
            image TEXT,
            nameEn TEXT,
            nameJa TEXT,
            nameVi TEXT,
            audioPath TEXT,
            category TEXT
          )
        ''');
      },
    );
  }

  // Thêm từ vựng mới
  Future<void> insertWord(GameItem item, String category) async {
    final dbClient = await db;
    final Map<String, dynamic> row = item.toJson();
    row['category'] = category; // Lưu thêm category để lọc dữ liệu
    await dbClient.insert('vocab', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Lấy danh sách từ vựng theo category
  Future<List<GameItem>> getWords(String category) async {
    final dbClient = await db;
    List<Map<String, dynamic>> maps;
    if (category == 'All') {
      maps = await dbClient.query('vocab');
    } else {
      maps = await dbClient.query('vocab', where: 'category = ?', whereArgs: [category]);
    }
    return maps.map((e) => GameItem.fromJson(e)).toList();
  }

  // Xóa từ vựng
  Future<void> deleteWord(String id) async {
    final dbClient = await db;
    await dbClient.delete('vocab', where: 'id = ?', whereArgs: [id]);
  }
}