import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/ingredients.dart';

class IngredientFormPage extends StatefulWidget {
  const IngredientFormPage({super.key});

  @override
  _IngredientFormPageState createState() => _IngredientFormPageState();
}

class _IngredientFormPageState extends State<IngredientFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _eCodeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isHaram = false;
  bool _isDoubtful = false;

  final IngredientService _service = IngredientService();

  // Save the ingredient
  Future<void> _saveIngredient() async {
    if (_formKey.currentState!.validate()) {
      Ingredient newIngredient = Ingredient(
        name: _nameController.text.trim(),
        eCode: _eCodeController.text.isNotEmpty ? _eCodeController.text.trim() : null,
        isHaram: _isHaram,
        isDoubtful: _isDoubtful,
        notes: _notesController.text.isNotEmpty ? _notesController.text.trim() : null,
      );

      await _service.insertIngredient(newIngredient);
      Navigator.pop(context, true); // Notify that ingredient has been added
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _eCodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ingredient'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Ingredient Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ingredient Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter ingredient name' : null,
              ),
              const SizedBox(height: 10),

              // E-Code (optional)
              TextFormField(
                controller: _eCodeController,
                decoration: const InputDecoration(labelText: 'E-Code (optional)'),
              ),
              const SizedBox(height: 10),

              // Is Haram?
              SwitchListTile(
                title: const Text('Is Haram?'),
                value: _isHaram,
                onChanged: (val) {
                  setState(() {
                    _isHaram = val;
                  });
                },
              ),

              // Is Doubtful?
              SwitchListTile(
                title: const Text('Is Doubtful?'),
                value: _isDoubtful,
                onChanged: (val) {
                  setState(() {
                    _isDoubtful = val;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Notes (optional)
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 20),

              // Save Ingredient Button
              ElevatedButton(
                onPressed: _saveIngredient,
                child: const Text('Save Ingredient'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


