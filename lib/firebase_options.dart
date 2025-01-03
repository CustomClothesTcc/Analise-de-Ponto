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
    apiKey: 'AIzaSyA7vBIggq9sT1fMyrP03xiSxo6kEEYPDAs',
    appId: '1:44978919721:web:c2b3570abbfd948140ff38',
    messagingSenderId: '44978919721',
    projectId: 'acesso-inteligente-fe5e5',
    authDomain: 'acesso-inteligente-fe5e5.firebaseapp.com',
    storageBucket: 'acesso-inteligente-fe5e5.firebasestorage.app',
    measurementId: 'G-6491BGMMYY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsGQ6Kym5jYP8vI_paHQ0qIxsEBPKRYUA',
    appId: '1:44978919721:android:8c6ff6476167eae240ff38',
    messagingSenderId: '44978919721',
    projectId: 'acesso-inteligente-fe5e5',
    storageBucket: 'acesso-inteligente-fe5e5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRAZJ7a_ye5hXqcykaPSB_7YJMz8jOYxQ',
    appId: '1:44978919721:ios:168cfefdd6bedbab40ff38',
    messagingSenderId: '44978919721',
    projectId: 'acesso-inteligente-fe5e5',
    storageBucket: 'acesso-inteligente-fe5e5.firebasestorage.app',
    iosBundleId: 'com.example.ponto',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBRAZJ7a_ye5hXqcykaPSB_7YJMz8jOYxQ',
    appId: '1:44978919721:ios:168cfefdd6bedbab40ff38',
    messagingSenderId: '44978919721',
    projectId: 'acesso-inteligente-fe5e5',
    storageBucket: 'acesso-inteligente-fe5e5.firebasestorage.app',
    iosBundleId: 'com.example.ponto',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA7vBIggq9sT1fMyrP03xiSxo6kEEYPDAs',
    appId: '1:44978919721:web:0cf35692b7be376d40ff38',
    messagingSenderId: '44978919721',
    projectId: 'acesso-inteligente-fe5e5',
    authDomain: 'acesso-inteligente-fe5e5.firebaseapp.com',
    storageBucket: 'acesso-inteligente-fe5e5.firebasestorage.app',
    measurementId: 'G-YB6TB4ZSSW',
  );
}
