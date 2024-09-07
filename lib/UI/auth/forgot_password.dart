import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/UI/auth/new_password.dart';
import 'package:opatra/UI/auth/otp_verification.dart';
import 'package:opatra/constant/AppColors.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  RxBool isLoading = false.obs;
  final _emailController = TextEditingController();

  bool isValidEmail(String email) {
    // Regular expression for validating an email
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Return whether the email matches the regex
    return emailRegExp.hasMatch(email);
  }

  Future<void> forgotPassword() async {
    isLoading.value = true;
    final String url = 'https://opatra.meetchallenge.com/api/forgot-password';

    // Retrieve token from SharedPreferences
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('token'); // Get the token from shared prefs
    Map<String, String> requestBody = {
      "email": _emailController.text,
    };
    // Ensure the token exists before proceeding
    // if (token == null || token.isEmpty) {
    //   isLoading.value = false;
    //   Get.snackbar('Error', 'No token found. Please log in again.',
    //       backgroundColor: Colors.red, colorText: Colors.white);
    //   return;
    // }

    Map<String, String> headers = {
      "Accept": "application/json",
      // "Authorization": "Bearer $token", // Include the Bearer token in headers
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        String message = responseData['message'] ?? 'OTP sent successfully!';
        // Store data in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', _emailController.text);

        Get.snackbar('Success', message,
            backgroundColor: Color(0xFFB7A06A), colorText: Colors.white);

        // Navigate to NewPassword screen
        Get.offAll(OtpVerification(email: _emailController.text,isFromSignUp: false,));
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to send OTP. Please try again.';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${key.toUpperCase()}: ${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading spinner
      Get.snackbar('Error', 'An error occurred: ${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Allows layout to resize when keyboard opens
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // Enables scrolling when the keyboard opens to prevent overflow
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context)
                    .viewInsets
                    .bottom, // Adjusts for the keyboard
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      buildAppBar(),
                      Container(
                        child: Image.asset(
                            'assets/images/forgotPasswordImage.png'),
                      ),
                      buildForgotYourAccountPasswordText(),
                      buildEmailField(),
                      Expanded(child: Container()), // Fills remaining space
                      buildContinueButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildForgotYourAccountPasswordText() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'forgot your account',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF323943)),
              )
            ],
          ),
          Text(
            'password ?',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF323943)),
          )
        ],
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 45,
      child: TextField(
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
        controller: _emailController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF989898),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF989898),
            ),
          ),
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Color(0xFF989898),
          ),
          hintText: 'Enter your email',
          hintStyle: TextStyle(
            color: Color(0xFF989898),
          ),
          suffixIcon: Container(
            height: 10, // Specific height
            width: 10, // Specific width
            child: Container(
              margin: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/emailIcon.png', // Adjust the image within the container
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }

  Widget buildContinueButton() {
    return Obx(() => InkWell(
        onTap: () {
          // Check if the email field is empty
          if (_emailController.text.isEmpty) {
            Get.snackbar('Alert', 'Please Enter Email',
                backgroundColor: Colors.red, colorText: Colors.white);
            return; // Return early to avoid further checks
          }

          // Validate the email format
          if (!isValidEmail(_emailController.text)) {
            Get.snackbar('Alert', 'Please Enter a Valid Email',
                backgroundColor: Colors.red, colorText: Colors.white);
            return; // Return early if the email is invalid
          }
          forgotPassword();
        },
        child: Container(
            margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xFFB7A06A),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            Center(
                child: isLoading.value == true
                    ? SizedBox(
                        width: 20.0, // Adjust the width
                        height: 20.0, // Adjust the height
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: AppColors.appWhiteColor,
                        ),
                      )
                    : Text(
                        'Continue',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      )))));
  }

  Widget buildAppBar() {
    return Container(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ),
      child: Row(
        children: [
          buildBackOption(),
          Spacer(),
          buildName(),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget buildName() {
    return const Text(
      'Forgot Password',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFF263238)),
    );
  }

  Widget buildBackOption() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Image.asset(
        'assets/images/backArrow.png',
        height: 20,
        width: 20,
      ),
    );
  }
}
