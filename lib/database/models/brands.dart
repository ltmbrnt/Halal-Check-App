import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Brand {
  final int? id;
  final String name;

  Brand({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id'],
      name: map['name'],
    );
  }
}

class BrandService {
  final DBHelper _dbHelper = DBHelper.instance;  // Insert Brand
  Future<int> insertBrand(Brand brand) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableBrands,
      brand.toMap(),
    );
  }

// Get all Brands
  Future<List<Brand>> getBrands() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableBrands);
    return res.isNotEmpty
        ? res.map((c) => Brand.fromMap(c)).toList()
        : [];
  }

// Update Brand
  Future<int> updateBrand(Brand brand) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableBrands,
      brand.toMap(),
      where: '$columnBrandId = ?',
      whereArgs: [brand.id],
    );
  }

// Delete Brand
  Future<int> deleteBrand(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableBrands,
      where: '$columnBrandId = ?',
      whereArgs: [id],
    );
  }

  Future<Brand?> getBrandById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableBrands,
      where: '$columnBrandId = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? Brand.fromMap(res.first) : null;
  }
}