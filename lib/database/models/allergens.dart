import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Allergen {
  final int? id;
  final String name;

  Allergen({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Allergen.fromMap(Map<String, dynamic> map) {
    return Allergen(
      id: map['id'],
      name: map['name'],
    );
  }
}

class AllergenService{
  final DBHelper _dbHelper = DBHelper.instance;

  // Insert Allergen
  Future<int> insertAllergen(Allergen allergen) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableAllergens,
      allergen.toMap(),
    );
  }

// Get all Allergens
  Future<List<Allergen>> getAllergens() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableAllergens);
    return res.isNotEmpty
        ? res.map((c) => Allergen.fromMap(c)).toList()
        : [];
  }

// Update Allergen
  Future<int> updateAllergen(Allergen allergen) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableAllergens,
      allergen.toMap(),
      where: '$columnAllergenId = ?',
      whereArgs: [allergen.id],
    );
  }

// Delete Allergen
  Future<int> deleteAllergen(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableAllergens,
      where: '$columnAllergenId = ?',
      whereArgs: [id],
    );
  }
  Future<String> getAllergenNameById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableAllergens,
      where: '$columnAllergenId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return res.first[columnAllergenName] as String;
    }
    return 'Unknown';
  }

}