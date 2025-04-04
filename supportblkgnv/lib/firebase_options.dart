// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:supportblkgnv/environment.dart';

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

  // Added web configuration using the same values as Android for development
  static FirebaseOptions web = FirebaseOptions(
    apiKey: Environment.firebaseApiKeyAndroid,
    appId: Environment.firebaseAppIdAndroid,
    messagingSenderId: Environment.firebaseMessagingSenderId,
    projectId: Environment.firebaseProjectId,
    storageBucket: Environment.firebaseStorageBucket,
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: Environment.firebaseApiKeyAndroid,
    appId: Environment.firebaseAppIdAndroid,
    messagingSenderId: Environment.firebaseMessagingSenderId,
    projectId: Environment.firebaseProjectId,
    storageBucket: Environment.firebaseStorageBucket,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: Environment.firebaseApiKeyIos,
    appId: Environment.firebaseAppIdIos,
    messagingSenderId: Environment.firebaseMessagingSenderId,
    projectId: Environment.firebaseProjectId,
    storageBucket: Environment.firebaseStorageBucket,
    iosBundleId: Environment.firebaseIosBundleId,
  );
}
