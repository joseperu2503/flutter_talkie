// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBQRZHRASzPRpb9VGGhbmOwxJGg07ECXhA',
    appId: '1:1071103158051:web:9e9b65331ffef468c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    authDomain: 'talkie-e43eb.firebaseapp.com',
    storageBucket: 'talkie-e43eb.appspot.com',
    measurementId: 'G-YCRKEY3JE6',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvbyQI0l6XEHpwgfYEqGbqOFd_5EhDO-U',
    appId: '1:1071103158051:android:718a084ef6d271b4c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    storageBucket: 'talkie-e43eb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAP8dWhWf_MajdRejVEBXivjC6Q3VskHuA',
    appId: '1:1071103158051:ios:5aecb1031f568381c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    storageBucket: 'talkie-e43eb.appspot.com',
    iosBundleId: 'com.joseperezgil.talkie',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAP8dWhWf_MajdRejVEBXivjC6Q3VskHuA',
    appId: '1:1071103158051:ios:5aecb1031f568381c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    storageBucket: 'talkie-e43eb.appspot.com',
    iosBundleId: 'com.joseperezgil.talkie',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBQRZHRASzPRpb9VGGhbmOwxJGg07ECXhA',
    appId: '1:1071103158051:web:9a3f17d6dbe07789c64e96',
    messagingSenderId: '1071103158051',
    projectId: 'talkie-e43eb',
    authDomain: 'talkie-e43eb.firebaseapp.com',
    storageBucket: 'talkie-e43eb.appspot.com',
    measurementId: 'G-R7XFD3T8GC',
  );
}
