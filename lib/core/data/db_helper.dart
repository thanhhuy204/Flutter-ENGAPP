import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../domain/entities/game_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DBHelper {
  static Database? _db;
  static const int _databaseVersion = 2; // Tăng version để trigger migration
  static bool _isSupported = !kIsWeb; // SQLite không hỗ trợ web

  // Check if SQLite is supported on this platform
  bool get isSupported => _isSupported;

  Future<Database> get db async {
    if (!_isSupported) {
      throw UnsupportedError('SQLite is not supported on web platform');
    }
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "kids_vocab.db");

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await _createTables(db);
        await _seedInitialData(db);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          // Migration: thêm cột isUserAdded nếu chưa có
          await db.execute('ALTER TABLE vocab ADD COLUMN isUserAdded INTEGER DEFAULT 0');
          await db.execute('ALTER TABLE vocab ADD COLUMN createdAt INTEGER');
          // Seed data nếu chưa có
          final count = await db.rawQuery('SELECT COUNT(*) as count FROM vocab');
          if ((count.first['count'] as int) == 0) {
            await _seedInitialData(db);
          }
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE vocab (
        id TEXT PRIMARY KEY,
        image TEXT,
        nameEn TEXT,
        nameJa TEXT,
        nameVi TEXT,
        audioPath TEXT,
        category TEXT,
        isUserAdded INTEGER DEFAULT 0,
        createdAt INTEGER
      )
    ''');
  }

  // Seed dữ liệu ban đầu từ GlobalDataSource
  Future<void> _seedInitialData(Database db) async {
    final batch = db.batch();

    // Animals
    final animals = [
      {'id': 'lion', 'image': 'assets/images/animals/lion.png', 'nameEn': 'Lion', 'nameJa': 'ライオン', 'nameVi': 'Sư tử', 'category': 'Animals'},
      {'id': 'tiger', 'image': 'assets/images/animals/tiger.png', 'nameEn': 'Tiger', 'nameJa': 'トラ', 'nameVi': 'Con hổ', 'category': 'Animals'},
      {'id': 'elephant', 'image': 'assets/images/animals/elephant.png', 'nameEn': 'Elephant', 'nameJa': 'ゾウ', 'nameVi': 'Con voi', 'category': 'Animals'},
      {'id': 'monkey', 'image': 'assets/images/animals/monkey.png', 'nameEn': 'Monkey', 'nameJa': 'サル', 'nameVi': 'Con khỉ', 'category': 'Animals'},
      {'id': 'zebra', 'image': 'assets/images/animals/zebra.png', 'nameEn': 'Zebra', 'nameJa': 'シマウマ', 'nameVi': 'Ngựa vằn', 'category': 'Animals'},
      {'id': 'giraffe', 'image': 'assets/images/animals/giraffe.png', 'nameEn': 'Giraffe', 'nameJa': 'キリン', 'nameVi': 'Hươu cao cổ', 'category': 'Animals'},
      {'id': 'cat', 'image': 'assets/images/animals/cat.png', 'nameEn': 'Cat', 'nameJa': 'ネコ', 'nameVi': 'Con mèo', 'category': 'Animals'},
      {'id': 'dog', 'image': 'assets/images/animals/dog.png', 'nameEn': 'Dog', 'nameJa': 'イヌ', 'nameVi': 'Con chó', 'category': 'Animals'},
      {'id': 'parrot', 'image': 'assets/images/animals/parrot.png', 'nameEn': 'Parrot', 'nameJa': 'オウム', 'nameVi': 'Con vẹt', 'category': 'Animals'},
      {'id': 'dolphin', 'image': 'assets/images/animals/dolphin.png', 'nameEn': 'Dolphin', 'nameJa': 'イルカ', 'nameVi': 'Cá heo', 'category': 'Animals'},
      {'id': 'shark', 'image': 'assets/images/animals/shark.png', 'nameEn': 'Shark', 'nameJa': 'サメ', 'nameVi': 'Cá mập', 'category': 'Animals'},
      {'id': 'penguin', 'image': 'assets/images/animals/penguin.png', 'nameEn': 'Penguin', 'nameJa': 'ペンギン', 'nameVi': 'Chim cánh cụt', 'category': 'Animals'},
      {'id': 'camel', 'image': 'assets/images/animals/camel.png', 'nameEn': 'Camel', 'nameJa': 'ラクダ', 'nameVi': 'Lạc đà', 'category': 'Animals'},
      {'id': 'kangaroo', 'image': 'assets/images/animals/kangaroo.png', 'nameEn': 'Kangaroo', 'nameJa': 'カンガルー', 'nameVi': 'Chuột túi', 'category': 'Animals'},
      {'id': 'horse', 'image': 'assets/images/animals/horse.png', 'nameEn': 'Horse', 'nameJa': 'ウマ', 'nameVi': 'Con ngựa', 'category': 'Animals'},
      {'id': 'duck', 'image': 'assets/images/animals/duck.png', 'nameEn': 'Duck', 'nameJa': 'アヒル', 'nameVi': 'Con vịt', 'category': 'Animals'},
      {'id': 'crab', 'image': 'assets/images/animals/crab.png', 'nameEn': 'Crab', 'nameJa': 'カニ', 'nameVi': 'Con cua', 'category': 'Animals'},
      {'id': 'fish', 'image': 'assets/images/animals/fish.png', 'nameEn': 'Fish', 'nameJa': 'サカナ', 'nameVi': 'Con cá', 'category': 'Animals'},
    ];

    // Fruits
    final fruits = [
      {'id': 'apple', 'image': 'assets/images/fruits/apple.png', 'nameEn': 'Apple', 'nameJa': 'リンゴ', 'nameVi': 'Quả táo', 'category': 'Fruits'},
      {'id': 'banana', 'image': 'assets/images/fruits/banana.png', 'nameEn': 'Banana', 'nameJa': 'バナナ', 'nameVi': 'Quả chuối', 'category': 'Fruits'},
      {'id': 'grape', 'image': 'assets/images/fruits/grape.png', 'nameEn': 'Grape', 'nameJa': 'ブドウ', 'nameVi': 'Quả nho', 'category': 'Fruits'},
      {'id': 'orange', 'image': 'assets/images/fruits/orange.png', 'nameEn': 'Orange', 'nameJa': 'オレンジ', 'nameVi': 'Quả cam', 'category': 'Fruits'},
      {'id': 'lemon', 'image': 'assets/images/fruits/lemon.png', 'nameEn': 'Lemon', 'nameJa': 'レモン', 'nameVi': 'Quả chanh', 'category': 'Fruits'},
      {'id': 'cherry', 'image': 'assets/images/fruits/cherry.png', 'nameEn': 'Cherry', 'nameJa': 'サクランボ', 'nameVi': 'Quả anh đào', 'category': 'Fruits'},
      {'id': 'strawberry', 'image': 'assets/images/fruits/strawberry.png', 'nameEn': 'Strawberry', 'nameJa': 'イチゴ', 'nameVi': 'Dâu tây', 'category': 'Fruits'},
      {'id': 'watermelon', 'image': 'assets/images/fruits/watermelon.png', 'nameEn': 'Watermelon', 'nameJa': 'スイカ', 'nameVi': 'Dưa hấu', 'category': 'Fruits'},
      {'id': 'mango', 'image': 'assets/images/fruits/mango.png', 'nameEn': 'Mango', 'nameJa': 'マンゴー', 'nameVi': 'Quả xoài', 'category': 'Fruits'},
      {'id': 'pineapple', 'image': 'assets/images/fruits/pineapple.png', 'nameEn': 'Pineapple', 'nameJa': 'パイナップル', 'nameVi': 'Quả dứa', 'category': 'Fruits'},
      {'id': 'pear', 'image': 'assets/images/fruits/pear.png', 'nameEn': 'Pear', 'nameJa': 'ナシ', 'nameVi': 'Quả lê', 'category': 'Fruits'},
      {'id': 'peach', 'image': 'assets/images/fruits/peach.png', 'nameEn': 'Peach', 'nameJa': 'モモ', 'nameVi': 'Quả đào', 'category': 'Fruits'},
    ];

    // Colors
    final colors = [
      {'id': 'red', 'image': 'assets/images/colors/Red.png', 'nameEn': 'Red', 'nameJa': 'あか', 'nameVi': 'Màu đỏ', 'category': 'Colors'},
      {'id': 'blue', 'image': 'assets/images/colors/Blue.png', 'nameEn': 'Blue', 'nameJa': 'あお', 'nameVi': 'Màu xanh dương', 'category': 'Colors'},
      {'id': 'green', 'image': 'assets/images/colors/Green.png', 'nameEn': 'Green', 'nameJa': 'みどり', 'nameVi': 'Màu xanh lá', 'category': 'Colors'},
      {'id': 'yellow', 'image': 'assets/images/colors/Yellow.png', 'nameEn': 'Yellow', 'nameJa': 'きいろ', 'nameVi': 'Màu vàng', 'category': 'Colors'},
      {'id': 'purple', 'image': 'assets/images/colors/Purple.png', 'nameEn': 'Purple', 'nameJa': 'むらさき', 'nameVi': 'Màu tím', 'category': 'Colors'},
      {'id': 'black', 'image': 'assets/images/colors/Black.png', 'nameEn': 'Black', 'nameJa': 'くろ', 'nameVi': 'Màu đen', 'category': 'Colors'},
      {'id': 'white', 'image': 'assets/images/colors/White.png', 'nameEn': 'White', 'nameJa': 'しろ', 'nameVi': 'Màu trắng', 'category': 'Colors'},
      {'id': 'orange_col', 'image': 'assets/images/colors/Orange.png', 'nameEn': 'Orange', 'nameJa': 'オレンジいろ', 'nameVi': 'Màu cam', 'category': 'Colors'},
      {'id': 'pink', 'image': 'assets/images/colors/Pink.png', 'nameEn': 'Pink', 'nameJa': 'ピンク', 'nameVi': 'Màu hồng', 'category': 'Colors'},
    ];

    for (var item in [...animals, ...fruits, ...colors]) {
      batch.insert('vocab', {
        ...item,
        'audioPath': null,
        'isUserAdded': 0,
        'createdAt': null,
      });
    }

    await batch.commit(noResult: true);
  }

  // Thêm từ vựng mới (từ người dùng)
  Future<void> insertWord(GameItem item, String category, {String? imagePath}) async {
    final dbClient = await db;
    await dbClient.insert('vocab', {
      'id': item.id,
      'image': imagePath ?? item.image,
      'nameEn': item.nameEn,
      'nameJa': item.nameJa,
      'nameVi': item.nameVi,
      'audioPath': null,
      'category': category,
      'isUserAdded': 1,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Lấy danh sách từ vựng theo category
  Future<List<GameItem>> getWords(String category) async {
    final dbClient = await db;
    List<Map<String, dynamic>> maps;
    if (category == 'All') {
      maps = await dbClient.query('vocab', orderBy: 'isUserAdded DESC, createdAt DESC');
    } else {
      maps = await dbClient.query(
        'vocab',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'isUserAdded DESC, createdAt DESC',
      );
    }
    return maps.map((e) => GameItem.fromJson(e)).toList();
  }

  // Lấy tất cả categories có trong database
  Future<List<String>> getCategories() async {
    final dbClient = await db;
    final result = await dbClient.rawQuery('SELECT DISTINCT category FROM vocab ORDER BY category');
    return result.map((row) => row['category'] as String).toList();
  }

  // Xóa từ vựng
  Future<void> deleteWord(String id) async {
    final dbClient = await db;
    await dbClient.delete('vocab', where: 'id = ?', whereArgs: [id]);
  }

  // Cập nhật từ vựng
  Future<void> updateWord(String id, {String? image, String? nameEn, String? nameJa, String? nameVi}) async {
    final dbClient = await db;
    final Map<String, dynamic> updates = {};
    if (image != null) updates['image'] = image;
    if (nameEn != null) updates['nameEn'] = nameEn;
    if (nameJa != null) updates['nameJa'] = nameJa;
    if (nameVi != null) updates['nameVi'] = nameVi;

    if (updates.isNotEmpty) {
      await dbClient.update('vocab', updates, where: 'id = ?', whereArgs: [id]);
    }
  }

  // Tìm kiếm từ vựng
  Future<List<GameItem>> searchWords(String keyword) async {
    final dbClient = await db;
    final maps = await dbClient.query(
      'vocab',
      where: 'nameEn LIKE ? OR nameVi LIKE ? OR nameJa LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
    );
    return maps.map((e) => GameItem.fromJson(e)).toList();
  }

  // Close database (cleanup)
  Future<void> close() async {
    final dbClient = await db;
    await dbClient.close();
    _db = null;
  }
}