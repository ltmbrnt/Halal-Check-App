import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Ingredient {
  final int? id;
  final String name;
  final String? eCode;
  final bool isHaram;
  final bool isDoubtful;
  final String? notes;

  Ingredient({
    this.id,
    required this.name,
    this.eCode,
    required this.isHaram,
    required this.isDoubtful,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'e_code': eCode,
      'is_haram': isHaram ? 1 : 0,
      'is_doubtful': isDoubtful ? 1 : 0,
      'notes': notes,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      eCode: map['e_code'],
      isHaram: map['is_haram'] == 1,
      isDoubtful: map['is_doubtful'] == 1,
      notes: map['notes'],
    );
  }
}

class IngredientService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Ingredient
  Future<int> insertIngredient(Ingredient ingredient) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableIngredients,
      ingredient.toMap(),
    );
  }

// Get all Ingredients
  Future<List<Ingredient>> getIngredients() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableIngredients);
    return res.isNotEmpty
        ? res.map((c) => Ingredient.fromMap(c)).toList()
        : [];
  }

// Update Ingredient
  Future<int> updateIngredient(Ingredient ingredient) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableIngredients,
      ingredient.toMap(),
      where: '$columnIngredientId = ?',
      whereArgs: [ingredient.id],
    );
  }

// Delete Ingredient
  Future<int> deleteIngredient(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableIngredients,
      where: '$columnIngredientId = ?',
      whereArgs: [id],
    );
  }
  Future<String> getIngredientNameById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableIngredients,
      where: '$columnIngredientId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return res.first[columnIngredientName] as String;
    }
    return 'Unknown';
  }
  Future<Ingredient?> findIngredientByName(String name) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableIngredients,
      where: '$columnIngredientName LIKE ?',
      whereArgs: ['%$name%'],
    );
    if (res.isNotEmpty) {
      return Ingredient.fromMap(res.first);
    }
    return null;
  }

// Get Ingredient by ID
  Future<Ingredient?> getIngredientById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableIngredients,
      where: '$columnIngredientId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return Ingredient.fromMap(res.first);
    }
    return null;
  }

}