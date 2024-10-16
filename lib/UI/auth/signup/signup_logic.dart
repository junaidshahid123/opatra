import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main.dart';

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

  Future<void> onSignUpTap({bool fromSplash = false}) async {
    if (!fromSplash) {
      autoValidateMode = AutovalidateMode.onUserInteraction;
      update();

      final isValid = formKeyForSingUp.currentState!.validate();
      if (!isValid) return;
    }
    isLoading.value = true;
    final String url = 'https://opatra.fai-tech.online/api/register';

    Map<String, String> requestBody = {
      "name": nameController.text,
      // "last_name": _lastNameController.text,
      // "username": _nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "phone": phoneController.text,
      "password_confirmation": confirmPasswordController.text,
      "device_token": fcmToken!,
    };

    Map<String, String> headers = {
      "Accept": "application/json",
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      isLoading.value = false; // Stop loading spinner

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData=${responseData}');

        // Extract token, name, and email
        var token = responseData['token'] ?? "";
        var userName =
            responseData['user']['name'] ?? ""; // Fallback to empty string
        var userEmail =
            responseData['user']['email'] ?? ""; // Fallback to empty string

        // Store data in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userName', userName);
        await prefs.setString('userEmail', userEmail);

        // Get.offAll(OtpVerification(
        //   email: _emailController.text,
        //   isFromSignUp: true,
        // ));
      } else {
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
    print('jdfbjsdjb');
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
