import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class HalalAuthority {
  final int? id;
  final String name;
  final int countryId;
  final String trustLevel;
  final String? notes;

  HalalAuthority({
    this.id,
    required this.name,
    required this.countryId,
    required this.trustLevel,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'country_id': countryId,
      'trust_level': trustLevel,
      'notes': notes,
    };
  }

  factory HalalAuthority.fromMap(Map<String, dynamic> map) {
    return HalalAuthority(
      id: map['id'],
      name: map['name'],
      countryId: map['country_id'],
      trustLevel: map['trust_level'],
      notes: map['notes'],
    );
  }
}

class HalalAuthorityService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Halal Authority
  Future<int> insertHalalAuthority(HalalAuthority authority) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableHalalAuthorities,
      authority.toMap(),
    );
  }

// Get all Halal Authorities
  Future<List<HalalAuthority>> getHalalAuthorities() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableHalalAuthorities);
    return res.isNotEmpty
        ? res.map((c) => HalalAuthority.fromMap(c)).toList()
        : [];
  }

// Update Halal Authority
  Future<int> updateHalalAuthority(HalalAuthority authority) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableHalalAuthorities,
      authority.toMap(),
      where: '$columnHalalAuthorityId = ?',
      whereArgs: [authority.id],
    );
  }

// Delete Halal Authority
  Future<int> deleteHalalAuthority(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableHalalAuthorities,
      where: '$columnHalalAuthorityId = ?',
      whereArgs: [id],
    );
  }

}