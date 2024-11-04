import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token
  static final MessagingService _instance = MessagingService._internal();

  factory MessagingService() => _instance;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init(BuildContext context) async {
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // log('Permission Allowed');
    } else {
      _fcm.requestPermission();
    }

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');
    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();

    _fcm.getAPNSToken();
    // log('fcmToken: $fcmToken');
    // Save FcmToken
    await SharedPreferences.getInstance()
        .then((value) => value.setString('fcm_token', fcmToken ?? ''));

    if (Platform.isIOS) {
      String? apnsToken = await _fcm.getAPNSToken();
      if (apnsToken != null) {
        await _fcm.subscribeToTopic('1313133');
      } else {
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await _fcm.getAPNSToken();
        if (apnsToken != null) {
          await _fcm.subscribeToTopic('1313133');
        }
      }
    } else {
      await _fcm.subscribeToTopic('1313133');
    }
    // Handling background messages using the specified handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // Listening for incoming messages while the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('Got a message whilst in the foreground!');

      // Check if the message contains a notification
      if (message.notification != null) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // Print notification title and body
        debugPrint('Notification title: ${notification?.title}');
        debugPrint('Notification body: ${notification?.body}');
        print('Notification Title: ${notification?.title}');
        print('Notification Body: ${notification?.body}');

        // Set foreground notification presentation options
        await _fcm.setForegroundNotificationPresentationOptions(
            alert: true, sound: true, badge: true);

        // Create notification channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description: 'This channel is used for important notifications.',
          // description
          importance: Importance.max,
          playSound: true,
        );

        await _notificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        // Show notification if Android specific notification is available
        if (android != null) {
          _notificationsPlugin.show(
              notification.hashCode,
              notification!.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: android.smallIcon,
                  // other properties...
                ),
              ));
        }
      } else {
        debugPrint('Notification is null');
      }

      // Check if the message contains data
      if (message.data.isNotEmpty) {
        debugPrint('Message data: ${message.data}');
        print('Message Data: ${message.data}');
      } else {
        debugPrint('Message data is empty');
      }
      _handleNotificationClick(context, message);
    });

    LocalNoticationsService(_notificationsPlugin).init();
    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      // Print notification title and body
      debugPrint('Notification body: ${message.notification!.body}');

      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  Future<void> _handleNotificationClick(
      BuildContext context, RemoteMessage message) async {
    // Check if the message contains data
    if (message.notification?.title == 'New request') {
      // Get.offAll(() => BottomBarScreen());
      // Get.to(() => FindTripOnline(message: message));
    } else if (message.notification?.title == 'Accept Offer') {
      // Get.offAll(() => BottomBarScreen());
      // Get.offAll(() => DriverRequestNotificationScreen(message: message));
    }
    if (message.data.isNotEmpty) {
      debugPrint('Message data: ${message.data}');
      print('Message Data: ${message.data}');
      if (message.notification?.title == 'New request') {
        // Get.to(() => FindTripOnline(message: message));
      } else if (message.notification?.title == 'Accept Offer') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('acceptOffer', true);
        // Get.offAll(() => DriverRequestNotificationScreen(message: message));
      }
    } else {
      debugPrint('Message data is empty');
    }
    // final notificationData = message.data;
    // if (notificationData.containsKey('screen')) {
    //   final screen = notificationData['screen'];
    //   Navigator.of(context).pushNamed(screen);
    // }
  }
}

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase to ensure it can be used in the background

  debugPrint('Handling a background message: ${message.messageId}');

  // Check if the message contains a notification
  if (message.notification != null) {
    RemoteNotification? notification = message.notification;

    // Print notification title and body
    debugPrint('Notification title: ${notification?.title}');
    debugPrint('Notification body: ${notification?.body}');
    print('Notification Title: ${notification?.title}');
    print('Notification Body: ${notification?.body}');
  } else {
    debugPrint('Notification is null');
  }

  // Check if the message contains data
  if (message.data.isNotEmpty) {
    debugPrint('Message data: ${message.data}');
    print('Message Data: ${message.data}');
  } else {
    debugPrint('Message data is empty');
  }
}

class LocalNoticationsService {
  LocalNoticationsService(
      this._notificationsPlugin,
      );

  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher', // path to notification icon
    );

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      notificationCategories: [
        DarwinNotificationCategory(
          'category',
          options: {
            DarwinNotificationCategoryOption.allowAnnouncement,
          },
          actions: [
            DarwinNotificationAction.plain(
              'snoozeAction',
              'snooze',
            ),
            DarwinNotificationAction.plain(
              'confirmAction',
              'confirm',
              options: {
                DarwinNotificationActionOption.authenticationRequired,
              },
            ),
          ],
        ),
      ],
    );
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onSelectedNotification,
      onDidReceiveBackgroundNotificationResponse: onSelectNotificationAction,
    );
    final notificationOnLaunchDetails =
    await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationOnLaunchDetails?.didNotificationLaunchApp ?? false) {
      _onSelectedNotification(const NotificationResponse(
          notificationResponseType:
          NotificationResponseType.selectedNotification));
    }
  }

  void _onSelectedNotification(NotificationResponse payload) {}
}

// Top level function
Future onSelectNotificationAction(details) async {
  final localNotificationsService =
  LocalNoticationsService(FlutterLocalNotificationsPlugin());
  await localNotificationsService.init();
}


class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initLocalNotifications(
      RemoteMessage message) async {
    var androidInitializationSettings =
    const AndroidInitializationSettings('@drawable/ic_launcher');
    // const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {});
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Channel",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(channel.id, channel.name,
        channelDescription: "your channel Descrition",
        importance: Importance.high,
        ticker: 'ticker',
        icon: "@drawable/ic_launcher"
      //    icon: "@mipmap/ic_launcher"
    );
    DarwinNotificationDetails darwinNotificationDetails =
    const DarwinNotificationDetails(
        presentSound: true, presentAlert: true, presentBadge: true);
    NotificationDetails notificationDetails = NotificationDetails(
      iOS: darwinNotificationDetails,
      android: androidNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification?.title.toString(),
          message.notification?.body.toString(),
          notificationDetails);
    });
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provision permission");
    } else {
      //AppSettings.openNotificationSettings();
      print("user denied permission");
    }
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("message ${message.notification?.title.toString()}");
        print("message ${message.notification?.body.toString()}");
      }
      if(Platform.isIOS){
        foregroundMessage();
      }
      if(Platform.isAndroid){
        initLocalNotifications( message);
        showNotifications(message);
      }

    });
  }
  Future foregroundMessage()async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
  }


  Future<String?> getToken() async {
    try {
      print("APNs Token: ${await messaging.getAPNSToken()}");
      print("taimoor");
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        print("FCM Token: $token");
        return token;
      } else {
        print("Token retrieval failed: Token is null or empty.");
        return null;
      }
    } catch (e) {
      print("Error getting FCM Token: $e");
      return null;
    }
  }


  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }
}
