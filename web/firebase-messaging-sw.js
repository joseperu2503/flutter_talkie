importScripts(
  "https://www.gstatic.com/firebasejs/10.13.1/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.13.1/firebase-messaging-compat.js"
);

firebase.initializeApp({
    apiKey: 'AIzaSyBQRZHRASzPRpb9VGGhbmOwxJGg07ECXhA',
    appId: '1:1071103158051:web:9e9b65331ffef468c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    authDomain: 'talkie-e43eb.firebaseapp.com',
    storageBucket: 'talkie-e43eb.appspot.com',
    measurementId: 'G-YCRKEY3JE6',
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
