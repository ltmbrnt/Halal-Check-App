import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class ProductCertificate {
  final int productId;
  final int certId;

  ProductCertificate({
    required this.productId,
    required this.certId,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'cert_id': certId,
    };
  }

  factory ProductCertificate.fromMap(Map<String, dynamic> map) {
    return ProductCertificate(
      productId: map['product_id'],
      certId: map['cert_id'],
    );
  }
}

class ProductCertificateService {
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Product Certificate
  Future<int> insertProductCertificate(ProductCertificate certificate) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableProductCertificates,
      certificate.toMap(),
    );
  }

// Get all Product Certificates
  Future<List<ProductCertificate>> getProductCertificates() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableProductCertificates);
    return res.isNotEmpty
        ? res.map((c) => ProductCertificate.fromMap(c)).toList()
        : [];
  }

// Delete Product Certificate
  Future<int> deleteProductCertificate(int productId, int certId) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableProductCertificates,
      where: '$columnProductCertProductId = ? AND $columnProductCertCertId = ?',
      whereArgs: [productId, certId],
    );
  }
}
