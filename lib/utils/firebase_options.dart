import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCT7YNEJXY4-lCWHLXOA3CpNhw0GHwDjHk',
    appId: '1:237254482493:web:277a7000cc92ccd957e854',
    messagingSenderId: '237254482493',
    projectId: 'encuesta-emprendimiento-f4605',
    authDomain: 'encuesta-emprendimiento-f4605.firebaseapp.com',
    storageBucket: 'encuesta-emprendimiento-f4605.firebasestorage.app',
    measurementId: 'G-LVWPYQP3B2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQQOHxySm9RRHNkvz4khaW4jhMdLwYh1U',
    appId: '1:237254482493:android:9c933a33fcdd615557e854',
    messagingSenderId: '237254482493',
    projectId: 'encuesta-emprendimiento-f4605',
    storageBucket: 'encuesta-emprendimiento-f4605.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnvtGPIOcktyyn5csumG6gdHmD4yFkwts',
    appId: '1:237254482493:ios:2d9b0ba7e49ab67757e854',
    messagingSenderId: '237254482493',
    projectId: 'encuesta-emprendimiento-f4605',
    storageBucket: 'encuesta-emprendimiento-f4605.firebasestorage.app',
    iosBundleId: 'com.example.encuestaEmprendimientoCtc',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnvtGPIOcktyyn5csumG6gdHmD4yFkwts',
    appId: '1:237254482493:ios:2d9b0ba7e49ab67757e854',
    messagingSenderId: '237254482493',
    projectId: 'encuesta-emprendimiento-f4605',
    storageBucket: 'encuesta-emprendimiento-f4605.firebasestorage.app',
    iosBundleId: 'com.example.encuestaEmprendimientoCtc',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCT7YNEJXY4-lCWHLXOA3CpNhw0GHwDjHk',
    appId: '1:237254482493:web:6612210c34b5c10757e854',
    messagingSenderId: '237254482493',
    projectId: 'encuesta-emprendimiento-f4605',
    authDomain: 'encuesta-emprendimiento-f4605.firebaseapp.com',
    storageBucket: 'encuesta-emprendimiento-f4605.firebasestorage.app',
    measurementId: 'G-YFEZRWH321',
  );
}
