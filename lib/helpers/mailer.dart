import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'const.dart';

void mail(int phone, String chatId) async {
  final smtpServer = gmail(authUsername, authPassword);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
    ..from = Address(authUsername, appName)
    ..recipients.add(escalationEmail)
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    // ..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Support ESCALATED - EasySupport'
    ..text =
        'Support ESCALATED by user. Details as under:\nPhone number: $phone\nconversation id: $chatId';
  // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
