import 'package:flutter/material.dart';

import '../screens/channels_screen.dart';
import '../helpers/const.dart';

class LoginBtn extends StatefulWidget {
  final String title;

  LoginBtn({Key key, this.title}) : super(key: key);

  @override
  _LoginBtnState createState() => _LoginBtnState();
}

class _LoginBtnState extends State<LoginBtn> {
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(Object context) {
    return ElevatedButton(
      child: Text(
        '', // 'Agent Login',
        // Dirty solution: On client's request to hide the button from customers
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () {
        _displayPasswordDialog(context).then(
          (value) {
            if (value) {
              Navigator.popAndPushNamed(
                context,
                ChatChannelsScreen.route,
              );
            }
          },
        );
      },
    );
  }

  Future<bool> _displayPasswordDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Admin Login'),
          content: TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(hintText: "Please enter the password"),
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
              child: Text('OK'),
              onPressed: () {
                var success =
                    passwordController.text == password ? true : false;

                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid passowrd!'),
                    ),
                  );
                }
                Navigator.pop(context, success);
              },
            ),
          ],
        );
      },
    );
  }
}
