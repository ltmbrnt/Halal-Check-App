import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models//brands.dart';

class BrandFormPage extends StatefulWidget {
  const BrandFormPage({super.key});

  @override
  _BrandFormPageState createState() => _BrandFormPageState();
}

class _BrandFormPageState extends State<BrandFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final BrandService _brandService = BrandService();

  Future<void> _saveBrand() async {
    if (_formKey.currentState!.validate()) {
      Brand newBrand = Brand(name: _nameController.text.trim());
      await _brandService.insertBrand(newBrand);
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Brand'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Brand Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter brand name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBrand,
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
