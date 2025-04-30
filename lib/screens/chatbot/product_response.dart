// File: services/product_response.dart
import 'package:HalalCheck/database/models/products.dart';
import 'package:HalalCheck/database/database_helper.dart';

class ProductResponse {
  static Future<String?> handle(String input) async {
    final dbHelper = DBHelper.instance;
    final productService = ProductService();
    final List<Product> allProducts = await productService.getProducts();
    final productNames = allProducts.map((p) => p.name).toList();
    String debugList = "Products found: ${productNames.join(', ')}\n\n";

    // Try to find a matching product in the query
    for (final product in allProducts) {
      if (input.toLowerCase().contains(product.name.toLowerCase())) {
        final status = await productService.getHalalStatus(product.id!);
        final filling = product.filling ?? 'no specific ingredients listed';

        if (status == 'halal') {
          return "${product.name} is halal.";
        } else if (status == 'haram') {
          return "${product.name} is haram because it contains $filling.";
        } else if (status == 'doubtful') {
          return "${product.name} is suspicious because it contains $filling.";
        } else {
          return "I found ${product.name}, but couldn't determine its halal status.";
        }
      }
    }

    return null; // No product match found
  }
}