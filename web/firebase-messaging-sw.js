importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js");

firebase.initializeApp({
  // apiKey: "...",
  // authDomain: "...",
  // databaseURL: "...",
  // projectId: "...",
  // storageBucket: "...",
  // messagingSenderId: "...",
  // appId: "...",

  apiKey: "AIzaSyBu1o5k4Cm0GZ66lJK2AshI_ToawUfMYyA",
  authDomain: "easysupport-1ee76.firebaseapp.com",
  databaseURL: "https://easysupport-1ee76.firebaseio.com",
  projectId: "easysupport-1ee76",
  storageBucket: "easysupport-1ee76.appspot.com",
  messagingSenderId: "134456124075",
  appId: "1:134456124075:web:4ef0b8109c2c08cadd0dee",
  // measurementId: "G-LN7K4JJJJK"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});