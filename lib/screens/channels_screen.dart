import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../chat_controller.dart';
import '../helpers/screen_arguments.dart';
import '../helpers/const.dart';
import './chat_screen.dart';

class ChatChannelsScreen extends StatefulWidget {
  static final route = '/channels';
  @override
  _ChatChannelsScreenState createState() => _ChatChannelsScreenState();
}

class _ChatChannelsScreenState extends State<ChatChannelsScreen> {
  @override
  void initState() {
    ChatController.setUserType(agent);
    setNotifications();
    super.initState();
  }

  Future<void> setNotifications() async {
    final fbm = FirebaseMessaging.instance;

    String token = await fbm.getToken(
      vapidKey:
          "BKZVQn_Rd1XT40sMN-dDAcYaCPS-qrfQZWdWLRokpKEkCAVAS8ksZpOID__Vrgb5Z4-BF7uC1Ye6sWn5kxnWtTo",
    );
    if (kIsWeb) {
      FirebaseFirestore.instance
          .collection('users')
          .doc('agent')
          .update({'token': token});
    }

    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      updateForegroundNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      /* 
      todo:
      A Stream event will be sent if the app has opened from a 
      background state (not terminated).

      If your app is opened via a notification whilst the app 
      is terminated, see [getInitialMessage].
      */
    });
    if (kIsWeb) {
    } else {
      if (Platform.isAndroid) {
        fbm.subscribeToTopic('support');
      } else if (Platform.isIOS) {
        //iOS
      }
    }
  }

  void updateForegroundNotification(RemoteMessage message) {
    String channelId = message.data['channel'];
    String eventName = message.data['event'];

    if (eventName == 'new-channel') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: Colors.amber[300],
          content: Text('New Incoming Chat'),
        ),
      );
    } else if (eventName == 'new-message' &&
        ChatController.conversationId != channelId) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green[300],
          content: Text('A new chat in channel - $channelId'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Active Conversations'),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('conversations')
              .where('state', whereIn: [
            open,
            progressing,
          ]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  var doc = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      ChatController.setQueryDocumentSnapshot(doc);
                      ChatController.conversationId = doc['initTimestamp'];
                      Navigator.pushNamed(
                        context,
                        ChatScreen.route,
                        arguments: ScreenArguments(
                          doc['initTimestamp'],
                          agent,
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${doc['initTimestamp']}"),
                        trailing: doc['state'] == open
                            ? Text('New')
                            : doc['unread'] == true
                                ? Text('Unread')
                                : null,
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.docs.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
