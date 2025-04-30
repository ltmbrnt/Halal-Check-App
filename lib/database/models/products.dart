import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Product {
  final int? id;
  final String barcode;
  final int brandId;
  final String name;
  final double? weightG;
  final String? filling;
  final int countryId;
  final String? description;
  final int? shelfLifeDays;
  final double? storageTempMin;
  final double? storageTempMax;

  Product({
    this.id,
    required this.barcode,
    required this.brandId,
    required this.name,
    this.weightG,
    this.filling,
    required this.countryId,
    this.description,
    this.shelfLifeDays,
    this.storageTempMin,
    this.storageTempMax,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barcode': barcode,
      'brand_id': brandId,
      'name': name,
      'weight_g': weightG,
      'filling': filling,
      'country_id': countryId,
      'description': description,
      'shelf_life_days': shelfLifeDays,
      'storage_temp_min': storageTempMin,
      'storage_temp_max': storageTempMax,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      barcode: map['barcode'],
      brandId: map['brand_id'],
      name: map['name'],
      weightG: map['weight_g'],
      filling: map['filling'],
      countryId: map['country_id'],
      description: map['description'],
      shelfLifeDays: map['shelf_life_days'],
      storageTempMin: map['storage_temp_min'],
      storageTempMax: map['storage_temp_max'],
    );
  }
}

class ProductService {
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Product
  Future<int> insertProduct(Product product) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProducts,
      product.toMap(),
    );
  }

  // Get all Products
  Future<List<Product>> getProducts() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProducts);
    return res.isNotEmpty
        ? res.map((product) => Product.fromMap(product)).toList()
        : [];
  }
  // Get Product by Barcode
  Future<Product?> getProductByBarcode(String barcode) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableProducts,
      where: '$columnProductBarcode = ?',
      whereArgs: [barcode],
    );

    if (res.isNotEmpty) {
      return Product.fromMap(res.first); // Return the first product found
    }
    return null; // Return null if no product found
  }

// Get Halal Status by productId
  Future<String> getHalalStatus(int productId) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableHalalEvaluations,
      where: '$columnEvalProductId = ?',
      whereArgs: [productId],
    );
    if (res.isNotEmpty) {
      // Explicitly cast the value to String
      return res.first[columnEvalStatus] as String;  // This should return 'halal', 'haram', or 'doubtful'
    }
    return 'unknown';  // Default value if no evaluation exists
  }

  // Update Product
  Future<int> updateProduct(Product product) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableProducts,
      product.toMap(),
      where: '$columnProductId = ?',
      whereArgs: [product.id],
    );
  }
  // Get Product by ID
  Future<Product?> getProductById(int id) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableProducts,
      where: '$columnProductId = ?',
      whereArgs: [id],
    );

    if (res.isNotEmpty) {
      return Product.fromMap(res.first); // Return the product by ID
    }
    return null;
  }
  // Delete Product
  Future<int> deleteProduct(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProducts,
      where: '$columnProductId = ?',
      whereArgs: [id],
    );
  }

  Future<Product?> getProductByName(String name) async {
    final db = await _dbHelper.database;
    var res = await db.query(
      tableProducts,
      where: '$columnProductName = ?',
      whereArgs: [name],
    );

    if (res.isNotEmpty) {
      return Product.fromMap(res.first); // Return the first product found
    }
    return null; // Return null if no product found
  }

}
