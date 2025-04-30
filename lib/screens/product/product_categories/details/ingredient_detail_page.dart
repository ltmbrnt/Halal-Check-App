import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/ingredients.dart';

class IngredientDetailPage extends StatefulWidget {
  final int ingredientId;

  const IngredientDetailPage({Key? key, required this.ingredientId}) : super(key: key);

  @override
  _IngredientDetailPageState createState() => _IngredientDetailPageState();
}

class _IngredientDetailPageState extends State<IngredientDetailPage> {
  final IngredientService _ingredientService = IngredientService();
  Ingredient? _ingredient;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIngredient();
  }

  Future<void> _loadIngredient() async {
    final ing = await _ingredientService.getIngredientById(widget.ingredientId);
    setState(() {
      _ingredient = ing;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Details'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ingredient == null
          ? const Center(child: Text('Ingredient not found.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailRow('Name', _ingredient!.name),
            _buildDetailRow('E-Code', _ingredient!.eCode ?? '-'),
            _buildDetailRow('Is Haram', _ingredient!.isHaram ? 'Yes' : 'No'),
            _buildDetailRow('Is Doubtful', _ingredient!.isDoubtful ? 'Yes' : 'No'),
            _buildDetailRow('Notes', _ingredient!.notes ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
