import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:opatra/UI/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/AppColors.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  RxBool isLoading = false.obs;
  final _passwordController = TextEditingController(),
      _confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    isLoading.value = true;
    final String url = 'https://opatra.meetchallenge.com/api/new-password';
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Get the token from shared prefs

    // Ensure the token exists before proceeding
    if (email == null || email.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No email found.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Map<String, String> requestBody = {
      "email": email,
      "password": _passwordController.text,
      "password_confirmation": _confirmPasswordController.text,
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
      print('requestBody======${requestBody}');

      isLoading.value = false; // Stop loading spinner

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData=${responseData}');
        Get.snackbar('Success', 'New Password Created Successfully');
        Get.offAll(() => Login());
      } else {
        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to change password';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    buildText(),
                    buildPasswordField(),
                    buildConfirmPasswordField(),
                    Spacer(),
                    buildSubmitButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmPasswordField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      child: TextField(
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
        controller: _confirmPasswordController,
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
          labelText: 'Confirm Password',
          hintText: 'Renter your password',
          hintStyle: TextStyle(
            color: Color(0xFF989898),
          ),
          suffixIcon: Container(
            height: 10, // Specific height
            width: 10, // Specific width
            child: Container(
              margin: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/obsecureIcon.png', // Adjust the image within the container
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      child: TextField(
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
        controller: _passwordController,
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
          labelText: 'Password',
          hintText: 'Enter your password',
          hintStyle: TextStyle(
            color: Color(0xFF989898),
          ),
          suffixIcon: Container(
            height: 10, // Specific height
            width: 10, // Specific width
            child: Container(
              margin: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/obsecureIcon.png', // Adjust the image within the container
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Text(
      "Create your password",
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Color(0xFF323943)),
      textAlign: TextAlign
          .center, // Optional: To center the text horizontally within the text widget
    );
  }

  Widget buildSubmitButton() {
    return Obx(() => InkWell(
          onTap: () {
            // Check if the password field is empty
            if (_passwordController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Password',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }
            // Check if the password field is empty
            if (_passwordController.text.length < 8) {
              Get.snackbar('Alert', 'Password must be at least 8 characters',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }

            // Check if the confirmPassword field is empty
            if (_confirmPasswordController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Confirm Password',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }
            // check if matched
            if (_passwordController.text != _confirmPasswordController.text) {
              Get.snackbar('Alert', 'Passwords Does Not Match ',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return;
            }
            changePassword();
          },
          child: Container(
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                color: Color(0xFFB7A06A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
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
                          'Submit',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ))),
        ));
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
      'New Password',
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
