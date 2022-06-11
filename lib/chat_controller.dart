import 'package:cloud_firestore/cloud_firestore.dart';
import './helpers/const.dart';

class ChatController {
  static QueryDocumentSnapshot<Map<String, dynamic>> doc;
  static DocumentReference<Map<String, dynamic>> conversationDoc;
  static String userType = user;
  static String conversationId;

  static void setUserType(String _userType) {
    userType = _userType;
  }

  static void setQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> qDocSnapshot) {
    doc = qDocSnapshot;
    conversationDoc = doc.reference;
  }

  // called for USER only
  static Future<bool> manageConversationInit(String message) async {
    // adds a new conversation record in DB, with state = 'open'
    conversationDoc = await addConversation();

    // With first message saving in DB, a sub-collection for messages is created.
    sendMessage(user, message);

    Future.delayed(
      Duration(seconds: 1),
      () {
        sendMessage(system, welcomeMessage);
      },
    );

    return true;
  }

  static Future<DocumentReference<Map<String, dynamic>>>
      addConversation() async {
    // This method is called only in the USER mode, and a user is characterised by a unique conversation-id
    conversationId = DateTime.now().millisecondsSinceEpoch.toString();
    // todo: why is .. operator not working as ..set()?
    var doc = FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId);
    doc.set(
      {
        'initTimestamp': conversationId,
        'state': open,
        'unread': true,
        'userContact': {
          'phone': null,
          'email': null,
        },
      },
    );
    return doc;
  }

  static Future<bool> sendMessage(String sender, String message) async {
    if (message.isEmpty) {
      return false;
    }
    if (conversationDoc == null) {
      return manageConversationInit(message);
    }
    conversationDoc.collection('messages').add({
      'sender': sender,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return false;
  }

  static void manageResolution() {
    sendMessage(system, resolveMessage);
    conversationDoc.update({
      'state': resolved,
    });
  }
}
