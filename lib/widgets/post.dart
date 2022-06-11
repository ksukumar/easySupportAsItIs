import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/conversation_state.dart';
import '../chat_controller.dart';
import '../helpers/const.dart';

class Post extends StatefulWidget {
  final String title;
  final String sender;

  Post(this.sender, {Key key, this.title}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  ConversationState stateData;
  var canListen = false;
  var initText = false;
  String conversationState;
  TextEditingController messageController = TextEditingController();
  FocusNode focusNode = FocusNode();

  void listenStateChange() {
    ChatController.conversationDoc.snapshots().listen((documentSnapshot) {
      stateData = Provider.of<ConversationState>(context, listen: false);
      String newState = documentSnapshot.data()['state'];
      String oldState = stateData.conversationState;
      if (newState.isNotEmpty && oldState != newState) {
        stateData.updateConversationState(newState);
      } else {
        // no state ... in USER mode, conversation is yet to start from USER
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();

    if (ChatController.userType == agent &&
        ChatController.conversationDoc != null) {
      ChatController.conversationDoc.update(
        {
          'unread': false,
        },
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (canListen) {
      listenStateChange();
    }
    conversationState =
        Provider.of<ConversationState>(context).conversationState;

    if (ChatController.userType == agent) {
      ChatController.conversationDoc.update(
        {
          'unread': false,
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              autofocus: true,
              focusNode: focusNode,
              onSubmitted: (value) {
                if (conversationState != escalated &&
                    conversationState != resolved) {
                  processSend();
                }
              },
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          ElevatedButton(
            onPressed:
                conversationState != escalated && conversationState != resolved
                    ? processSend
                    : null,
            child: Text('Send'),
          ),
        ],
      ),
    );
  }

  void processSend() async {
    if (messageController.text.isNotEmpty) {
      await ChatController.sendMessage(
        widget.sender,
        messageController.text,
      );
      messageController.clear();

      if (widget.sender == user && !canListen) {
        setState(
          () {
            canListen = true;
          },
        );
      }
      if (conversationState == open && ChatController.userType == agent) {
        ChatController.conversationDoc.update(
          {
            'state': progressing,
          },
        );
      }
      if (ChatController.userType == user) {
        ChatController.conversationDoc.update(
          {
            'unread': true,
          },
        );
      }
    }
    focusNode.requestFocus();
  }
}
