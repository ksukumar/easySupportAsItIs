import 'dart:ui';

// todo: temporary constants
final testingMode = false;
final password = 'app2test';

final authUsername = 'eazzup1309@gmail.com';
final authPassword = 'KrishnaMohan';
// ---------------------------------- //
final appName = 'EasySupport';

final themeColor = Color(0xfff5a623);
final primaryColor = Color(0xff203152);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);
final greyColor3 = Color(0x77203152);
final welcomeMessage =
    'Welcome to EasySupport! Our customer care representative will attend you soon.';
final escalationPrompt = 'Not satisfied with this support?';
final postEscalationMessage =
    'This support is marked as ESCALATED by user/customer.';
final escalationDialogMessage =
    'Your support request is being escalated! Please provide your phone number to let us get back to you.';
final escalationEmail = 'eazzup1309@gmail.com';
final resolveMessage =
    'This support is marked as RESOLVED by support representative.';

final canEscalateAfter = testingMode ? 1 : 2; // in minutes

// ---------------- Don't change ------------------ //
// User types
const agent = 'agent';
const user = 'user';
const system = 'system';
// State types of conversations
const open = 'open';
const progressing = 'progressing';
const escalated = 'escalated';
const resolved = 'resolved';
