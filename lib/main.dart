import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:opatra/UI/Splash%20Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/home/bag/bag_controller.dart';
import 'constant/AppColors.dart';
import 'fcm_handle.dart';
import 'firebase_options.dart';

String? fcmToken;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission();
  Get.put(BagController());
  // await dotenv.load(fileName: ".env"); // Make sure the file name is correct
  // Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  // Stripe.instance.applySettings();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
