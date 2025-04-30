class DefaultIntents {
  static final Map<String, String> _intents = {
    'hi': 'Hello! 👋 How can I assist you today?',
    'hello': 'Hi there! Ask me about a product or ingredient.',
    'hey': 'Hey! I’m here to help you check halal status.',
    'how are you': 'I’m just a bot, but I’m functioning perfectly 😊',
    'what can you do': 'I can help you check if a product or ingredient is halal, haram, or doubtful.',
    'help': 'You can ask things like:\n- Is Coca-Cola halal?\n- Is E120 allowed?\n- What about gelatin?'
  };

  static String? getResponse(String input) {
    final cleaned = input.toLowerCase().trim();

    for (final key in _intents.keys) {
      if (cleaned.contains(key)) {
        return _intents[key];
      }
    }

    return null;
  }
}
