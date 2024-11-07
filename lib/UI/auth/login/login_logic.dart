import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppLinks.dart';
import '../../../main.dart';
import '../../home/bottom_bar_host/bottom_bar_host_view.dart';
import '../otp_verification.dart';
import 'login_view.dart';

class LoginLogic extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isPassword = true.obs;
  RxBool rememberMe = false.obs;
  final formKeyForSignIn = GlobalKey<FormState>();
  final RxList<int> selectedIndices = <int>[].obs;
  RxBool isLoading = false.obs;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  Future<void> onLoginTap({bool fromSplash = false}) async {

    if (!fromSplash) {
      autoValidateMode = AutovalidateMode.onUserInteraction;
      update();

      final isValid = formKeyForSignIn.currentState!.validate();
      if (!isValid) return;
    }

    isLoading(true);

    isLoading.value = true;
    final url = Uri.parse(ApiUrls.loginUrl);

    Map<String, String> requestBody = {
      "email": emailController.text,
      "password": passwordController.text,
      "device_token": fcmToken!,
    };

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        url,
        headers: headers,
        body: requestBody,
      );
      print('requestBody========${requestBody}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Extract necessary details from the response
        String token = responseData['authorization']['token'] ?? '';
        String userName = responseData['user']['name'] ?? '';
        String userEmail = responseData['user']['email'] ?? '';
        String emailVerified = responseData['user']['email_verified_at'] ?? '';

        // Save only the required fields to SharedPreferences
        await prefs.setString('token', token);
        await prefs.setString('userName', userName);
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('email_verified', emailVerified);
        String emailVerifiedAt = prefs.getString('emailverified') ?? "null";
        print(emailVerifiedAt);
        String email = prefs.getString('userEmail') ?? "";
        // Optionally navigate to the OTP verification screen
        Get.snackbar('Success', 'User Login successfully!',
            backgroundColor: Color(0xFFB7A06A), colorText: Colors.white);
        await Future.delayed(Duration(seconds: 3));

        if (token != null && emailVerifiedAt != null) {
          // Token exists and email is verified, navigate to BottomBarHost
          Get.offAll(() => BottomBarHostView());
        } else if (token == null) {
          // No token found, navigate to Login
          Get.offAll(() => LoginView());
        } else if (token != null && emailVerifiedAt == null) {
          // Token exists but email is not verified, navigate to OTP Verification
          Get.offAll(() => OtpVerification(email: email, isFromSignUp: false));
        } else {
          // Fallback, navigate to Login if none of the conditions match
          Get.offAll(() => LoginView());
        }
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to register user';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading spinner
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool isValidEmail(String email) {
    // Regular expression for validating an email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Return whether the email matches the regex
    return emailRegExp.hasMatch(email);
  }

  onEyeButtonTap() {
    print('kdfbvfahbafvjkfv');
    isPassword.value = !isPassword.value;
  }

  // onForgotPasswordTap() {
  //   pSetRout(page: () => const ForgotPasswordView());
  // }

  onRememberMeChange(bool? value) {
    rememberMe.toggle();
  }

// onSignupTap() {
//   pSetRout(page: () => const ChoiceView(),routeType: RouteType.pushReplace);
// }

// Future<void> onLoginTap({bool fromSplash = false}) async{
//
//   if(!fromSplash){
//     if(kDebugMode){
//       if(emailController.text.isEmpty){
//         emailController.text = 'gf@gmail.com';
//       }
//
//       if(passwordController.text.isEmpty){
//         passwordController.text = 'password123';
//       }
//     }
//   }
//
//   if (!fromSplash) {
//     autoValidateMode = AutovalidateMode.onUserInteraction;
//     update();
//
//     final isValid = formKey.currentState!.validate();
//     if (!isValid) return;
//   }
//
//   isLoading(true);
//
//   // if(playerId == null){
//   //   OneSignalHelper.getPlayerId();
//   //   debugPrint(playerId??'Player id not available');
//   // }
//
//   final params = <String, dynamic>{
//     'email': emailController.text,
//     'password': passwordController.text,
//     // 'playerId': ''
//   };
//   print('params====$params');
//   pFocusOut();
//   ViewResponse response = await HttpCalls.callPostApi(MyEndPoints.login, params, token: token,hasAuth: false);
//
//   if(response.status){
//
//     final LoginModel loginModel = loginModelFromJson(response.data);
//     token = loginModel.token;
//     S.sAuth = loginModel.user;
//     await FsRepo.createUpdateUser();
//     if(token.isNotEmpty){
//       if(rememberMe()) {
//         Pref.setPrefBoolean(Pref.hasAuth, true);
//         Pref.setPrefString(Pref.username,emailController.text);
//         Pref.setPrefString(Pref.password, passwordController.text);
//       }
//       pSetRout(page: () => const DashboardView(), routeType: RouteType.pushReplaceAll);
//       return;
//     }else{
//       pShowToast(message: response.message);
//       if(fromSplash){
//         bool isFirst = Pref.getPrefBoolean(Pref.option1,defaultValue: true);
//         Future.delayed(3000.milliseconds, () {
//           pSetRout(page: () => isFirst ? const OnBoardingView()  : const LandingPageView(), routeType: RouteType.pushReplace);
//         });
//       }
//     }
//   } else{
//     pShowToast(message: response.errorMessage);
//     if(fromSplash){
//       bool isFirst = Pref.getPrefBoolean(Pref.option1,defaultValue: true);
//       Future.delayed(3000.milliseconds, () {
//         pSetRout(page: () => isFirst ? const OnBoardingView()  : const LandingPageView(), routeType: RouteType.pushReplace);
//       });
//     }
//   }
//   isLoading(false);
// }
}
