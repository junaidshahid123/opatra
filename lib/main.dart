import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // getFCMToken();
  await initNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission();
  Get.put(BagController());

  runApp(const MyApp());
}

final _firebaseMessaging = FirebaseMessaging.instance;

Future<void> initNotifications() async {
  await _firebaseMessaging.requestPermission();
  fcmToken = await _firebaseMessaging.getToken();
  print('fcmToken>>>>>>>>>>>>>>>>>>>>>>>${fcmToken}<<<<<<<<<<<<<<<<<<<<<<<<<');
}

Future<String?> getFCMToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission to receive notifications
  await messaging.requestPermission();

  // Get the token
  String? token = await messaging.getToken();
  fcmToken = token;
  print('fcmToken==${fcmToken}');
  return token;
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
    _messagingService.init(context);
    super.initState();
    _setupInteractedMessage();
    WidgetsBinding.instance
        .addObserver(this); // Add observer for lifecycle changes
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

  Future<void> _handleMessage(RemoteMessage message) async {
    // Navigate to the desired screen with the message data
    if (message.notification?.title == 'New request') {
      // Get.to(() => FindTripOnline(message: message));
    } else if (message.notification?.title == 'Accept Offer') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('acceptOffer', true);
      await prefs.setString('isStart', '1');
      await prefs.setString('isEnd', '0');
      // Get.offAll(() => DriverRequestNotificationScreen(message: message));
    } else if (message.notification?.title == 'New Message') {
      // Get.to(() => ChatPage(message: message));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer to prevent memory leaks
    super.dispose();
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
