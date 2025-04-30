import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/ingredients.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../forms/ingredient_form.dart';

class IngredientListPage extends StatefulWidget {
  const IngredientListPage({super.key});

  @override
  _IngredientListPageState createState() => _IngredientListPageState();
}

class _IngredientListPageState extends State<IngredientListPage> {
  final IngredientService _ingredientService = IngredientService();
  List<Ingredient> _ingredients = [];
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
    _checkIfAdmin();
  }

  // Load all ingredients from the database
  Future<void> _loadIngredients() async {
    final ingredients = await _ingredientService.getIngredients();
    setState(() {
      _ingredients = ingredients;
    });
  }

  // Check if the user is an admin (for showing delete option)
  Future<void> _checkIfAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('user_is_admin') ?? false;
    });
  }

  // Confirm delete action for an ingredient
  Future<void> _confirmDeleteIngredient(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить ИНГРЕДИЕНТ?'),
        content: const Text('Вы уверены, что хотите удалить этот ингредиент?'),
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
      await _ingredientService.deleteIngredient(id);
      _loadIngredients(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Ингредиент успешно удалён!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ингредиенты'),
        backgroundColor: Colors.green,
      ),
      body: _ingredients.isEmpty
          ? const Center(child: Text('Нет ингредиентов.'))
          : ListView.builder(
        itemCount: _ingredients.length,
        itemBuilder: (context, index) {
          final ingredient = _ingredients[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.food_bank, color: Colors.green),
              title: Text(ingredient.name),
              subtitle: Text(ingredient.eCode ?? 'No E-Code'),
              trailing: _isAdmin
                  ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteIngredient(ingredient.id!),
              )
                  : null,
            ),
          );
        },
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const IngredientFormPage()), // No need to pass productId here
          );
          _loadIngredients(); // Refresh the list after adding
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
    );
  }
}


