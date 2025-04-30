import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class ProductAllergen {
  final int productId;
  final int allergenId;

  ProductAllergen({
    required this.productId,
    required this.allergenId,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'allergen_id': allergenId,
    };
  }

  factory ProductAllergen.fromMap(Map<String, dynamic> map) {
    return ProductAllergen(
      productId: map['product_id'],
      allergenId: map['allergen_id'],
    );
  }
}

class ProductAllergenService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Product Allergen
  Future<int> insertProductAllergen(ProductAllergen allergen) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProductAllergens,
      allergen.toMap(),
    );
  }

// Get all Product Allergens
  Future<List<ProductAllergen>> getProductAllergens() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProductAllergens);
    return res.isNotEmpty
        ? res.map((c) => ProductAllergen.fromMap(c)).toList()
        : [];
  }

// Update Product Allergen
  Future<int> updateProductAllergen(ProductAllergen allergen) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableProductAllergens,
      allergen.toMap(),
      where: '$columnProductAllergenProductId = ? AND $columnProductAllergenAllergenId = ?',
      whereArgs: [allergen.productId, allergen.allergenId],
    );
  }

// Delete Product Allergen
  Future<int> deleteProductAllergen(int productId, int allergenId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProductAllergens,
      where: '$columnProductAllergenProductId = ? AND $columnProductAllergenAllergenId = ?',
      whereArgs: [productId, allergenId],
    );
  }

}