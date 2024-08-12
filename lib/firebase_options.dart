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
    apiKey: 'AIzaSyBkmSfSDakOnc7FR2OwHw4XR_LhuRq-iI0',
    appId: '1:162072875609:web:83a7468c4edf57b9d69748',
    messagingSenderId: '162072875609',
    projectId: 'flutterfirebasechatapp-c9f46',
    authDomain: 'flutterfirebasechatapp-c9f46.firebaseapp.com',
    storageBucket: 'flutterfirebasechatapp-c9f46.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDEdGrUj9Z6CIPM2TRJKkc0iZ0FSlaeOqI',
    appId: '1:162072875609:android:a59e12ae98570fefd69748',
    messagingSenderId: '162072875609',
    projectId: 'flutterfirebasechatapp-c9f46',
    storageBucket: 'flutterfirebasechatapp-c9f46.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAW9pcTJw5Amf9-sTNLcFCu2hhP9NKVyZw',
    appId: '1:162072875609:ios:b1c95201791af69bd69748',
    messagingSenderId: '162072875609',
    projectId: 'flutterfirebasechatapp-c9f46',
    storageBucket: 'flutterfirebasechatapp-c9f46.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAW9pcTJw5Amf9-sTNLcFCu2hhP9NKVyZw',
    appId: '1:162072875609:ios:b1c95201791af69bd69748',
    messagingSenderId: '162072875609',
    projectId: 'flutterfirebasechatapp-c9f46',
    storageBucket: 'flutterfirebasechatapp-c9f46.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBkmSfSDakOnc7FR2OwHw4XR_LhuRq-iI0',
    appId: '1:162072875609:web:a76d2d5f4da66395d69748',
    messagingSenderId: '162072875609',
    projectId: 'flutterfirebasechatapp-c9f46',
    authDomain: 'flutterfirebasechatapp-c9f46.firebaseapp.com',
    storageBucket: 'flutterfirebasechatapp-c9f46.appspot.com',
  );
}
