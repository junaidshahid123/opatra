import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/UI/auth/forgot_password.dart';
import 'package:opatra/UI/auth/signup.dart';
import 'package:opatra/UI/home/treatment2.dart';
import 'package:opatra/UI/home/warranty_claim.dart';
import 'package:opatra/constant/AppColors.dart';

import '../home/BottomBarHost.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RxList<int> selectedIndices = <int>[].obs;

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
                  child: Column(
                    children: [
                      buildWelcomeText(),
                      buildEmailField(),
                      buildPasswordField(),
                      buildForgotPasswordText(),
                      buildSignInButton(),
                      buildDontHaveAnAccount()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildForgotPasswordText() {
    return InkWell(
      onTap: (){
        Get.to(()=>ForgotPassword());
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Expanded(child: Container()),
            Text(
              'Forgot Password?',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color(0xFFB7A06A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton() {
    return InkWell(
      onTap: () {
        Get.to(() => BottomBarHost());
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 20, top: 50),
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Sign In',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
    );
  }

  Widget buildDontHaveAnAccount() {
    return InkWell(
      onTap: () {
        Get.to(() => SignUp());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                  color: AppColors.appPrimaryBlackColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Sign Up",
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

  Widget buildPasswordField() {
    return Container(
      height: 45,
      margin: EdgeInsets.only(top: 20),
      child: TextField(
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
          labelStyle: TextStyle(
            color: Color(0xFF989898),
          ),
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

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      height: 45,
      child: TextField(
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

  Widget buildWelcomeText() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'OPATRA',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'login ',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            ),
            Text(
              'to',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'continue',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xFF323943)),
            )
          ],
        )
      ],
    );
  }
}
