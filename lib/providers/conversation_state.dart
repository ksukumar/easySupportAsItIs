import 'package:flutter/material.dart';

class ConversationState with ChangeNotifier {
  var conversationState = 'none';

  updateConversationState(String state) {
    conversationState = state;
    notifyListeners();
  }
}
