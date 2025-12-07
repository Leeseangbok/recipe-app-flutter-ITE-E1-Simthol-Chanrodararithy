import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:recipe_finder_flutter_app/data/model/meal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE favorites (
      id TEXT PRIMARY KEY,
      meal TEXT,
      mealThumb TEXT,
      area TEXT,
      category TEXT
    )
    ''');
  }

  Future<void> insertFavorite(Meal meal) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      {
        'id': meal.id,
        'meal': meal.meal,
        'mealThumb': meal.mealThumb,
        'area': meal.area,
        'category': meal.category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await instance.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await instance.database;
    return await db.query('favorites');
  }
  
  Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }
}