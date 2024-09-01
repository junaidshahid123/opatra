import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UI/auth/login.dart';
import '../UI/home/BottomBarHost.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Wait for 3 seconds before navigating
    await Future.delayed(Duration(seconds: 3));

    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to BottomBarHost
      Get.offAll(() => BottomBarHost());
    } else {
      // No token found, navigate to Login
      Get.offAll(() => Login());
    }
  }
}
