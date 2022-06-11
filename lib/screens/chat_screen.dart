import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/conversation_state.dart';
import '../chat_controller.dart';
import '../helpers/const.dart';
import '../helpers/screen_arguments.dart';
import '../widgets/login.dart';
import '../widgets/resolve.dart';
import '../widgets/chat.dart';
import '../widgets/escalate.dart';
import '../widgets/post.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  static final route = '/agent-chat';

  ChatScreen({Key key, this.title}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String title;
  String userType;
  String conversationState = 'none';

  @override
  void initState() {
    title = widget.title;
    userType = ChatController.userType;
    if (userType == agent) {
      listenStateChange();
    }
    super.initState();
  }

  void listenStateChange() {
    ChatController.conversationDoc.snapshots().listen((documentSnapshot) {
      String state = documentSnapshot.data()['state'];
      if (state.isNotEmpty) {
        Provider.of<ConversationState>(context, listen: false)
            .updateConversationState(state);
      } else {
        // no state ... in USER mode, conversation is yet to start from USER
      }
    });
  }

  @override
  void dispose() {
    ChatController.conversationId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      var args = ModalRoute.of(context).settings.arguments as ScreenArguments;
      title = args.title;
      userType = args.userType;
    }
    conversationState =
        Provider.of<ConversationState>(context).conversationState;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            if (userType == agent) ResolveBtn(userType),
            if (userType == user) LoginBtn(),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chat(
              userType,
            ),
            Column(
              children: [
                Divider(
                  thickness: 1.0,
                ),
                if (userType == user) Escalate(),
                Post(
                  userType,
                ),
                Container(
                  color: greyColor2,
                  height: 10,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
