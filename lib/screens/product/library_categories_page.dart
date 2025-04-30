import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Only list pages imported!
import 'product_categories/lists/products_page.dart';
import 'product_categories/lists/ingredients_page.dart';
import 'product_categories/lists/certificates_page.dart';
import 'product_categories/lists/brands_page.dart';
import 'product_categories/lists/categories_page.dart';
import 'product_categories/lists/countries_page.dart';
import 'product_categories/lists/halal_authorities_page.dart';
import 'product_categories/lists/halal_evaluations_page.dart';
import 'product_categories/lists/alergens_page.dart';
import 'product_categories/lists/certificates_page.dart';
import 'product_categories/lists/halal_evaluation_history_page.dart';

class LibraryCategoriesPage extends StatefulWidget {
  const LibraryCategoriesPage({Key? key}) : super(key: key);

  @override
  _LibraryCategoriesPageState createState() => _LibraryCategoriesPageState();
}

class _LibraryCategoriesPageState extends State<LibraryCategoriesPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAdmin = prefs.getBool('user_is_admin') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<_CategoryItem> userItems = [
      _CategoryItem('Продукты', Icons.fastfood, const ProductListPage(), Colors.green),
      _CategoryItem('Ингредиенты', Icons.local_pizza, const IngredientListPage(), Colors.green),
      _CategoryItem('Сертификаты', Icons.verified, const CertificateListPage(), Colors.green),
    ];

    final List<_CategoryItem> adminItems = [
      _CategoryItem('Бренды', Icons.business, const BrandListPage(), Colors.deepPurple),
      _CategoryItem('Категории', Icons.category, const CategoryListPage(), Colors.deepPurple),
      _CategoryItem('Страны', Icons.public, const CountryListPage(), Colors.deepPurple),
      _CategoryItem('Органы Халяль', Icons.flag, const HalalAuthorityListPage(), Colors.deepPurple),
      _CategoryItem('Оценки Халяль', Icons.check_circle, const HalalEvaluationListPage(), Colors.deepPurple),
      _CategoryItem('Аллергены', Icons.warning, const AllergenListPage(), Colors.deepPurple),
      _CategoryItem('Продукт-Сертификаты', Icons.link, const CertificateListPage(), Colors.deepPurple),
      _CategoryItem('История Оценок', Icons.history, const HalalEvaluationHistoryListPage(), Colors.deepPurple),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Библиотека'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Пользовательский раздел', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: userItems.map((item) => _CategoryCard(item: item)).toList(),
            ),
            const SizedBox(height: 20),
            if (_isAdmin) ...[
              const Text('Админский раздел', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 12),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: adminItems.map((item) => _CategoryCard(item: item)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final Widget page;
  final Color color;

  const _CategoryItem(this.title, this.icon, this.page, this.color);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Set the background color to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0, // Remove the shadow (elevation set to 0)
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => item.page),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, size: 48, color: item.color),
              const SizedBox(height: 8),
              Text(
                item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
