import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/conversation_state.dart';
import '../../chat_controller.dart';
import '../helpers/const.dart';
import '../helpers/mailer.dart';

class Escalate extends StatefulWidget {
  final String title;

  Escalate({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _EscalateState createState() => _EscalateState();
}

class _EscalateState extends State<Escalate> {
  var canEscalate = false;
  String conversationState;
  TextEditingController phoneController = TextEditingController();

  void delayEnablement() {
    Future.delayed(
      Duration(minutes: canEscalateAfter),
      () {
        setState(() {
          canEscalate = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    conversationState =
        Provider.of<ConversationState>(context).conversationState;
    if (!canEscalate) {
      if (conversationState == open) {
        delayEnablement();
      } else if (conversationState == resolved) {
        setState(() {
          canEscalate = true;
        });
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      elevation: 5.0,
      color: greyColor2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(escalationPrompt),
            ),
            ElevatedButton(
              onPressed: conversationState != escalated && canEscalate
                  ? manageEscalation
                  : null,
              child: Text('Escalate'),
            )
          ],
        ),
      ),
    );
  }

  void manageEscalation() async {
    int phone = await _displayEscalationDialog(context);
    if (phone.isNaN) {
      return;
    }
    mail(phone, ChatController.conversationId);
    ChatController.sendMessage(
      system,
      postEscalationMessage,
    );
    ChatController.conversationDoc.update({
      'state': escalated,
      'userContact': {
        'phone': phone,
      }
    });
  }

  Future<int> _displayEscalationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Support Escalation'),
          content: Wrap(
            children: [
              Text(escalationDialogMessage),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                    hintText: "Please enter your phone number."),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.red[300],
              textColor: Colors.white,
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              color: Colors.green[300],
              textColor: Colors.white,
              child: Text('SUBMIT'),
              onPressed: () {
                if (phoneController.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    int.parse(phoneController.text),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Phone number is missing! Can\'t submit.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
