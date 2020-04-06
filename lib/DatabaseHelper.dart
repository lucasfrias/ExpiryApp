import 'package:intl/intl.dart';
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

  Future<List<FoodItem>> _retrieveFoods() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(FoodItem.TABLENAME, orderBy: 'expirationDate ASC');

    List<FoodItem> foodList = List.generate(maps.length, (i) {
      return FoodItem(
        id: maps[i]['id'],
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        expirationDate: maps[i]['expirationDate'],
        expired: maps[i]['expired'] == 1,
      );
    });

    for (var food in foodList){
      if(DateTime.parse(DateTime.now().toIso8601String()).isAfter(DateTime.parse(food.expirationDate)) &&
          (_formatISO(DateTime.now().toIso8601String()) != _formatISO(food.expirationDate))) {
        food.expired = true;
      }
      //TODO: Change delete date to 7 days
      DateTime deleteDate = DateTime.parse(food.expirationDate).add(new Duration(days: 2));
      if(DateTime.parse(food.expirationDate).isAfter(deleteDate))
        deleteFood(food.id);
    }
    return foodList;
  }

  Future<List<FoodItem>> retrieveNonExpiredFoods() async {
    List<FoodItem> foodList = await DatabaseHelper.instance._retrieveFoods();
    return foodList.where((food) => food.expired != true).toList();
  }

  Future<List<FoodItem>> retrieveExpiredFoods() async {
    List<FoodItem> foodList = await DatabaseHelper.instance._retrieveFoods();
    return foodList.where((food) => food.expired == true).toList();
  }

  String _formatISO(String date){
    var datetime = DateTime.parse(date.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]));
    return DateFormat.yMMMMd("en_US").format(datetime).toString();
  }

/*  updateFood(FoodItem food) async {
    final db = await database;

    await db.update(FoodItem.TABLENAME, food.toMap(),
        where: 'id = ?',
        whereArgs: [food.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }*/
}