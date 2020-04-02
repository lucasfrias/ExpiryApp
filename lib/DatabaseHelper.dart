import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'FoodItem.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static const databaseName = 'foods_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database _database;

  Future<Database> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE foods(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, imageUrl TEXT, expirationDate TEXT, expired INTEGER)");
        });
  }

  addFood(FoodItem food) async {
    final db = await database;
    var res = await db.insert(FoodItem.TABLENAME, food.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  deleteFood(int id) async {
    var db = await database;
    db.delete(FoodItem.TABLENAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FoodItem>> retrieveFoods() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(FoodItem.TABLENAME);

    return List.generate(maps.length, (i) {
      return FoodItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        expirationDate: maps[i]['expirationDate'],
        expired: maps[i]['expired'] == 1,
      );
    });
  }

/*  updateFood(FoodItem food) async {
    final db = await database;

    await db.update(FoodItem.TABLENAME, food.toMap(),
        where: 'id = ?',
        whereArgs: [food.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }*/
}