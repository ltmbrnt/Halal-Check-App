import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/products.dart';
import 'package:HalalCheck/screens/product/product_categories/details/product_detail_page.dart';
import '../../../../database/models/product_certificates.dart';
import '../forms/product_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'certificates_link_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService _productService = ProductService();
  final ProductCertificateService _productCertificateService = ProductCertificateService();

  List<Product> _products = [];
  Map<int, int> _certificateCounts = {}; // productId -> number of certificates
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _checkIfAdmin();
  }

  Future<void> _loadProducts() async {
    final products = await _productService.getProducts();
    final productCertLinks = await _productCertificateService.getProductCertificates();

    final Map<int, int> certCount = {};
    for (var link in productCertLinks) {
      certCount.update(link.productId, (count) => count + 1, ifAbsent: () => 1);
    }

    setState(() {
      _products = products;
      _certificateCounts = certCount;
    });
  }

  Future<void> _checkIfAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('user_is_admin') ?? false;
    });
  }

  Future<void> _confirmDeleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить Продукт'),
        content: const Text('Вы уверены, что хотите удалить этот продукт?'),
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
      await _productService.deleteProduct(id);
      _loadProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Продукт успешно удален!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Продукты'),
        backgroundColor: Colors.green,
      ),
      body: _products.isEmpty
          ? const Center(child: Text('Пока нет продуктов.'))
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final certCount = _certificateCounts[product.id] ?? 0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Colors.green),
              title: Text(product.name),
              subtitle: Text('Barcode: ${product.barcode}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(productId: product.id!),
                  ),
                );
              },
              trailing: _isAdmin
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Link Certificates Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductCertificatesLinkPage(
                            productId: product.id!,
                            productName: product.name,
                          ),
                        ),
                      ).then((_) => _loadProducts());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(90, 36),
                    ),
                    child: Text('($certCount)', style: const TextStyle(fontSize: 11)),
                  ),

                  // Edit Button
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormPage(existingProduct: product),
                        ),
                      );
                      _loadProducts(); // Refresh after edit
                    },
                  ),

                  // Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDeleteProduct(product.id!),
                  ),
                ],
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
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          );
          _loadProducts(); // Refresh after adding
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      )
          : null,
    );
  }
}
