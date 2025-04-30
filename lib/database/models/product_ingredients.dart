import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';
class ProductIngredient {
  final int productId;
  final int ingredientId;
  final double percent;

  ProductIngredient({
    required this.productId,
    required this.ingredientId,
    required this.percent,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'ingredient_id': ingredientId,
      'percent': percent,
    };
  }

  factory ProductIngredient.fromMap(Map<String, dynamic> map) {
    return ProductIngredient(
      productId: map['product_id'],
      ingredientId: map['ingredient_id'],
      percent: map['percent'],
    );
  }
}

class ProductIngredientService {
  final DBHelper _dbHelper = DBHelper.instance;

  // Insert Product Ingredient
  Future<int> insertProductIngredient(ProductIngredient ingredient) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProductIngredients,
      ingredient.toMap(),
    );
  }

  // Get all Product Ingredients
  Future<List<ProductIngredient>> getProductIngredients() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProductIngredients);
    return res.isNotEmpty
        ? res.map((c) => ProductIngredient.fromMap(c)).toList()
        : [];
  }

  // Delete Product Ingredient Link
  Future<int> deleteProductIngredient(int productId, int ingredientId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProductIngredients,
      where: '$columnProductIngredientProductId = ? AND $columnProductIngredientIngredientId = ?',
      whereArgs: [productId, ingredientId],
    );
  }
}
