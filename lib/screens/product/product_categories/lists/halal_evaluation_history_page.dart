import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/halal_evaluation_history.dart';

class HalalEvaluationHistoryListPage extends StatefulWidget {
  const HalalEvaluationHistoryListPage({super.key});

  @override
  _HalalEvaluationHistoryListPageState createState() => _HalalEvaluationHistoryListPageState();
}

class _HalalEvaluationHistoryListPageState extends State<HalalEvaluationHistoryListPage> {
  final HalalEvaluationHistoryService _historyService = HalalEvaluationHistoryService();
  List<HalalEvaluationHistory> _historyRecords = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final records = await _historyService.getHalalEvaluationHistory();
    setState(() {
      _historyRecords = records;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halal Evaluation History'),
        backgroundColor: Colors.green,
      ),
      body: _historyRecords.isEmpty
          ? const Center(child: Text('No history available.'))
          : ListView.builder(
        itemCount: _historyRecords.length,
        itemBuilder: (context, index) {
          final record = _historyRecords[index];
          return ListTile(
            leading: const Icon(Icons.history, color: Colors.green),
            title: Text('Evaluation ID: ${record.evalId}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From: ${record.previousStatus} ➔ To: ${record.newStatus}'),
                Text('Changed by: ${record.changedBy}'),
                Text('At: ${record.changedAt}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
