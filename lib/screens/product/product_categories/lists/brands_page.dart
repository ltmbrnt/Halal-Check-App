import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/brands.dart';
import '../forms/brand_form.dart'; // 👈 brand form page

class BrandListPage extends StatefulWidget {
  const BrandListPage({super.key});

  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {
  final BrandService _brandService = BrandService();
  List<Brand> _brands = [];

  @override
  void initState() {
    super.initState();
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    final brands = await _brandService.getBrands();
    setState(() {
      _brands = brands;
    });
  }

  Future<void> _confirmDeleteBrand(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить Бренд?'),
        content: const Text('Вы уверены, что хотите удалить этот бренд?'),
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
      await _brandService.deleteBrand(id);
      _loadBrands();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Бренд успешно удален!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brands'), backgroundColor: Colors.green),
      body: _brands.isEmpty
          ? const Center(child: Text('No brands yet.'))
          : ListView.builder(
        itemCount: _brands.length,
        itemBuilder: (context, index) {
          final brand = _brands[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(brand.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _confirmDeleteBrand(brand.id!),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BrandFormPage()),
          );
          _loadBrands(); // Reload after new brand added
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

