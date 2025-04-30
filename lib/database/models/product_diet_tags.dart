import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class ProductDietTag {
  final int productId;
  final String dietCode;
  final String source;
  final String? notes;

  ProductDietTag({
    required this.productId,
    required this.dietCode,
    required this.source,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'diet_code': dietCode,
      'source': source,
      'notes': notes,
    };
  }

  factory ProductDietTag.fromMap(Map<String, dynamic> map) {
    return ProductDietTag(
      productId: map['product_id'],
      dietCode: map['diet_code'],
      source: map['source'],
      notes: map['notes'],
    );
  }
}

class ProductDietTagService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Product Diet Tag
  Future<int> insertProductDietTag(ProductDietTag tag) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProductDietTags,
      tag.toMap(),
    );
  }

// Get all Product Diet Tags
  Future<List<ProductDietTag>> getProductDietTags() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProductDietTags);
    return res.isNotEmpty
        ? res.map((c) => ProductDietTag.fromMap(c)).toList()
        : [];
  }

// Update Product Diet Tag
  Future<int> updateProductDietTag(ProductDietTag tag) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableProductDietTags,
      tag.toMap(),
      where: '$columnProductDietTagProductId = ? AND $columnProductDietTagDietCode = ?',
      whereArgs: [tag.productId, tag.dietCode],
    );
  }

// Delete Product Diet Tag
  Future<int> deleteProductDietTag(int productId, String dietCode) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProductDietTags,
      where: '$columnProductDietTagProductId = ? AND $columnProductDietTagDietCode = ?',
      whereArgs: [productId, dietCode],
    );
  }

}