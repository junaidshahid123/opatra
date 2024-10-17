import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';
import '../otp_verification.dart';

class SignUpLogic extends GetxController {
  RxBool isLoading = false.obs;
  final formKeyForSingUp = GlobalKey<FormState>();
  final nameController = TextEditingController(),
      passwordController = TextEditingController(),
      emailController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      lastNameController = TextEditingController(),
      phoneController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;

  RxBool isPasswordA = true.obs;
  RxBool isConfirmPassword = true.obs;

  Future<void> onSignUpTap() async {
    // Validate the form using formKey
    final isValid = formKeyForSingUp.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }

    // Show loading spinner
    isLoading.value = true;

    final String url = 'https://opatra.fai-tech.online/api/register';

    // Prepare request body
    Map<String, String> requestBody = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
      "password_confirmation": confirmPasswordController.text,
      "device_token": fcmToken!, // Assuming fcmToken is non-null
    };

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    try {
      final client = http.Client();

      // Send the HTTP POST request
      final http.Response response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      // Stop the loading spinner
      isLoading.value = false;

      // Check if the response status is success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData=${responseData}');

        // Extract the token, user name, and user email
        var token = responseData['token'] ?? "";
        var userName = responseData['user']['name'] ?? "";
        var userEmail = responseData['user']['email'] ?? "";

        // Store the data in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userName', userName);
        await prefs.setString('userEmail', userEmail);

        // Optionally navigate to the OTP verification screen
        Get.offAll(
            OtpVerification(email: emailController.text, isFromSignUp: true));
      } else {
        // Handle any errors from the API response
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to register user';

        // If there are detailed error messages in the response
        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        // Show an error message using Get.snackbar
        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      // Handle any exceptions during the API call
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  final RxList<int> selectedIndices = <int>[].obs;

  bool isValidEmail(String email) {
    // Regular expression for validating an email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Return whether the email matches the regex
    return emailRegExp.hasMatch(email);
  }

  onPasswordTap() {
    isPasswordA.value = !isPasswordA.value;
  }

  onConfirmPasswordTap() {
    isConfirmPassword.value = !isConfirmPassword.value;
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
