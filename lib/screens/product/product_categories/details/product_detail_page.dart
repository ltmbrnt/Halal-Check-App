import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/products.dart';
import 'package:HalalCheck/database/models/certificates.dart';
import 'package:HalalCheck/database/models/product_certificates.dart';
import 'package:HalalCheck/database/models/halal_evaluations.dart';
import 'package:HalalCheck/database/models/product_ingredients.dart';
import 'package:HalalCheck/database/models/ingredients.dart';
import 'package:HalalCheck/database/models/product_categories.dart';
import 'package:HalalCheck/database/models/categories.dart';
import 'package:HalalCheck/database/models/product_allergens.dart';
import 'package:HalalCheck/database/models/allergens.dart';
import '../details/certeficate_detail_page.dart';
import '../details/ingredient_detail_page.dart';
import 'package:HalalCheck/database/models/brands.dart';
import 'package:HalalCheck/database/models/countries.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductService _productService = ProductService();
  final ProductCertificateService _productCertificateService = ProductCertificateService();
  final CertificateService _certificateService = CertificateService();
  final HalalEvaluationService _halalEvaluationService = HalalEvaluationService();
  final ProductIngredientService _productIngredientService = ProductIngredientService();
  final IngredientService _ingredientService = IngredientService();
  final ProductCategoryService _productCategoryService = ProductCategoryService();
  final CategoryService _categoryService = CategoryService();
  final ProductAllergenService _productAllergenService = ProductAllergenService();
  final AllergenService _allergenService = AllergenService();
  final BrandService _brandService = BrandService();
  final CountryService _countryService = CountryService();
  Product? _product;
  List<Certificate> _certificates = [];
  String? _halalStatus;
  List<Map<String, dynamic>> _ingredients = [];
  List<String> _categories = [];
  List<String> _allergens = [];
  bool _isLoading = true;
  String? _brandName;
  String? _countryName;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final product = await _productService.getProductById(widget.productId);

    if (product != null) {
      final brand = await BrandService().getBrandById(product.brandId);
      final country = await CountryService().getCountryById(product.countryId);

      final certLinks = await _productCertificateService.getProductCertificates();
      final linkedCertIds = certLinks
          .where((link) => link.productId == widget.productId)
          .map((link) => link.certId)
          .toList();

      final certificates = <Certificate>[];
      for (var certId in linkedCertIds) {
        final cert = await _certificateService.getCertificateById(certId);
        if (cert != null) {
          certificates.add(cert);
        }
      }

      final halalStatus = await _productService.getHalalStatus(widget.productId);

      final categoryLinks = await _productCategoryService.getProductCategories();
      final allergenLinks = await _productAllergenService.getProductAllergens();
      final ingredientLinks = await _productIngredientService.getProductIngredients();

      final ingredients = <Map<String, dynamic>>[];
      for (var link in ingredientLinks.where((link) => link.productId == widget.productId)) {
        final ingredient = await _ingredientService.getIngredientById(link.ingredientId);
        if (ingredient != null) {
          ingredients.add({
            'ingredient': ingredient,
            'percent': link.percent,
          });
        }
      }

      final categoryFutures = categoryLinks
          .where((link) => link.productId == widget.productId)
          .map((link) => _categoryService.getCategoryNameById(link.categoryId))
          .toList();

      final allergenFutures = allergenLinks
          .where((link) => link.productId == widget.productId)
          .map((link) => _allergenService.getAllergenNameById(link.allergenId))
          .toList();

      final categories = await Future.wait(categoryFutures);
      final allergens = await Future.wait(allergenFutures);

      setState(() {
        _product = product;
        _certificates = certificates;
        _halalStatus = halalStatus;
        _ingredients = ingredients;
        _categories = categories;
        _allergens = allergens;
        _brandName = brand?.name ?? 'Unknown';
        _countryName = country?.name ?? 'Unknown';
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Color _getHalalColor(String status) {
    switch (status.toLowerCase()) {
      case 'halal':
        return Colors.green.shade100;
      case 'haram':
        return Colors.red.shade100;
      case 'doubtful':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData _getHalalIcon(String status) {
    switch (status.toLowerCase()) {
      case 'halal':
        return Icons.check_circle;
      case 'haram':
        return Icons.block;
      case 'doubtful':
        return Icons.help;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _product == null
          ? const Center(child: Text('Product not found.'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildProductHeader(),
            _buildSectionTitle('Basic Info'),
            _buildInfoRow('Name', _product!.name),
            _buildInfoRow('Barcode', _product!.barcode),
            _buildInfoRow('Brand', _brandName ?? '-'),
            _buildInfoRow('Country', _countryName ?? '-'),
            _buildInfoRow('Weight (g)', _product!.weightG?.toString() ?? '-'),
            if (_product!.filling != null && _product!.filling!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Filling:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_product!.filling!),
            ],

            if (_product!.description != null && _product!.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_product!.description!),
            ],

            const SizedBox(height: 20),

            _buildSectionTitle('Certificates'),
            if (_certificates.isEmpty)
              const Text('No certificates linked.')
            else
              ..._certificates.map((cert) => _buildCertificateCard(cert)),

            const SizedBox(height: 20),

            _buildSectionTitle('Halal Status'),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getHalalColor(_halalStatus ?? 'unknown'),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getHalalIcon(_halalStatus ?? 'unknown'),
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _halalStatus?.toUpperCase() ?? 'UNKNOWN',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Ingredients'),
            if (_ingredients.isEmpty)
              const Text('No ingredients linked.')
            else
              ..._ingredients.map((entry) {
                final Ingredient ingredient = entry['ingredient'];
                final double percent = entry['percent'];
                return ListTile(
                  title: Text('${ingredient.name} (${percent.toStringAsFixed(1)}%)'),
                  trailing: _buildHalalBadge(ingredient),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IngredientDetailPage(ingredientId: ingredient.id!),
                      ),
                    );
                  },
                );
              }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHalalBadge(Ingredient ingredient) {
    if (ingredient.isHaram) {
      return const Chip(
        label: Text('Haram', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      );
    } else if (ingredient.isDoubtful) {
      return const Chip(
        label: Text('Doubtful', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      );
    } else {
      return const Chip(
        label: Text('Halal', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      );
    }
  }

  Widget _buildProductHeader() {
    return Card(
      color: Colors.lightGreen.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_bag, size: 48, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _product!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Barcode: ${_product!.barcode}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCertificateCard(Certificate cert) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CertificateDetailPage(certId: cert.id!),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          title: Text('Certificate: ${cert.certNumber}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Valid until: ${cert.expiryDate}'),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    cert.verified ? Icons.verified : Icons.error,
                    color: cert.verified ? Colors.green : Colors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cert.verified ? 'Verified' : 'Not Verified',
                    style: TextStyle(
                      color: cert.verified ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


