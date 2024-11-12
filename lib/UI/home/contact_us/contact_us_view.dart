import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/contact_us/contact_us_controller.dart';
import '../../../constant/AppColors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class ContactUsView extends StatelessWidget {
  ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactUsController>(
        init: ContactUsController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Form(
                key: logic.contactUs,
                child: Column(
                  children: [buildAppBar(), buildForm(context, logic)],
                ),
              ),
            ),
          );
        });
  }

  Widget buildHowToContact(BuildContext context, ContactUsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'How to contact you',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666)),
          ),
        ],
      ),
    );
  }

  Widget buildForm(BuildContext context, ContactUsController logic) {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            children: [
              buildSubjectField(context, logic),
              buildNameField(context, logic),
              buildEmailField(context, logic),
              buildPhoneField(context, logic),
              buildMessageField(context, logic),
              buildHowToContact(context, logic),
              buildEmailAndPhoneButtons(context, logic),
              buildSubmitButton(context, logic)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmailField(BuildContext context, ContactUsController logic) {
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
                      final emailPattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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

  Widget buildNameField(BuildContext context, ContactUsController logic) {
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

  Widget buildSubjectField(BuildContext context, ContactUsController logic) {
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

  Widget buildPhoneField(BuildContext context, ContactUsController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Your Phone Number',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(width: 5),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            height: 80,
            width: double.infinity,
            child: IntlPhoneField(
              enabled: true,
              flagsButtonPadding: EdgeInsets.only(left: 10),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 10),
                      Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              initialCountryCode: 'GB',
              controller: logic.phoneController,
              showDropdownIcon: true,
              dropdownTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              keyboardType: TextInputType.phone,
              style: TextStyle(color: AppColors.appPrimaryBlackColor),
              onChanged: (phone) {
                // Update the selected country code whenever it changes
                logic.selectedCountryCode.value = phone.countryCode;
                 logic.fullPhoneNumber =
                    '${logic.selectedCountryCode.value}${logic.phoneController.text}';

                print('Full Phone Number: ${logic.fullPhoneNumber}');
              },
              validator: (value) {
                if (value == null || value.completeNumber.isEmpty) {
                  return 'Phone number cannot be empty';
                }
                if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.number)) {
                  return 'Enter a valid phone number (10-15 digits)';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, ContactUsController logic) {
    return Obx(() => InkWell(
          onTap: () {
            // Now call sendData where the phone number will be fully updated
            logic.sendData();
          },
          child: Container(
              margin: EdgeInsets.only(top: 40, right: 20, bottom: 20),
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
      'Contact Us',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildEmailAndPhoneButtons(
      BuildContext context, ContactUsController logic)
  {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  logic.emailOption.value = true;
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Color(0xFFEDEDED),
                            ),
                          ),
                          child: logic.emailOption.value == true
                              ? Container(
                                  margin: EdgeInsets.all(5),
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Color(0xFFEDEDED),
                                      ),
                                      color: Color(0xFFB7A06A)))
                              : Container()),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Email',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  logic.emailOption.value = false;
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Color(0xFFEDEDED),
                            ),
                          ),
                          child: logic.emailOption.value == false
                              ? Container(
                                  margin: EdgeInsets.all(5),
                                  height: 25,
                                  width: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: Color(0xFFEDEDED),
                                      ),
                                      color: Color(0xFFB7A06A)))
                              : Container()),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Phone Number',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildMessageField(BuildContext context, ContactUsController logic) {
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
}
