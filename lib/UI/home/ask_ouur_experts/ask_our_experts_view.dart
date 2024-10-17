import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/AppColors.dart';
import 'ask_our_experts_controller.dart';

class AskOurExpertsView extends StatelessWidget {
  const AskOurExpertsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AskOurExpertsController>(
        init: AskOurExpertsController(),
        builder: (logic) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
                child: Form(
              key: logic.askOurExperts,
              child: Column(
                children: [buildAppBar(), buildForm(context, logic)],
              ),
            )),
          );
        });
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
          Spacer(),
          buildNotificationOption()
        ],
      ),
    );
  }

  Widget buildBackOption() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50.sp,
            width: 50.sp,
            child: Image.asset('assets/images/ellipse.png'),
          ),
          Container(
            height: 15,
            width: 15,
            child: Image.asset('assets/images/leftArrow.png'),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationOption() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 50.sp,
          width: 50.sp,
          child: Image.asset('assets/images/ellipse.png'),
        ),
        Container(
          height: 15,
          width: 15,
          child: Image.asset('assets/images/bellIcon.png'),
        ),
      ],
    );
  }

  Widget buildName() {
    return const Text(
      'Ask Our Experts',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildForm(BuildContext context, AskOurExpertsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Column(
        children: [
          buildHeading(),
          buildSubjectField(logic),
          buildNameField(logic),
          buildEmailField(logic),
          buildMessageField(logic),
          buildSubmitButton(context, logic)
        ],
      ),
    );
  }

  Widget buildHeading() {
    return Row(
      children: [
        Text(
          'Fill the form',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.appPrimaryBlackColor),
        ),
      ],
    );
  }

  Widget buildSubjectField(AskOurExpertsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Subject',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 65, // Fixed height to include space for potential error
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: AppColors.appPrimaryBlackColor),

                    controller: logic.subjectController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Focused border color
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // General border color
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border for validation errors
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border when focused and error exists
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red, // Red color for the error message
                        fontSize:
                            12, // Optional: Adjust the error message text size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Subject cannot be empty'; // Error message
                      }
                      return null; // No error if input is valid
                    },
                  ),
                ),
                // Space reserved for the error message to prevent layout shift
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameField(AskOurExpertsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Name',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 65, // Fixed height to include space for potential error
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: AppColors.appPrimaryBlackColor),

                    controller: logic.nameController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Focused border color
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // General border color
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border for validation errors
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border when focused and error exists
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red, // Red color for the error message
                        fontSize:
                            12, // Optional: Adjust the error message text size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name cannot be empty'; // Error message
                      }
                      return null; // No error if input is valid
                    },
                  ),
                ),
                // Space reserved for the error message to prevent layout shift
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailField(AskOurExpertsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Email',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 65, // Fixed height to include space for potential error
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: AppColors.appPrimaryBlackColor),

                    controller: logic.emailController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Focused border color
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // General border color
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border for validation errors
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border when focused and error exists
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red, // Red color for the error message
                        fontSize:
                            12, // Optional: Adjust the error message text size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email cannot be empty';
                      }
                      // Add an additional check for valid email format
                      final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      final regex = RegExp(emailPattern);
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null; // Return null if no error
                    },
                  ),
                ),
                // Space reserved for the error message to prevent layout shift
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessageField(AskOurExpertsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Message',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 100, // Fixed height to include space for potential error
            child: Column(
              children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: AppColors.appPrimaryBlackColor),

                    maxLines: 5,
                    controller: logic.messageController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Default border color
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // Focused border color
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFEDEDED), // General border color
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border for validation errors
                          width: 1.5,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          // Red border when focused and error exists
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.red, // Red color for the error message
                        fontSize:
                            12, // Optional: Adjust the error message text size
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Message cannot be empty'; // Error message
                      }
                      return null; // No error if input is valid
                    },
                  ),
                ),
                // Space reserved for the error message to prevent layout shift
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton(
      BuildContext context, AskOurExpertsController logic) {
    return
      Obx(()=>InkWell(
        onTap: () {
          logic.sendData();
        },
        child: Container(
            margin: EdgeInsets.only(top: 40, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xFFB7A06A),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
            Center(
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
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ))),
      ));
  }
}
