import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/database_constants.dart';
import 'package:HalalCheck/database/models/halal_evaluation_history.dart';

class HalalEvaluation {
  final int productId;
  final String status;
  final String source;
  final String reasonType;
  final String reasonText;
  final String? evidenceUrl;
  final String updatedBy;
  final String updatedAt;

  HalalEvaluation({
    required this.productId,
    required this.status,
    required this.source,
    required this.reasonType,
    required this.reasonText,
    this.evidenceUrl,
    required this.updatedBy,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'status': status,
      'source': source,
      'reason_type': reasonType,
      'reason_text': reasonText,
      'evidence_url': evidenceUrl,
      'updated_by': updatedBy,
      'updated_at': updatedAt,
    };
  }

  factory HalalEvaluation.fromMap(Map<String, dynamic> map) {
    return HalalEvaluation(
      productId: map['product_id'],
      status: map['status'],
      source: map['source'],
      reasonType: map['reason_type'],
      reasonText: map['reason_text'],
      evidenceUrl: map['evidence_url'],
      updatedBy: map['updated_by'],
      updatedAt: map['updated_at'],
    );
  }
}

class HalalEvaluationService {
  final DBHelper _dbHelper = DBHelper.instance;

  // Insert or Update Halal Evaluation
  Future<void> insertOrUpdateHalalEvaluation(HalalEvaluation evaluation) async {
    final db = await _dbHelper.database;

    // Check if there is already evaluation for this product
    final existing = await db.query(
      tableHalalEvaluations,
      where: '$columnEvalProductId = ?',
      whereArgs: [evaluation.productId],
    );

    if (existing.isNotEmpty) {
      // Save previous evaluation to history
      final previousStatus = existing.first[columnEvalStatus];

      HalalEvaluationHistory history = HalalEvaluationHistory(
        evalId: existing.first[columnEvalId] as int,
        previousStatus: previousStatus as String,
        newStatus: evaluation.status,
        changedBy: evaluation.updatedBy,
        changedAt: DateTime.now().toIso8601String(),
      );

      final historyService = HalalEvaluationHistoryService();
      await historyService.insertHalalEvaluationHistory(history);

      // Now update the current evaluation
      await db.update(
        tableHalalEvaluations,
        evaluation.toMap(),
        where: '$columnEvalProductId = ?',
        whereArgs: [evaluation.productId],
      );
    } else {
      // Insert new evaluation
      await db.insert(
        tableHalalEvaluations,
        evaluation.toMap(),
      );
    }
  }
}
