import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/countries.dart';

class CountryFormPage extends StatefulWidget {
  const CountryFormPage({super.key});

  @override
  _CountryFormPageState createState() => _CountryFormPageState();
}

class _CountryFormPageState extends State<CountryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final CountryService _countryService = CountryService();

  Future<void> _saveCountry() async {
    if (_formKey.currentState!.validate()) {
      Country newCountry = Country(name: _nameController.text.trim());
      await _countryService.insertCountry(newCountry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Country'), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Country Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter country name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCountry,
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