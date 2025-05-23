
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
apiKey: 'AIzaSyBb13tFimDxXht9AH_Gqs6ArHJ5twTEmUA',
appId: '1:1024991048436:web:7a5e0772c3c682c8b3e4a1',
messagingSenderId: '1024991048436',
projectId: 'opatra-d5bda',
authDomain: 'opatra-d5bda.firebaseapp.com',
storageBucket: 'opatra-d5bda.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
apiKey: 'AIzaSyBRp6SJsLxDzWy9UBsz9EwdDvF_QPkBhvw',
appId: '1:1024991048436:android:98dedcc7fbfead73b3e4a1',
messagingSenderId: '1024991048436',
projectId: 'opatra-d5bda',
storageBucket: 'opatra-d5bda.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
apiKey: 'AIzaSyDNqAoG-KOOh7q3EOzQi5zmhSaCTI2OUZg',
appId: '1:1024991048436:ios:26bb9c055d67cdd3b3e4a1',
messagingSenderId: '1024991048436',
projectId: 'opatra-d5bda',
storageBucket: 'opatra-d5bda.appspot.com',
iosBundleId: 'com.ontechinc.opatralondon',
);

static const FirebaseOptions macos = FirebaseOptions(
apiKey: 'AIzaSyDNqAoG-KOOh7q3EOzQi5zmhSaCTI2OUZg',
appId: '1:1024991048436:ios:26bb9c055d67cdd3b3e4a1',
messagingSenderId: '1024991048436',
projectId: 'opatra-d5bda',
storageBucket: 'opatra-d5bda.appspot.com',
iosBundleId: 'com.ontechinc.opatralondon',
);

static const FirebaseOptions windows = FirebaseOptions(
apiKey: 'AIzaSyBb13tFimDxXht9AH_Gqs6ArHJ5twTEmUA',
appId: '1:1024991048436:web:0d4a7c6c0b4d1dacb3e4a1',
messagingSenderId: '1024991048436',
projectId: 'opatra-d5bda',
authDomain: 'opatra-d5bda.firebaseapp.com',
storageBucket: 'opatra-d5bda.appspot.com',
);
}