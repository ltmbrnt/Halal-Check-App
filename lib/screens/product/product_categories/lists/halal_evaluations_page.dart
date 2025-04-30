import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/halal_evaluations.dart';
import 'package:HalalCheck/database/models//products.dart';
import '../forms/halal_evaluation_form.dart';

class HalalEvaluationListPage extends StatefulWidget {
  const HalalEvaluationListPage({super.key});

  @override
  _HalalEvaluationListPageState createState() => _HalalEvaluationListPageState();
}

class _HalalEvaluationListPageState extends State<HalalEvaluationListPage> {
  final HalalEvaluationService _halalEvaluationService = HalalEvaluationService();
  final ProductService _productService = ProductService();

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _productService.getProducts();
    setState(() {
      _products = products;
    });
  }

  Future<String> _loadHalalStatus(int productId) async {
    return await _productService.getHalalStatus(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halal Evaluations'),
        backgroundColor: Colors.green,
      ),
      body: _products.isEmpty
          ? const Center(child: Text('No products yet.'))
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return FutureBuilder<String>(
            future: _loadHalalStatus(product.id!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const ListTile(title: Text('Loading...'));
              }
              final status = snapshot.data ?? 'Unknown';
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Status: $status'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HalalEvaluationFormPage(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
