import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models//categories.dart';

class CategoryFormPage extends StatefulWidget {
  const CategoryFormPage({super.key});

  @override
  _CategoryFormPageState createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final CategoryService _categoryService = CategoryService();

  Future<void> _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      Category newCategory = Category(name: _nameController.text.trim());
      await _categoryService.insertCategory(newCategory);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter category name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCategory,
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
