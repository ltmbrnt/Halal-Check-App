import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models//allergens.dart';

class AllergenFormPage extends StatefulWidget {
  const AllergenFormPage({super.key});

  @override
  _AllergenFormPageState createState() => _AllergenFormPageState();
}

class _AllergenFormPageState extends State<AllergenFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final AllergenService _allergenService = AllergenService();

  Future<void> _saveAllergen() async {
    if (_formKey.currentState!.validate()) {
      Allergen newAllergen = Allergen(name: _nameController.text.trim());
      await _allergenService.insertAllergen(newAllergen);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Allergen'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Allergen Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter allergen name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAllergen,
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              )
            ],
          ),
        ),
      ),
    );
  }
}
