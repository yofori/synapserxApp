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
    apiKey: 'AIzaSyCfpEtQYgDc2iefyGxAjD7uoAd2GitIO30',
    appId: '1:727246042151:web:70493a00f239efa0758a02',
    messagingSenderId: '727246042151',
    projectId: 'synapserx-b05c7',
    authDomain: 'synapserx-b05c7.firebaseapp.com',
    storageBucket: 'synapserx-b05c7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCk_jcFvHC5V749hGm5zSLpyXFWBwUYto0',
    appId: '1:727246042151:android:ad66b00170c5be02758a02',
    messagingSenderId: '727246042151',
    projectId: 'synapserx-b05c7',
    storageBucket: 'synapserx-b05c7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyADf2iJcwX88vwU7UrhpvPSgLt5nsoUV70',
    appId: '1:727246042151:ios:ef6d6452ccb4a32b758a02',
    messagingSenderId: '727246042151',
    projectId: 'synapserx-b05c7',
    storageBucket: 'synapserx-b05c7.appspot.com',
    iosClientId: '727246042151-v2s8lalih67ttjiddsgtrrl57elfgade.apps.googleusercontent.com',
    iosBundleId: 'com.example.synapserxPrescriber',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyADf2iJcwX88vwU7UrhpvPSgLt5nsoUV70',
    appId: '1:727246042151:ios:ef6d6452ccb4a32b758a02',
    messagingSenderId: '727246042151',
    projectId: 'synapserx-b05c7',
    storageBucket: 'synapserx-b05c7.appspot.com',
    iosClientId: '727246042151-v2s8lalih67ttjiddsgtrrl57elfgade.apps.googleusercontent.com',
    iosBundleId: 'com.example.synapserxPrescriber',
  );
}