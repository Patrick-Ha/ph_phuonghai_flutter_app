// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBN2cstsyDfYMnOXkLtd6p5gpIxfTnDqv0',
    appId: '1:299555597092:web:10191929f1d06d1f26e1b1',
    messagingSenderId: '299555597092',
    projectId: 'greenlab-database',
    authDomain: 'greenlab-database.firebaseapp.com',
    databaseURL: 'https://greenlab-database-default-rtdb.firebaseio.com',
    storageBucket: 'greenlab-database.appspot.com',
    measurementId: 'G-E5TKTPSTGV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-0uwSkpEVJ4DkFu58dyMmJMQiPIP-Cq8',
    appId: '1:299555597092:android:96b0505e7b4cc0ce26e1b1',
    messagingSenderId: '299555597092',
    projectId: 'greenlab-database',
    databaseURL: 'https://greenlab-database-default-rtdb.firebaseio.com',
    storageBucket: 'greenlab-database.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFhfKuXiC2BP8XQCcXqRRrEcNC3KqyNQs',
    appId: '1:299555597092:ios:b8ddcb6ac7ab208b26e1b1',
    messagingSenderId: '299555597092',
    projectId: 'greenlab-database',
    databaseURL: 'https://greenlab-database-default-rtdb.firebaseio.com',
    storageBucket: 'greenlab-database.appspot.com',
    iosClientId: '299555597092-a4o6916utpci6a8keucosdabi8ffbrr7.apps.googleusercontent.com',
    iosBundleId: 'app.phuonghai',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFhfKuXiC2BP8XQCcXqRRrEcNC3KqyNQs',
    appId: '1:299555597092:ios:bffc398da7deb3b826e1b1',
    messagingSenderId: '299555597092',
    projectId: 'greenlab-database',
    databaseURL: 'https://greenlab-database-default-rtdb.firebaseio.com',
    storageBucket: 'greenlab-database.appspot.com',
    iosClientId: '299555597092-l6fnl7evdnl82it2viq5lnm6dc7en66k.apps.googleusercontent.com',
    iosBundleId: 'app.flutterPhuonghaiApp',
  );
}
