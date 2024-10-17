import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/auth/forgot_password.dart';
import 'package:opatra/constant/AppColors.dart';
import '../signup/signup_view.dart';
import 'login_logic.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
        init: LoginLogic(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: Colors.white,
            // Replace with your AppColors.appWhiteColor
            body: SafeArea(
              child: Form(
                key: logic.formKeyForSignIn,
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
                          color: Colors.white,
                          // Background color for the container
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
                              buildEmailField(logic),
                              buildPasswordField(logic),
                              buildForgotPasswordText(),
                              buildSignInButton(context, logic),
                              buildDontHaveAnAccount()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildForgotPasswordText() {
    return InkWell(
      onTap: () {
        Get.to(() => ForgotPassword());
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

  Widget buildSignInButton(BuildContext context, LoginLogic logic) {
    return Obx(() => InkWell(
          onTap: () {
            // // Check if the email field is empty
            // if (_emailController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Email',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            // // Validate the email format
            // if (!isValidEmail(_emailController.text)) {
            //   Get.snackbar('Alert', 'Please Enter a Valid Email',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early if the email is invalid
            // }
            // // Check if the password field is empty
            // if (_passwordController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Password',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            // // Check if the password field is empty
            // if (_passwordController.text.length < 8) {
            //   Get.snackbar('Alert', 'Password must be at least 8 characters',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            // loginUser();
            logic.onLoginTap();
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
                  child: logic.isLoading.value == true
                      ? SizedBox(
                          width: 20.0, // Adjust the width
                          height: 20.0, // Adjust the height
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: AppColors.appWhiteColor,
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ))),
        ));
  }

  Widget buildDontHaveAnAccount() {
    return InkWell(
      onTap: () {
        // From LoginView to SignupView
        Get.off(() => SignupView());
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

  Widget buildPasswordField(LoginLogic logic) {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: logic.passwordController,
                cursorColor: AppColors.appPrimaryBlackColor,
                style: TextStyle(color: AppColors.appPrimaryBlackColor),
                obscureText: logic.isPassword.value,
                // Obscure text if true
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // Red border on error
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2.0),
                    // Red border when focused and in error
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red, // Error message in red color
                  ),
                  label: RichText(
                    text: TextSpan(
                      text: 'Password ',
                      style: TextStyle(
                        color: Color(0xFF989898),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: '*********',
                  hintStyle: TextStyle(color: Color(0xFF989898)),
                  suffixIcon: IconButton(
                    icon: Icon(logic.isPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => logic.onEyeButtonTap(),

                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // Validator for the TextFormField
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password cannot be empty';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  // Add any other password rules you want to enforce here
                  return null; // Return null if no error
                },
              ),
              SizedBox(height: 4), // Space for validation message
            ],
          ),
        ));
  }

  Widget buildEmailField(LoginLogic logic) {
    return
      Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: logic.emailController,
            cursorColor: AppColors.appPrimaryBlackColor,
            style: TextStyle(color: AppColors.appPrimaryBlackColor),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                // Red border on error
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
                // Red border when focused and in error
                borderRadius: BorderRadius.circular(20.0),
              ),
              errorStyle: TextStyle(
                color: Colors.red, // Error message in red color
              ),
              label: RichText(
                text: TextSpan(
                  text: 'Email ',
                  style: TextStyle(
                    color: Color(0xFF989898),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'a12@gmail.com',
              hintStyle: TextStyle(color: Color(0xFF989898)),
              suffixIcon: Container(
                height: 10,
                width: 10,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/emailIcon.png',
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              final emailPattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              final regex = RegExp(emailPattern);
              if (!regex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 4), // Space for validation message
        ],
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
