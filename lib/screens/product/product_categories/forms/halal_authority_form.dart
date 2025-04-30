import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/halal_authorities.dart';
import 'package:HalalCheck/database/models/countries.dart';

class HalalAuthorityFormPage extends StatefulWidget {
  const HalalAuthorityFormPage({super.key});

  @override
  _HalalAuthorityFormPageState createState() => _HalalAuthorityFormPageState();
}

class _HalalAuthorityFormPageState extends State<HalalAuthorityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final HalalAuthorityService _authorityService = HalalAuthorityService();
  final CountryService _countryService = CountryService();

  List<Country> _countries = [];
  int? _selectedCountryId;
  String _selectedTrustLevel = 'medium'; // Default trust level

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countries = await _countryService.getCountries();
    setState(() {
      _countries = countries;
    });
  }

  Future<void> _saveAuthority() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a country')),
        );
        return;
      }

      HalalAuthority newAuthority = HalalAuthority(
        name: _nameController.text.trim(),
        countryId: _selectedCountryId!,
        trustLevel: _selectedTrustLevel,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await _authorityService.insertHalalAuthority(newAuthority);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Halal Authority'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Authority Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter authority name' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Country'),
                value: _selectedCountryId,
                items: _countries.map((country) {
                  return DropdownMenuItem(
                    value: country.id,
                    child: Text(country.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountryId = value;
                  });
                },
                validator: (value) => value == null ? 'Select a country' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Trust Level'),
                value: _selectedTrustLevel,
                items: ['high', 'medium', 'low'].map((level) {
                  return DropdownMenuItem(
                    value: level,
                    child: Text(level.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTrustLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveAuthority,
                child: const Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
