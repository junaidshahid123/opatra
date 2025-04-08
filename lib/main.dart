import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:opatra/UI/Splash%20Screen.dart';
import 'package:opatra/UI/home/bag/bag_controller.dart';

import 'constant/AppColors.dart';
import 'fcm_handle.dart';
import 'firebase_options.dart';

String? fcmToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
      );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  HttpOverrides.global = MyHttpOverrides();
  Get.put(BagController());
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _messagingService = MessagingService();
  RemoteMessage? _initialMessage;
  bool _isSplashDone = false;

  @override
  void initState() {
    // TODO: implement initState
    _messagingService.init(context);
    super.initState();
    _setupInteractedMessage();
  }

  void _handleMessage(RemoteMessage message) {
    // Navigate to the desired screen with the message data
    if (message.notification?.title == 'New Message') {
      // Get.to(() => ChatPage(message: message));
    } else if (message.notification?.title == 'Accept Offer') {}
  }

  void _setupInteractedMessage() async {
    // Get the initial message
    _initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the initial message is not null, it means the app was opened via a notification
    if (_initialMessage != null) {
      _navigateToInitialRoute();
    }

    // Handle interaction when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });
  }
  void _navigateToInitialRoute() {
    if (_isSplashDone && _initialMessage != null) {
      _handleMessage(_initialMessage!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return GetMaterialApp(
          useInheritedMediaQuery: true,
          title: 'Opatra',
          color: AppColors.appPrimaryColor,
          darkTheme: ThemeData(
            fontFamily: 'Graphik',
            brightness: Brightness.dark,
            primaryColor: AppColors.appPrimaryColor,
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Graphik',
            brightness: Brightness.light,
            useMaterial3: true,
          ),
          home: SplashScreen());
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
