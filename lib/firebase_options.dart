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
    apiKey: 'AIzaSyB2lwcsFCVKihHP1IyXjv9C9lvlIu5but0',
    appId: '1:647662616927:web:44e23991e285710bd436ea',
    messagingSenderId: '647662616927',
    projectId: 'food-recipe-a2ddb',
    authDomain: 'food-recipe-a2ddb.firebaseapp.com',
    storageBucket: 'food-recipe-a2ddb.appspot.com',
    measurementId: 'G-L865EJH7QE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwhBwtPNYGtT5f1Flff2FOSPA8DSvf1I4',
    appId: '1:647662616927:android:6b8e92d15f9b3eb9d436ea',
    messagingSenderId: '647662616927',
    projectId: 'food-recipe-a2ddb',
    storageBucket: 'food-recipe-a2ddb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCWxNIu4LQkN-6qWhlgbBRbaj9yyBb8jrM',
    appId: '1:647662616927:ios:8d5ccb4e80d48ecdd436ea',
    messagingSenderId: '647662616927',
    projectId: 'food-recipe-a2ddb',
    storageBucket: 'food-recipe-a2ddb.appspot.com',
    iosBundleId: 'com.example.recipeFood',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCWxNIu4LQkN-6qWhlgbBRbaj9yyBb8jrM',
    appId: '1:647662616927:ios:8d5ccb4e80d48ecdd436ea',
    messagingSenderId: '647662616927',
    projectId: 'food-recipe-a2ddb',
    storageBucket: 'food-recipe-a2ddb.appspot.com',
    iosBundleId: 'com.example.recipeFood',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB2lwcsFCVKihHP1IyXjv9C9lvlIu5but0',
    appId: '1:647662616927:web:4101e9603dd68934d436ea',
    messagingSenderId: '647662616927',
    projectId: 'food-recipe-a2ddb',
    authDomain: 'food-recipe-a2ddb.firebaseapp.com',
    storageBucket: 'food-recipe-a2ddb.appspot.com',
    measurementId: 'G-Z7Q0ST2YR3',
  );

}