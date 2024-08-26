import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../UI/auth/login.dart';
import '../UI/home/BottomBarHost.dart';

class SplashController extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Wait for 3 seconds before navigating to the next screen
    Future.delayed(Duration(seconds: 3), () {
      // Replace '/nextScreen' with the actual route or screen you want to navigate to
      Get.offAll(() => Login());
    });
  }
}