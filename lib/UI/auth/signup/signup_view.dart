import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/auth/login/login_view.dart';
import 'package:opatra/UI/auth/signup/signup_logic.dart';
import 'package:opatra/constant/AppColors.dart';

class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpLogic>(
        init: SignUpLogic(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: Colors.white,
            // Replace with your AppColors.appWhiteColor
            body: SafeArea(
              child: Form(
                key: logic.formKeyForSingUp,
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
                            'assets/images/splashLogoIcon.png',
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
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  buildWelcomeText(),
                                  // buildAddLocationButton(),
                                  buildUserNameField(logic),
                                  // buildLastNameField(),
                                  buildEmailField(logic),
                                  buildPhoneField(logic),
                                  buildPasswordField(logic),
                                  buildConfirmPasswordField(logic),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  buildSignUpButton(context, logic),
                                  buildAlreadyHaveAnAccount()
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildSignUpButton(BuildContext context, SignUpLogic logic) {
    return Obx(() => InkWell(
          onTap: () {
            // Check if the name field is empty
            // if (_nameController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Name',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            //
            // // Check if the last field is empty
            // if (_lastNameController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Last Name',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }

            // Check if the email field is empty
            // if (_emailController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Email',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            // // Check if the email field is empty
            // if (_phoneController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Phone',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            //
            // // Validate the email format
            // if (!isValidEmail(_emailController.text)) {
            //   Get.snackbar('Alert', 'Please Enter a Valid Email',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early if the email is invalid
            // }
            //
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
            //
            // // Check if the confirmPassword field is empty
            // if (_confirmPasswordController.text.isEmpty) {
            //   Get.snackbar('Alert', 'Please Enter Confirm Password',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return; // Return early to avoid further checks
            // }
            // // check if matched
            // if (_passwordController.text != _confirmPasswordController.text) {
            //   Get.snackbar('Alert', 'Passwords Does Not Match ',
            //       backgroundColor: Colors.red, colorText: Colors.white);
            //   return;
            // }
            //
            // registerUser();
            // If all checks pass, proceed to the next screen or perform the action
            // Get.to(() => OtpVerification());
            logic.onSignUpTap();
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
// From SignupView to LoginView
              Get.off(() => LoginView());
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

  Widget buildUserNameField(SignUpLogic logic) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: logic.nameController,
            cursorColor: AppColors.appPrimaryBlackColor,
            style: TextStyle(color: AppColors.appPrimaryBlackColor),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
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
                  ],
                ),
              ),
              hintText: 'Enter your username',
              hintStyle: TextStyle(color: Color(0xFF989898)),
              suffixIcon: Container(
                height: 10,
                width: 10,
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Image.asset(
                    'assets/images/userProfileIcon.png',
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            // Validator for the TextFormField
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username cannot be empty';
              }
              return null; // Return null if no error
            },
          ),
          SizedBox(height: 4), // Space for validation message
        ],
      ),
    );
  }

  Widget buildConfirmPasswordField(SignUpLogic logic) {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: logic.confirmPasswordController,
                cursorColor: AppColors.appPrimaryBlackColor,
                style: TextStyle(color: AppColors.appPrimaryBlackColor),
                obscureText: logic.isConfirmPassword.value,
                // Obscure text if true
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
                  ),
                  label: RichText(
                    text: TextSpan(
                      text: 'Confirm Password ',
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
                      ],
                    ),
                  ),
                  hintText: '***********',
                  hintStyle: TextStyle(color: Color(0xFF989898)),
                  suffixIcon: IconButton(
                    icon: Icon(logic.isConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => logic.onConfirmPasswordTap(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // Validator for the TextFormField
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm Password cannot be empty';
                  }
                  // Check if the password and confirm password match
                  if (value != logic.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null; // Return null if no error
                },
              ),
              SizedBox(height: 4), // Space for validation message
            ],
          ),
        ));
  }

  Widget buildPhoneField(SignUpLogic logic) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: logic.phoneController,
            cursorColor: AppColors.appPrimaryBlackColor,
            style: TextStyle(color: AppColors.appPrimaryBlackColor),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF989898)),
              ),
              label: RichText(
                text: TextSpan(
                  text: 'Phone ',
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
                  ],
                ),
              ),
              hintText: '0033 373733 33',
              hintStyle: TextStyle(color: Color(0xFF989898)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            // Validator for the TextFormField
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone cannot be empty';
              }
              // Add an additional check for valid phone number format
              final phonePattern =
                  r'^\+?[0-9\s]+$'; // Adjust this regex based on your phone number format
              final regex = RegExp(phonePattern);
              if (!regex.hasMatch(value)) {
                return 'Enter a valid phone number';
              }
              return null; // Return null if no error
            },
          ),
          SizedBox(height: 4), // Space for validation message
        ],
      ),
    );
  }

  Widget buildPasswordField(SignUpLogic logic) {
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
                obscureText: logic.isPasswordA.value,
                // Obscure text if true
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF989898)),
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
                            // Set the asterisk color here
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: '***********',
                  hintStyle: TextStyle(color: Color(0xFF989898)),
                  suffixIcon: IconButton(
                    icon: Icon(logic.isPasswordA.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () => logic.onPasswordTap(),
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

  Widget buildEmailField(SignUpLogic logic) {
    return Container(
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
                        color: Colors.brown, // Set the asterisk color here
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: 'a12@gmail.com',
              hintStyle: TextStyle(color: Color(0xFF989898)),
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
            // Validator for the TextFormField
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email cannot be empty';
              }
              // Add an additional check for valid email format
              final emailPattern =
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
              final regex = RegExp(emailPattern);
              if (!regex.hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null; // Return null if no error
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
