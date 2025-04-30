import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class NutritionFact {
  final int productId;
  final double? proteinG;
  final double? fatG;
  final double? carbG;
  final double? sugarG;
  final int? kcal;

  NutritionFact({
    required this.productId,
    this.proteinG,
    this.fatG,
    this.carbG,
    this.sugarG,
    this.kcal,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'protein_g': proteinG,
      'fat_g': fatG,
      'carb_g': carbG,
      'sugar_g': sugarG,
      'kcal': kcal,
    };
  }

  factory NutritionFact.fromMap(Map<String, dynamic> map) {
    return NutritionFact(
      productId: map['product_id'],
      proteinG: map['protein_g'],
      fatG: map['fat_g'],
      carbG: map['carb_g'],
      sugarG: map['sugar_g'],
      kcal: map['kcal'],
    );
  }
}

class NutritionFactService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Nutrition Fact
  Future<int> insertNutritionFact(NutritionFact fact) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableNutritionFacts,
      fact.toMap(),
    );
  }

// Get all Nutrition Facts
  Future<List<NutritionFact>> getNutritionFacts() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableNutritionFacts);
    return res.isNotEmpty
        ? res.map((c) => NutritionFact.fromMap(c)).toList()
        : [];
  }

// Update Nutrition Fact
  Future<int> updateNutritionFact(NutritionFact fact) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableNutritionFacts,
      fact.toMap(),
      where: '$columnNutritionProductId = ?',
      whereArgs: [fact.productId],
    );
  }

// Delete Nutrition Fact
  Future<int> deleteNutritionFact(int productId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableNutritionFacts,
      where: '$columnNutritionProductId = ?',
      whereArgs: [productId],
    );
  }

}