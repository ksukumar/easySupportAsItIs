import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat_controller.dart';
import '../helpers/const.dart';

class Chat extends StatefulWidget {
  final String title;
  final String userType;

  Chat(
    this.userType, {
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ChatController.conversationDoc == null
          ? Container()
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatController.conversationDoc
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) {
                      return buildMessageItem(index, snapshot.data.docs[index]);
                    },
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
    );
  }

  Widget buildMessageItem(
      int index, DocumentSnapshot<Map<String, dynamic>> document) {
    var screenWidth = MediaQuery.of(context).size.width;
    if (document.data()['sender'] == widget.userType) {
      // Right (device user's message)
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: screenWidth * 0.2,
            ),
            Container(
              child: Text(
                document.data()['text'],
                textWidthBasis: TextWidthBasis.longestLine,
                style: TextStyle(
                  color: primaryColor,
                ),
                textAlign: TextAlign.end,
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              constraints: BoxConstraints.loose(Size(
                screenWidth * 0.7,
                double.maxFinite,
              )),
              decoration: BoxDecoration(
                color: greyColor2,
                borderRadius: BorderRadius.circular(8.0),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      );
    } else if (document.data()['sender'] == system) {
      // Middle (system generated message)
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Center(
          child: Container(
            child: Text(
              document.data()['text'],
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      );
    } else {
      // Left (peer message)
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              child: Text(
                document.data()['text'],
                textWidthBasis: TextWidthBasis.longestLine,
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              constraints: BoxConstraints.loose(Size(
                screenWidth * 0.7,
                double.maxFinite,
              )),
              decoration: BoxDecoration(
                color: greyColor3,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.2,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      );
    }
  }
}
