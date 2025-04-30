import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models//products.dart';
import 'package:HalalCheck/database/models/halal_evaluations.dart';

class HalalEvaluationFormPage extends StatefulWidget {
  final Product product;

  const HalalEvaluationFormPage({super.key, required this.product});

  @override
  _HalalEvaluationFormPageState createState() => _HalalEvaluationFormPageState();
}

class _HalalEvaluationFormPageState extends State<HalalEvaluationFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reasonTextController = TextEditingController();
  final TextEditingController _evidenceUrlController = TextEditingController();
  final HalalEvaluationService _halalEvaluationService = HalalEvaluationService();

  String _status = 'halal'; // Default value
  String _reasonType = 'ingredient'; // Default value

  Future<void> _saveEvaluation() async {
    if (_formKey.currentState!.validate()) {
      HalalEvaluation newEval = HalalEvaluation(
        productId: widget.product.id!,
        status: _status,
        source: 'manual',
        reasonType: _reasonType,
        reasonText: _reasonTextController.text.trim(),
        evidenceUrl: _evidenceUrlController.text.trim(),
        updatedBy: 'admin', // optional, can be dynamic
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _halalEvaluationService.insertOrUpdateHalalEvaluation(newEval);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Halal evaluation saved!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluate: ${widget.product.name}'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Status Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Halal Status'),
                value: _status,
                items: ['halal', 'haram', 'doubtful'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Reason Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Reason Type'),
                value: _reasonType,
                items: ['ingredient', 'source', 'authority'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _reasonType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Reason Text
              TextFormField(
                controller: _reasonTextController,
                decoration: const InputDecoration(labelText: 'Reason Text (optional)'),
              ),
              const SizedBox(height: 16),

              // Evidence URL
              TextFormField(
                controller: _evidenceUrlController,
                decoration: const InputDecoration(labelText: 'Evidence URL (optional)'),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveEvaluation,
                child: const Text('Save Evaluation'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
