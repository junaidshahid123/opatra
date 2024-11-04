import 'package:get/get.dart';
import 'package:opatra/UI/auth/login/login_view.dart';
import 'package:opatra/UI/auth/otp_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../UI/home/bottom_bar_host/bottom_bar_host_view.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve stored values
    String? token = prefs.getString('token');
    String emailVerifiedAt = prefs.getString('emailverified') ?? "null"; // Default to "null" if not set
    String email = prefs.getString('userEmail') ?? ""; // Default to empty string if not set
print(emailVerifiedAt);
print("Taimoor");
    // Wait for 3 seconds before navigating
    await Future.delayed(Duration(seconds: 3));

    // Determine navigation based on the presence of token and email verification status
    if (token != null && emailVerifiedAt != "null") {
      // Token exists and email is verified, navigate to BottomBarHost
      Get.offAll(() => BottomBarHostView());
    } else if (token == null) {
      // No token found, navigate to Login
      Get.offAll(() => LoginView());
    } else if (token != null && emailVerifiedAt == "null") {
      // Token exists but email is not verified, navigate to OTP Verification
      Get.offAll(() => OtpVerification(email: email, isFromSignUp: false));
    } else {
      // Fallback, navigate to Login if none of the conditions match
      Get.offAll(() => LoginView());
    }
  }

}
