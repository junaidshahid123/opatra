import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/main.dart';
import '../constant/AppColors.dart';
import '../controllers/splash_controller.dart';
import '../fcm_handle.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.foregroundMessage();
    notificationServices.getToken().then((value) {
      setState(() {
        fcmToken = value;
      });
      print("device token1 $value");
      print("device token2 $fcmToken");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (splashController) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.appWhiteColor,
                ),
                Container(
                    margin: EdgeInsets.only(left: 50.sp, right: 50.sp),
                    child: Image.asset('assets/images/splashLogo.png'))
              ],
            ),
          );
        });
  }
}