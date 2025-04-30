import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
    );
  }
}

class CategoryService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Category
  Future<int> insertCategory(Category category) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableCategories,
      category.toMap(),
    );
  }

// Get all Categories
  Future<List<Category>> getCategories() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableCategories);
    return res.isNotEmpty
        ? res.map((c) => Category.fromMap(c)).toList()
        : [];
  }

// Update Category
  Future<int> updateCategory(Category category) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableCategories,
      category.toMap(),
      where: '$columnCategoryId = ?',
      whereArgs: [category.id],
    );
  }

// Delete Category
  Future<int> deleteCategory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableCategories,
      where: '$columnCategoryId = ?',
      whereArgs: [id],
    );
  }
  Future<String> getCategoryNameById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableCategories,
      where: '$columnCategoryId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return res.first[columnCategoryName] as String;
    }
    return 'Unknown';
  }

}