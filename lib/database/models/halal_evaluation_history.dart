import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';

class HalalEvaluationHistory {
  final int? id;
  final int evalId;
  final String previousStatus;
  final String newStatus;
  final String changedBy;
  final String changedAt;

  HalalEvaluationHistory({
    this.id,
    required this.evalId,
    required this.previousStatus,
    required this.newStatus,
    required this.changedBy,
    required this.changedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eval_id': evalId,
      'previous_status': previousStatus,
      'new_status': newStatus,
      'changed_by': changedBy,
      'changed_at': changedAt,
    };
  }

  factory HalalEvaluationHistory.fromMap(Map<String, dynamic> map) {
    return HalalEvaluationHistory(
      id: map['id'],
      evalId: map['eval_id'],
      previousStatus: map['previous_status'],
      newStatus: map['new_status'],
      changedBy: map['changed_by'],
      changedAt: map['changed_at'],
    );
  }
}

class HalalEvaluationHistoryService {
  final DBHelper _dbHelper = DBHelper.instance;  // Insert Halal Evaluation History
  Future<int> insertHalalEvaluationHistory(HalalEvaluationHistory history) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableHalalEvaluationHistory,
      history.toMap(),
    );
  }

// Get all Halal Evaluation History
  Future<List<HalalEvaluationHistory>> getHalalEvaluationHistory() async {
    final db = await _dbHelper.database;
    var res = await db.query(tableHalalEvaluationHistory);
    return res.isNotEmpty
        ? res.map((c) => HalalEvaluationHistory.fromMap(c)).toList()
        : [];
  }

// Delete Halal Evaluation History
  Future<int> deleteHalalEvaluationHistory(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableHalalEvaluationHistory,
      where: '$columnHistoryId = ?',
      whereArgs: [id],
    );
  }

}