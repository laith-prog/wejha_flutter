import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAy2z-Irqrih_TQeztXC7QRDS_PPhE48RY',
    appId: '1:1084752019943:web:53d4c921f5337360a1fd42',
    messagingSenderId: '1084752019943',
    projectId: 'wejha-39be4',
    authDomain: 'wejha-39be4.firebaseapp.com',
    storageBucket: 'wejha-39be4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAy2z-Irqrih_TQeztXC7QRDS_PPhE48RY',
    appId: '1:1084752019943:android:53d4c921f5337360a1fd42',
    messagingSenderId: '1084752019943',
    projectId: 'wejha-39be4',
    authDomain: 'wejha-39be4.firebaseapp.com',
    storageBucket: 'wejha-39be4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAy2z-Irqrih_TQeztXC7QRDS_PPhE48RY',
    appId: '1:1084752019943:ios:53d4c921f5337360a1fd42',
    messagingSenderId: '1084752019943',
    projectId: 'wejha-39be4',
    storageBucket: 'wejha-39be4.firebasestorage.app',
    iosBundleId: 'com.example.wejha',
  );
} 