import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';
import 'package:path_provider/path_provider.dart';

class FavoritesDao {
  static final FavoritesDao _instance = FavoritesDao._internal();
  factory FavoritesDao() => _instance;
  FavoritesDao._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'favorites.db');
    return await openDatabase(path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE favorites (
              id TEXT PRIMARY KEY,
              meal_json TEXT NOT NULL
            )
          ''');
        });
  }

  Future<void> insertFavorite(Meal meal) async {
    final dbClient = await db;
    await dbClient.insert('favorites', {
      'id': meal.id,
      'meal_json': meal.toRawJson(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String id) async {
    final dbClient = await db;
    await dbClient.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Meal>> getAllFavorites() async {
    final dbClient = await db;
    final rows = await dbClient.query('favorites');
    return rows.map((r) => Meal.fromRawJson(r['meal_json'] as String)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final dbClient = await db;
    final rows = await dbClient.query('favorites', where: 'id = ?', whereArgs: [id]);
    return rows.isNotEmpty;
  }
}
