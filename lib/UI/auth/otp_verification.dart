import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/constant/AppColors.dart';

import 'new_password.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
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
      margin: EdgeInsets.only(top: 20),
      child: OtpTextField(
        margin: EdgeInsets.only(left: 10, right: 10),
        fieldWidth: 50,
        // Set width to 100
        fieldHeight: 50,
        // Set height to 100
        numberOfFields: 4,
        borderColor: Color(0xFF989898),
        showFieldAsBox: true,
        textStyle: TextStyle(
          fontSize: 24,
          color: Colors.black, // Set the input text color to black
        ),
        onCodeChanged: (String code) {
          // Handle validation or other logic here
        },
        onSubmit: (String verificationCode) {
          // Handle the complete OTP code submission here
          print("Entered OTP Code: $verificationCode");
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
                'abc123@gmail.com',
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
    return InkWell(
      onTap: () {
        Get.to(()=>NewPassword());
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
            child: Text(
              'Submit',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
    );
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
