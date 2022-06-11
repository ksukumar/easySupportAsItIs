import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './providers/conversation_state.dart';
import './screens/channels_screen.dart';
import './screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ConversationState(),
      child: MaterialApp(
        title: 'Easy Support App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ChatScreen(title: 'Easy Support'),
        routes: {
          ChatChannelsScreen.route: (context) => ChatChannelsScreen(),
          ChatScreen.route: (context) => ChatScreen(),
        },
      ),
    );
  }
}
