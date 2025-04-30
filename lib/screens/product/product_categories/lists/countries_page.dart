import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/countries.dart';
import '../forms/country_form.dart'; // 👈 Import the form page

class CountryListPage extends StatefulWidget {
  const CountryListPage({super.key});

  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  final CountryService _countryService = CountryService();
  List<Country> _countries = [];

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

  Future<void> _confirmDeleteCountry(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить Страну?'),
        content: const Text('Вы уверены, что хотите удалить эту страну?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _countryService.deleteCountry(id);
      _loadCountries();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Страна успешно удалена!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countries'), backgroundColor: Colors.green),
      body: _countries.isEmpty
          ? const Center(child: Text('No countries yet.'))
          : ListView.builder(
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final country = _countries[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(country.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteCountry(country.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CountryFormPage()),
          );
          _loadCountries();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
