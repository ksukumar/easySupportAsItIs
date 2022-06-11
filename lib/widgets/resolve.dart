import 'package:flutter/material.dart';
import 'package:easy_support/providers/conversation_state.dart';
import 'package:provider/provider.dart';

import '../helpers/const.dart';
import '../chat_controller.dart';

class ResolveBtn extends StatefulWidget {
  final String title;
  final String sender;

  ResolveBtn(this.sender, {Key key, this.title}) : super(key: key);

  @override
  _ResolveBtnState createState() => _ResolveBtnState();
}

class _ResolveBtnState extends State<ResolveBtn> {
  String conversationState;

  @override
  Widget build(BuildContext context) {
    conversationState =
        Provider.of<ConversationState>(context).conversationState;

    return ElevatedButton(
      child: Text('Resolve'),
      onPressed: conversationState == open || conversationState == progressing
          ? ChatController.manageResolution
          : null,
    );
  }
}
