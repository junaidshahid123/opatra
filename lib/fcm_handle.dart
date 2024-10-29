
import 'dart:io';
import 'dart:math';

//import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
