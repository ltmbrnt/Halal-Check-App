import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class DietRule {
  final int? id;
  final String dietCode;
  final String description;
  final String sqlCondition;
  final bool autoAssign;

  DietRule({
    this.id,
    required this.dietCode,
    required this.description,
    required this.sqlCondition,
    required this.autoAssign,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diet_code': dietCode,
      'description': description,
      'sql_condition': sqlCondition,
      'auto_assign': autoAssign ? 1 : 0,
    };
  }

  factory DietRule.fromMap(Map<String, dynamic> map) {
    return DietRule(
      id: map['id'],
      dietCode: map['diet_code'],
      description: map['description'],
      sqlCondition: map['sql_condition'],
      autoAssign: map['auto_assign'] == 1,
    );
  }
}

class DietRuleService{
  final DBHelper _dbHelper = DBHelper.instance;
  // Insert Diet Rule
  Future<int> insertDietRule(DietRule rule) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableDietRules,
      rule.toMap(),
    );
  }

// Get all Diet Rules
  Future<List<DietRule>> getDietRules() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableDietRules);
    return res.isNotEmpty
        ? res.map((c) => DietRule.fromMap(c)).toList()
        : [];
  }

// Update Diet Rule
  Future<int> updateDietRule(DietRule rule) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableDietRules,
      rule.toMap(),
      where: '$columnDietRuleId = ?',
      whereArgs: [rule.id],
    );
  }

// Delete Diet Rule
  Future<int> deleteDietRule(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableDietRules,
      where: '$columnDietRuleId = ?',
      whereArgs: [id],
    );
  }

}