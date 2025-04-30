// File: services/bot_response_handler.dart
import 'product_response.dart';
import 'ingredient_response.dart';
import 'default_intents.dart';

class BotResponseHandler {
  static Future<String> getBotReply(String userInput) async {
    final defaultReply = DefaultIntents.getResponse(userInput);
    final productReply = await ProductResponse.handle(userInput);
    final ingredientReply = await IngredientResponse.handle(userInput);

    // Priority order
    if (defaultReply != null) return defaultReply;
    if (productReply != null) return productReply;
    if (ingredientReply != null) return ingredientReply;

    // Fallback if none matched
    return "🤔 I couldn’t find anything about that.\n"
        "Try asking about a product like \"Twix\" or an ingredient like \"E120\".";
  }

}