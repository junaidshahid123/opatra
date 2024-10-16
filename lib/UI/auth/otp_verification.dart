import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/auth/new_password.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:http/http.dart' as http;
import '../../controllers/bottom_bar_host_controller.dart';
import '../home/BottomBarHost.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final bool isFromSignUp;

  OtpVerification({super.key, required this.email, required this.isFromSignUp});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final BottomBarHostController controller =
      Get.put(BottomBarHostController()); // Initialize the controller
  RxBool isLoading = false.obs;

  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
    final String url = 'https://opatra.fai-tech.online/api/verify-otp';

    Map<String, String> requestBody = {
      "email": widget.email,
      "otp": otp, // Send the OTP as part of the request body
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
      print('requestBody====${requestBody}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');

        // Extract token, name, and email
        // var token = responseData['authorization']['token'] ?? "";
        // var userName = responseData['user']['name'] ?? ""; // Fallback to empty string
        // var userEmail = responseData['user']['email'] ?? ""; // Fallback to empty string
        //
        // // Store data in shared preferences
        // await prefs.setString('token', token);
        // await prefs.setString('userName', userName);
        // await prefs.setString('userEmail', userEmail);

        Get.snackbar('Success', 'Otp Verified successfully!',
            backgroundColor: Color(0xFFB7A06A), colorText: Colors.white);
        if (widget.isFromSignUp == true) {
          Get.offAll(BottomBarHost());
        }
        if (widget.isFromSignUp == false) {
          Get.offAll(NewPassword());
        }
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage = responseData['message'] ?? 'Failed to verify OTP';

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
    return GetBuilder<BottomBarHostController>(
        init: BottomBarHostController(),
        builder: (BottomBarHostController) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  buildAppBar(),
                  Container(
                    child:
                        Image.asset('assets/images/otpVerificationImage.png'),
                  ),
                  buildEnterOtpText(),
                  buildOtpField(),
                  buildTimer(),
                  buildDidntReceivedCode(),
                  Spacer(),
                  buildSubmitButton(),
                ],
              ),
            ),
          );
        });
  }

  Widget buildTimer() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '00:13 Sec',
            style: TextStyle(
                color: Color(0xFF464646),
                fontWeight: FontWeight.w500,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildOtpField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      child: OtpTextField(
        margin: EdgeInsets.only(left: 5, right: 5),
        // Reduced the margin between fields
        fieldWidth: 40,
        fieldHeight: 40,
        numberOfFields: 6,
        // Number of OTP fields
        borderColor: Color(0xFF989898),
        showFieldAsBox: true,
        textStyle: TextStyle(
          height: 1,
          fontSize: 12,
          color: Colors.black, // Ensure the input text color is black
        ),
        onCodeChanged: (String code) {
          // Handle validation for partially entered OTP code here
          if (code.length == 6) {
            print("OTP is complete: $code");
          } else {
            print("OTP is incomplete");
          }
        },
        onSubmit: (String verificationCode) {
          // Check if OTP is complete before proceeding
          if (verificationCode.length == 6) {
            print("OTP successfully entered: $verificationCode");
            // Handle complete OTP submission
            verifyOtp(verificationCode);
          } else {
            print("Please fill all OTP fields.");
          }
        },
      ),
    );
  }

  Widget buildEnterOtpText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the OTP sent to -',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF323943)),
              ),
              Text(
                controller.userEmail.value.isNotEmpty
                    ? controller.userEmail.value
                    : 'abc123@gmail.com',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB7A06A)),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'wrong email ?',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFB7A06A)),
          )
        ],
      ),
    );
  }

  Widget buildDidntReceivedCode() {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code ?",
              style: TextStyle(
                  color: AppColors.appPrimaryBlackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Re-send",
              style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Obx((() => InkWell(
          onTap: () {
            // verifyOtp();
            // Get.to(() => NewPassword());
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
        )));
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
      'Verify Otp',
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
