import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/UI/auth/login.dart';
import 'package:opatra/UI/home/BottomBarHost.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  RxBool isLoading = false.obs;
  final _nameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _emailController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _lastNameController = TextEditingController(),
      _phoneController = TextEditingController();

  Future<void> registerUser() async {
    isLoading.value = true;
    final String url = 'https://opatra.meetchallenge.com/api/register';

    Map<String, String> requestBody = {
      "name": _nameController.text,
      "last_name": _lastNameController.text,
      "username": _nameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "phone": _phoneController.text,
      "password_confirmation": _confirmPasswordController.text
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
        print('token=${responseData['data']['token']}');

        var token = responseData['data']['token'] ?? "";
        var userName = responseData['data']['user']['name'] ??
            ""; // Fallback to empty string
        var userEmail = responseData['data']['user']['email'] ??
            ""; // Fallback to empty string
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('userEmail', userEmail);
        await prefs.setString('userName', userName);
        Get.snackbar('Success', 'User registered successfully!',
            backgroundColor: Color(0xFFB7A06A), colorText: Colors.white);
        Get.offAll(BottomBarHost());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Replace with your AppColors.appWhiteColor
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFB7A06A),
                  ),
                ),
                Container(
                  child: Image.asset(
                    'assets/images/splashLogo.png',
                    color: AppColors.appWhiteColor,
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.height / 4,
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // Full width of the screen
                height: MediaQuery.of(context).size.height /
                    1.5, // Adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildWelcomeText(),
                          buildUserNameField(),
                          buildLastNameField(),
                          buildEmailField(),
                          buildPhoneField(),
                          buildPasswordField(),
                          buildConfirmPasswordField(),
                          SizedBox(
                            height: 20,
                          ),
                          buildSignInButton(),
                          buildAlreadyHaveAnAccount()
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return Obx(() => InkWell(
          onTap: () {
            // Check if the name field is empty
            if (_nameController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Name',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }

            // Check if the last field is empty
            if (_lastNameController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Last Name',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }

            // Check if the email field is empty
            if (_emailController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Email',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }
            // Check if the email field is empty
            if (_phoneController.text.isEmpty) {
              Get.snackbar('Alert', 'Please Enter Phone',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early to avoid further checks
            }

            // Validate the email format
            if (!isValidEmail(_emailController.text)) {
              Get.snackbar('Alert', 'Please Enter a Valid Email',
                  backgroundColor: Colors.red, colorText: Colors.white);
              return; // Return early if the email is invalid
            }

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
            registerUser();
            // If all checks pass, proceed to the next screen or perform the action
            // Get.to(() => BottomBarHost());
          },
          child: Container(
              margin: EdgeInsets.only(
                bottom: 20,
              ),
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
                          'Continue',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ))),
        ));
  }

  Widget buildAlreadyHaveAnAccount() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(
                color: AppColors.appPrimaryBlackColor,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Get.to(() => Login());
            },
            child: Text(
              "Sign In",
              style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget buildUserNameField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 45,
      child: TextField(
        controller: _nameController,
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
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
          label: RichText(
              text: TextSpan(
                  text: 'Username ',
                  style: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Colors.brown, // Set the asterisk color here
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
          hintText: 'Enter your username',
          hintStyle: TextStyle(
            color: Color(0xFF989898),
          ),
          suffixIcon: Container(
            height: 10, // Specific height
            width: 10, // Specific width
            child: Container(
              margin: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/userProfileIcon.png', // Adjust the image within the container
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

  Widget buildConfirmPasswordField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20),
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
          label: RichText(
              text: TextSpan(
            text: 'Confirm Password',
            style: TextStyle(
              color: Color(0xFF989898),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )),
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

  Widget buildPhoneField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: _phoneController,
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
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
          label: RichText(
              text: TextSpan(
            text: 'Phone',
            style: TextStyle(
              color: Color(0xFF989898),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )),
          // suffixIcon: Container(
          //   height: 10, // Specific height
          //   width: 10, // Specific width
          //   child: Container(
          //     margin: EdgeInsets.all(15),
          //     child: Image.asset(
          //       'assets/images/userProfileIcon.png', // Adjust the image within the container
          //     ),
          //   ),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget buildLastNameField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20),
      child: TextField(
        controller: _lastNameController,
        cursorColor: AppColors.appPrimaryBlackColor,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
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
          label: RichText(
              text: TextSpan(
            text: 'Last Name',
            style: TextStyle(
              color: Color(0xFF989898),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )),
          suffixIcon: Container(
            height: 10, // Specific height
            width: 10, // Specific width
            child: Container(
              margin: EdgeInsets.all(15),
              child: Image.asset(
                'assets/images/userProfileIcon.png', // Adjust the image within the container
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
      margin: EdgeInsets.only(top: 20),
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
          label: RichText(
              text: TextSpan(
            text: 'Password',
            style: TextStyle(
              color: Color(0xFF989898),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )),
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

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
          label: RichText(
              text: TextSpan(
            text: 'Email',
            style: TextStyle(
              color: Color(0xFF989898),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )),
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

  Widget buildWelcomeText() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter details to create account',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            )
          ],
        ),
      ],
    );
  }
}
