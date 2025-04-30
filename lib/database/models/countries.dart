import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class Country {
  final int? id;
  final String name;

  Country({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'],
      name: map['name'],
    );
  }
}

class CountryService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Country
  Future<int> insertCountry(Country country) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableCountries,
      country.toMap(),
    );
  }

// Get all Countries
  Future<List<Country>> getCountries() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableCountries);
    return res.isNotEmpty
        ? res.map((c) => Country.fromMap(c)).toList()
        : [];
  }

// Update Country
  Future<int> updateCountry(Country country) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableCountries,
      country.toMap(),
      where: '$columnCountryId = ?',
      whereArgs: [country.id],
    );
  }

// Delete Country
  Future<int> deleteCountry(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableCountries,
      where: '$columnCountryId = ?',
      whereArgs: [id],
    );
  }
  Future<Country?> getCountryById(int id) async {
    final db = await _dbHelper.database;
    final res = await db.query(
      tableCountries,
      where: '$columnCountryId = ?',
      whereArgs: [id],
    );
    return res.isNotEmpty ? Country.fromMap(res.first) : null;
  }
}