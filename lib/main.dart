import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:opatra/UI/Splash%20Screen.dart';
import 'package:opatra/UI/home/bag/bag_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant/AppColors.dart';
import 'fcm_handle.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String? fcmToken;

class StripeKeysResponse {
  final bool status;
  final StripeKeysData data;

  StripeKeysResponse({
    required this.status,
    required this.data,
  });

  factory StripeKeysResponse.fromJson(Map<String, dynamic> json) {
    return StripeKeysResponse(
      status: json['status'],
      data: StripeKeysData.fromJson(json['data']),
    );
  }
}

class StripeKeysData {
  final String? testSecretKey;
  final String? testClientKey;
  final String? liveSecretKey;
  final String? liveClientKey;

  StripeKeysData({
    this.testSecretKey,
    this.testClientKey,
    this.liveSecretKey,
    this.liveClientKey,
  });

  factory StripeKeysData.fromJson(Map<String, dynamic> json) {
    return StripeKeysData(
      testSecretKey: json['test_secret_key'],
      testClientKey: json['test_client_key'],
      liveSecretKey: json['live_secret_key'],
      liveClientKey: json['live_client_key'],
    );
  }
}

Future<StripeKeysResponse> fetchStripeKeys() async {
  try {
    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No authentication token found');
    }

    // Set up headers with authorization
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await http.get(
      Uri.parse('https://opatra.app/api/get-stripe-keys'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return StripeKeysResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized - Invalid or expired token');
    } else {
      throw Exception(
          'Failed to load Stripe keys from API. Status code: ${response.statusCode}');
    }
  } catch (e) {
    // Log the error and rethrow
    print('Error fetching Stripe keys: $e');
    rethrow;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
  await Firebase.initializeApp();

  String? stripePublishableKey;
  String? stripeSecretKey;
  String stripeKeySource = '';

  try {
    // Try to get keys from API first
    final stripeKeysResponse = await fetchStripeKeys();

    if (stripeKeysResponse.status) {
      final keys = stripeKeysResponse.data;

      if (keys.liveClientKey != null && keys.liveClientKey!.isNotEmpty) {
        stripePublishableKey = keys.liveClientKey;
        stripeKeySource = 'API (live_client_key)';
      }

      if (keys.liveSecretKey != null && keys.liveSecretKey!.isNotEmpty) {
        stripeSecretKey = keys.liveSecretKey;
      }
    }
  } catch (e) {
    print('⚠️ Warning: Failed to fetch Stripe keys from API: $e');
  }

  // Fallback to .env if API didn't provide the keys
  if (stripePublishableKey == null || stripePublishableKey.isEmpty) {
    stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    stripeKeySource = '.env file (STRIPE_PUBLISHABLE_KEY)';
  }

  if (stripeSecretKey == null || stripeSecretKey.isEmpty) {
    stripeSecretKey = dotenv.env['STRIPE_SECRET_KEY'];
  }

  if (stripePublishableKey == null || stripePublishableKey.isEmpty) {
    print(
        '⚠️ Warning: Stripe publishable key not found in either API or .env file!');
  } else {
    Stripe.publishableKey = stripePublishableKey;
    Stripe.merchantIdentifier = 'merchant.flutter.stripe';
    await Stripe.instance.applySettings();
    print('✅ Stripe initialized with publishable key from $stripeKeySource');
  }

  if (stripeSecretKey == null || stripeSecretKey.isEmpty) {
    print(
        '⚠️ Warning: Stripe secret key not found in either API or .env file!');
  } else {
    print(
        '✅ Stripe secret key available from ${stripeKeySource.contains('API') ? 'API' : '.env file'}');
  }

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
