import 'package:HalalCheck/screens/product/product_categories/forms/product_form.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:HalalCheck/database/models/products.dart'; // Import ProductService

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  ScannerPageState createState() => ScannerPageState();
}

class ScannerPageState extends State<ScannerPage> {
  String barcode = "";
  bool _isScanning = true;  // Initially set to true for scanning mode
  bool isLoadingProduct = false;
  bool _isAdmin = false;
  Map<String, dynamic>? productData;

  final ProductService productService = ProductService(); // Create an instance of ProductService

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

  // Start scanning method
  Future<void> startScanning() async {
    setState(() {
      _isScanning = true;
      barcode = "";
      productData = null;
    });
    await scanBarcode(); // Initiate barcode scanning
  }

  // Method to scan barcode using the BarcodeScanner package
  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan(); // Open the barcode scanner
      if (!mounted) return;
      setState(() {
        barcode = result.rawContent.isNotEmpty
            ? result.rawContent
            : "Штрих-код не найден"; // If barcode found, use its content
        _isScanning = false;
        isLoadingProduct = true; // Show loading until product data is fetched
      });
      await _loadProduct(); // Load product details based on scanned barcode
    } catch (e) {
      if (!mounted) return;
      setState(() {
        barcode = "Ошибка при сканировании: $e"; // If error occurs
        _isScanning = false;
      });
    }
  }

  // Load product information by barcode
  Future<void> _loadProduct() async {
    var product = await productService.getProductByBarcode(barcode); // Get product details by barcode

    if (!mounted) return;

    setState(() {
      if (product != null) {
        productData = product.toMap(); // If product found, update productData
      } else {
        productData = null; // No product found
      }
      isLoadingProduct = false; // Stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isScanning || isLoadingProduct) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightGreen),
            ),
            const SizedBox(height: 20),
            Text(
              _isScanning
                  ? "Запускается сканер..." // Show scanning message
                  : "Загружается информация о продукте...", // Show loading message
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // If no product found, show "Not Found" message
    if (productData == null) {
      return _buildNoProductFound();
    }

    // If product found, display product details
    return _buildProductCard();
  }

  // Product info screen if product is found
  Widget _buildProductCard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Colors.green,
      ),
      body: Card(
        color: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                productData!['name'] ?? "Без названия",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Открываем подробную информацию о: $barcode")),
                  );
                },
                child: const Text("Подробнее"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: startScanning, // Restart scanning on button click
                child: const Text("Сканировать повторно"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoProductFound() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Продукт не найден",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: startScanning,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Сканировать повторно"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductFormPage(initialBarcode: barcode),
                  ),
                );
              },
              icon: const Icon(Icons.add_box),
              label: const Text("Добавить продукт"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
