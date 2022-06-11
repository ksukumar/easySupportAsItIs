const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
var db = admin.firestore();

exports.chatUpdateByTopic = functions.firestore
    .document("conversations/{conversation}/messages/{message}")
    .onCreate((snapshot, context) => {
      const text = snapshot.data().text;
      const sender = snapshot.data().sender;
      const channel = context.params.conversation;
      if ( sender == "system" || sender == "agent" ) {
        return;
      }
      return admin.messaging().sendToTopic("support", {
        notification: {
          title: "Chat Update",
          body: "Message: " + text + ",\nChannel: " + channel,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {"channel": channel, "event": "new-message"},
      });
    });

exports.newChatByTopic = functions.firestore
    .document("conversations/{conversation}")
    .onCreate((snapshot, context) => {
      const channel = context.params.conversation;
      return admin.messaging().sendToTopic("support", {
        notification: {
          title: "New Chat",
          body: "Chat id: " + channel,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {"channel": channel, "event": "new-channel"},
      });
    });


exports.chatUpdateByToken = functions.firestore
    .document("conversations/{conversation}/messages/{message}")
    .onCreate(async (snapshot, context) => {
      const text = snapshot.data().text;
      const sender = snapshot.data().sender;
      const channel = context.params.conversation;
      if ( sender == "system" || sender == "agent" ) {
        return;
      }

      const agentData = await db.collection("users").doc("agent").get();
      const token = agentData.data().token;
      console.log("--------- " + token);

      const payload = {
        notification: {
          title: "Chat Update",
          body: "Message: " + text + ",\nChannel: " + channel,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          "channel": channel,
          "event": "new-message"
        },
      }
      return admin.messaging().sendToDevice(token, payload);
    });

exports.newChatByToken = functions.firestore
    .document("conversations/{conversation}")
    .onCreate(async (snapshot, context) => {
      const channel = context.params.conversation;

      const agentData = await db.collection("users").doc("agent").get();
      const token = agentData.data().token;
      console.log("======== " + token);

      const payload = {
        notification: {
          title: "New Chat",
          body: "Chat id: " + channel,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {"channel": channel, "event": "new-channel"},
      };
      return admin.messaging().sendToDevice(token, payload);
    });
