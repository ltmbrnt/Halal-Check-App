import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models//allergens.dart';
import '../forms/allergen_form.dart';

class AllergenListPage extends StatefulWidget {
  const AllergenListPage({super.key});

  @override
  _AllergenListPageState createState() => _AllergenListPageState();
}

class _AllergenListPageState extends State<AllergenListPage> {
  final AllergenService _allergenService = AllergenService();
  List<Allergen> _allergens = [];

  @override
  void initState() {
    super.initState();
    _loadAllergens();
  }

  Future<void> _loadAllergens() async {
    final allergens = await _allergenService.getAllergens();
    setState(() {
      _allergens = allergens;
    });
  }

  Future<void> _confirmDeleteAllergen(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить Аллерген?'),
        content: const Text('Вы уверены, что хотите удалить этот аллерген?'),
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
      await _allergenService.deleteAllergen(id);
      _loadAllergens();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Аллерген успешно удален!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Allergens'), backgroundColor: Colors.green),
      body: _allergens.isEmpty
          ? const Center(child: Text('No allergens yet.'))
          : ListView.builder(
        itemCount: _allergens.length,
        itemBuilder: (context, index) {
          final allergen = _allergens[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(allergen.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteAllergen(allergen.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AllergenFormPage()),
          );
          _loadAllergens();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

