import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class ProductCategory {
  final int productId;
  final int categoryId;

  ProductCategory({
    required this.productId,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'category_id': categoryId,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      productId: map['product_id'],
      categoryId: map['category_id'],
    );
  }
}

class ProductCategoryService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Product Category
  Future<int> insertProductCategory(ProductCategory category) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProductCategories,
      category.toMap(),
    );
  }

// Get all Product Categories
  Future<List<ProductCategory>> getProductCategories() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProductCategories);
    return res.isNotEmpty
        ? res.map((c) => ProductCategory.fromMap(c)).toList()
        : [];
  }

// Update Product Category
  Future<int> updateProductCategory(ProductCategory category) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableProductCategories,
      category.toMap(),
      where: '$columnProductCategoryProductId = ? AND $columnProductCategoryCategoryId = ?',
      whereArgs: [category.productId, category.categoryId],
    );
  }

// Delete Product Category
  Future<int> deleteProductCategory(int productId, int categoryId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProductCategories,
      where: '$columnProductCategoryProductId = ? AND $columnProductCategoryCategoryId = ?',
      whereArgs: [productId, categoryId],
    );
  }

}