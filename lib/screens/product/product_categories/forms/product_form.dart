import 'package:flutter/material.dart';
import 'package:HalalCheck/database/models/products.dart';
import 'package:HalalCheck/database/models/brands.dart';
import 'package:HalalCheck/database/models/countries.dart';
import 'package:HalalCheck/database/models/ingredients.dart';
import 'package:HalalCheck/database/models/product_ingredients.dart';

class ProductFormPage extends StatefulWidget {
  final String? initialBarcode;
  final Product? existingProduct; // NEW

  const ProductFormPage({Key? key, this.initialBarcode, this.existingProduct}) : super(key: key);

  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}


class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ingredientsTextController = TextEditingController();
  late TextEditingController _barcodeController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _fillingController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _shelfLifeController = TextEditingController();
  final TextEditingController _storageTempMinController = TextEditingController();
  final TextEditingController _storageTempMaxController = TextEditingController();

  final ProductService productService = ProductService();
  final BrandService brandService = BrandService();
  final CountryService countryService = CountryService();

  List<Brand> _brands = [];
  List<Country> _countries = [];

  int? _selectedBrandId;
  int? _selectedCountryId;

  @override
  void initState() {
    super.initState();
    final product = widget.existingProduct;

    _barcodeController = TextEditingController(text: product?.barcode ?? widget.initialBarcode ?? '');
    _nameController.text = product?.name ?? '';
    _weightController.text = product?.weightG?.toString() ?? '';
    _fillingController.text = product?.filling ?? '';
    _descriptionController.text = product?.description ?? '';
    _shelfLifeController.text = product?.shelfLifeDays?.toString() ?? '';
    _storageTempMinController.text = product?.storageTempMin?.toString() ?? '';
    _storageTempMaxController.text = product?.storageTempMax?.toString() ?? '';
    _selectedBrandId = product?.brandId;
    _selectedCountryId = product?.countryId;

    _loadBrandsAndCountries();
  }


  Future<void> _loadBrandsAndCountries() async {
    final brands = await brandService.getBrands();
    final countries = await countryService.getCountries();

    setState(() {
      _brands = brands;
      _countries = countries;

      // 🛡️ Reset if not found
      if (!_brands.any((b) => b.id == _selectedBrandId)) {
        _selectedBrandId = null;
      }
      if (!_countries.any((c) => c.id == _selectedCountryId)) {
        _selectedCountryId = null;
      }
    });
  }


  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _fillingController.dispose();
    _descriptionController.dispose();
    _shelfLifeController.dispose();
    _storageTempMinController.dispose();
    _storageTempMaxController.dispose();
    super.dispose();
  }
  Future<void> _processIngredients(int productId, String ingredientsText) async {
    if (ingredientsText.trim().isEmpty) return;

    final ingredientNames = ingredientsText.split(',').map((e) => e.trim().toLowerCase()).toList();
    final ingredientService = IngredientService();
    final productIngredientService = ProductIngredientService();

    for (var name in ingredientNames) {
      final ingredient = await ingredientService.findIngredientByName(name);
      if (ingredient != null && (ingredient.isHaram || ingredient.isDoubtful)) {
        await productIngredientService.insertProductIngredient(
          ProductIngredient(
            productId: productId,
            ingredientId: ingredient.id!,
            percent: 0, // 0 because user enters text, no % info
          ),
        );
      }
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedBrandId == null || _selectedCountryId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both Brand and Country')),
        );
        return;
      }

      Product product = Product(
        id: widget.existingProduct?.id, // Set ID if editing
        barcode: _barcodeController.text.trim(),
        brandId: _selectedBrandId!,
        countryId: _selectedCountryId!,
        name: _nameController.text.trim(),
        weightG: _weightController.text.isNotEmpty ? double.tryParse(_weightController.text) : null,
        filling: _fillingController.text.trim().isNotEmpty ? _fillingController.text.trim() : null,
        description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
        shelfLifeDays: _shelfLifeController.text.isNotEmpty ? int.tryParse(_shelfLifeController.text) : null,
        storageTempMin: _storageTempMinController.text.isNotEmpty ? double.tryParse(_storageTempMinController.text) : null,
        storageTempMax: _storageTempMaxController.text.isNotEmpty ? double.tryParse(_storageTempMaxController.text) : null,
      );

      try {
        if (widget.existingProduct != null) {
          await productService.updateProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Product updated successfully.')),
          );
        } else {
          await productService.insertProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Product added successfully.')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: ${e.toString()}')),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Barcode input
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                readOnly: widget.initialBarcode != null,
                validator: (value) => value == null || value.isEmpty ? 'Please enter barcode' : null,
              ),
              const SizedBox(height: 16),

              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 16),

              // Brand Dropdown
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Select Brand'),
                value: _brands.any((b) => b.id == _selectedBrandId) ? _selectedBrandId : null, // ✅ Safety check
                items: _brands.map((brand) {
                  return DropdownMenuItem<int>(
                    value: brand.id,
                    child: Text(brand.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBrandId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a brand' : null,
              ),

              const SizedBox(height: 16),

              // Country Dropdown
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
                validator: (value) => value == null ? 'Please select a country' : null,
              ),
              const SizedBox(height: 16),

              // Weight G
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Weight (g) (optional)'),
              ),
              const SizedBox(height: 16),

              // Filling
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsTextController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ingredients List (comma-separated)',
                  hintText: 'e.g., Sugar, Cocoa Butter, Gelatin, E471',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
              ),
              const SizedBox(height: 16),

              // Shelf Life Days
              TextFormField(
                controller: _shelfLifeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Shelf Life Days (optional)'),
              ),
              const SizedBox(height: 16),

              // Storage Temp Min
              TextFormField(
                controller: _storageTempMinController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Storage Temp Min (optional)'),
              ),
              const SizedBox(height: 16),

              // Storage Temp Max
              TextFormField(
                controller: _storageTempMaxController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Storage Temp Max (optional)'),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveProduct,
                child: const Text("Save Product"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



