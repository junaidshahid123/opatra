import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:opatra/UI/home/edit_profile/edit_profile_logic.dart';

import '../../../constant/AppColors.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProfileController>(
        init: EditProfileController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Form(
                key: logic.editProfile,
                child: Column(
                  children: [buildAppBar(), buildForm(context, logic)],
                ),
              ),
            ),
          );
        });
  }
  Widget buildEmailField(BuildContext context, EditProfileController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 65, // Fixed height to include space for potential error
            child: TextFormField(
              style: TextStyle(color: AppColors.appPrimaryBlackColor),
              controller: logic.emailController,
              decoration: InputDecoration(
                labelText: 'Your Email *',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    color: Colors.red, // Red border for validation errors
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // Red border when focused and error exists
                    width: 1.5,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.red, // Red color for the error message
                  fontSize: 12, // Optional: Adjust the error message text size
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email cannot be empty';
                }
                // Additional check for valid email format
                final emailPattern =
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                final regex = RegExp(emailPattern);
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null; // No error if input is valid
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameField(BuildContext context, EditProfileController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use a TextFormField with labelText instead of a separate label.
          Container(
            height: 65, // Fixed height to include space for potential error
            child: TextFormField(
              style: TextStyle(color: AppColors.appPrimaryBlackColor),
              controller: logic.nameController,
              decoration: InputDecoration(
                labelText: 'Your Name *', // Label combined with the asterisk
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                    color: Colors.red, // Red border for validation errors
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, // Red border when focused and error exists
                    width: 1.5,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.red, // Red color for the error message
                  fontSize: 12, // Optional: Adjust the error message text size
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
        ],
      ),
    );
  }


  Widget buildForm(BuildContext context, EditProfileController logic) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          children: [
            buildNameField(context, logic),
            buildPhoneField(context, logic),
            Spacer(),
            buildSubmitButton(context,logic)
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context, EditProfileController logic) {
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
                'Save',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ))),
    ));
  }


  Widget buildPhoneField(BuildContext context, EditProfileController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            child: IntlPhoneField(
              enabled: true,
              flagsButtonPadding: EdgeInsets.only(left: 10),
              decoration: InputDecoration(
                labelText: 'Your Phone Number *',
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
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
                  child: Icon(
                    Icons.phone,
                    color: Colors.black,
                    size: 20,
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

  Widget buildName() {
    return const Text(
      'Edit Profile',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
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
}
