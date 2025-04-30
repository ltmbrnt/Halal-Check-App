import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Certificate {
  final int? id;
  final int authorityId;
  final String certNumber;
  final String issueDate;
  final String expiryDate;
  final String? imageUrl;
  final bool verified;
  final String? notes;

  Certificate({
    this.id,
    required this.authorityId,
    required this.certNumber,
    required this.issueDate,
    required this.expiryDate,
    this.imageUrl,
    required this.verified,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authority_id': authorityId,
      'cert_number': certNumber,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'image_url': imageUrl,
      'verified': verified ? 1 : 0,
      'notes': notes,
    };
  }

  factory Certificate.fromMap(Map<String, dynamic> map) {
    return Certificate(
      id: map['id'],
      authorityId: map['authority_id'],
      certNumber: map['cert_number'],
      issueDate: map['issue_date'],
      expiryDate: map['expiry_date'],
      imageUrl: map['image_url'],
      verified: map['verified'] == 1,
      notes: map['notes'],
    );
  }
}

class CertificateService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Certificate
  Future<int> insertCertificate(Certificate certificate) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableCertificates,
      certificate.toMap(),
    );
  }

// Get all Certificates
  Future<List<Certificate>> getCertificates() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableCertificates);
    return res.isNotEmpty
        ? res.map((c) => Certificate.fromMap(c)).toList()
        : [];
  }

// Update Certificate
  Future<int> updateCertificate(Certificate certificate) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableCertificates,
      certificate.toMap(),
      where: '$columnCertId = ?',
      whereArgs: [certificate.id],
    );
  }

// Delete Certificate
  Future<int> deleteCertificate(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableCertificates,
      where: '$columnCertId = ?',
      whereArgs: [id],
    );
  }
  Future<Certificate?> getCertificateById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableCertificates,
      where: '$columnCertId = ?',
      whereArgs: [id],
    );
    if (res.isNotEmpty) {
      return Certificate.fromMap(res.first);
    }
    return null;
  }

}