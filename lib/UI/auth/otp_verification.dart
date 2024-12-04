import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/auth/new_password.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:http/http.dart' as http;
import 'package:opatra/constant/AppLinks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/bottom_bar_host/bottom_bar_host_logic.dart';
import '../home/bottom_bar_host/bottom_bar_host_view.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final bool isFromSignUp;

  OtpVerification({super.key, required this.email, required this.isFromSignUp});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  RxBool isLoading = false.obs;
  late Timer _timer;
  int _remainingSeconds = 60; // Start from 1 minute
  String? otp;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel(); // Stop the timer when it reaches 0
      }
    });
  }

  String getFormattedTime() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} Sec';
  }

  Future<void> verifyOtp(String otp) async {
    isLoading.value = true;
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
        Uri.parse(ApiUrls.verifyOtp),
        headers: headers,
        body: requestBody,
      );

      print('requestBody====${requestBody}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');
        var emailverified = responseData['email_verified_at'] ?? "";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('emailverified', emailverified);

        Get.snackbar('Success', 'Otp Verified successfully!',
            backgroundColor: Color(0xFFB7A06A), colorText: Colors.white);
        if (widget.isFromSignUp == true) {
          Get.offAll(BottomBarHostView());
        }
        if (widget.isFromSignUp == false) {
          Get.offAll(NewPassword());
        }
      } else {
        isLoading.value = false; // Stop loading spinner

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Container(
              child: Image.asset('assets/images/otpVerificationImage.png'),
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
  }

  Widget buildTimer() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            getFormattedTime(),
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
        fieldWidth: 40,
        fieldHeight: 40,
        numberOfFields: 6,
        borderColor: Color(0xFF989898),
        showFieldAsBox: true,
        textStyle: TextStyle(
          height: 1,
          fontSize: 12,
          color: Colors.black,
        ),
        onCodeChanged: (String code) {
          if (code.length == 6) {
            print("OTP is complete: $code");
            otp=code;
          } else {
            print("OTP is incomplete");
          }
        },
        onSubmit: (String verificationCode) {
          if (verificationCode.length == 6) {
            otp=verificationCode;

            print("OTP successfully entered: $verificationCode");
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
                widget.email.isNotEmpty ? widget.email : 'abc123@gmail.com',
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
        verifyOtp(otp!);
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
                width: 20.0,
                height: 20.0,
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
