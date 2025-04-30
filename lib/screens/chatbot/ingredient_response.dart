import 'package:HalalCheck/database/database_helper.dart';
import 'package:HalalCheck/database/models/ingredients.dart';

class IngredientResponse {
  static Future<String?> handle(String input) async {
    final dbHelper = DBHelper.instance;
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> rows = await db.query('ingredients');

    final ingredients = rows.map((row) => Ingredient.fromMap(row)).toList();

    // Debug list for visibility
    final debugList = "Ingredients found: " +
        ingredients.map((i) => i.eCode != null ? "${i.name} (${i.eCode})" : i.name).join(', ') +
        "\n\n";

    // Normalize e-codes like "E 120" or "e120" => "E120"
    final normalized = input.replaceAllMapped(
      RegExp(r'(e|E)[\s\-]*(\d{3,4})'),
          (match) => 'E${match[2]}',
    );

    final ecodeMatch = RegExp(r'(E\d{3,4})').firstMatch(normalized);
    final searchKey = ecodeMatch?.group(0)?.toUpperCase();

    // First: match by e-code
    if (searchKey != null) {
      final match = ingredients.where(
            (i) => i.eCode?.toUpperCase() == searchKey,
      ).toList();
      if (match.isNotEmpty) {
        return _buildResponse(match.first);
      }
      if (match.isNotEmpty) {
        return _buildResponse(match.first); // ✅ .first is an Ingredient
      }
    }

    // Second: match by name
    for (final i in ingredients) {
      if (input.toLowerCase().contains(i.name.toLowerCase())) {
        return _buildResponse(i);
      }
    }

    return null;
  }

  static String _buildResponse(Ingredient ing) {
    final status = ing.isHaram
        ? "haram"
        : ing.isDoubtful
        ? "doubtful"
        : "halal";

    final ecodePart = ing.eCode != null ? " (E-code: ${ing.eCode})" : "";
    final notePart = ing.notes?.isNotEmpty == true ? "\nNotes: ${ing.notes}" : "";

    return "${ing.name}$ecodePart is $status.$notePart";
  }
}

