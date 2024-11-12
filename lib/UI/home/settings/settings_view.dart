import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/UI/auth/signup/signup_view.dart';
import 'package:opatra/UI/home/settings/settings_logic.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../about_us.dart';
import '../contact_us/contact_us_view.dart';
import '../edit_profile/edit_profile_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
                child: Column(
              children: [buildAppBar(), buildOptions(logic, context)],
            )),
          );
        });
  }

  Widget buildOptions(SettingsController logic, BuildContext context) {
    return Obx(() => Expanded(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Column(
                  children: [
                    // buildProfileImage(logic),
                    buildEditProfileOption(logic, context),
                    // buildCurrencyOption(logic, context),
               //     buildChangePasswordOption(logic, context),
                    buildAboutUsOption(logic, context),
                    buildContactUsOption(logic, context),
                    buildLogOutOption(logic, context),
                    buildLDeleteOption(logic, context)
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildProfileImage(SettingsController logic) {
    return GestureDetector(
      //  onTap: () => logic.showImageSourceDialog(logic),
      child: Obx(() {
        // Check if an image is selected
        if (logic.selectedImage.value.isNotEmpty) {
          return Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: AppColors.appPrimaryColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    File(logic.selectedImage.value),
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: GestureDetector(
                    onTap: () {
                      logic.selectedImage.value = ''; // Clear the image
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Default profile image container
        return Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: AppColors.appPrimaryColor,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'Upload Profile Image',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildEditProfileOption(
      SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 1;
        Get.to(()=>EditProfileView());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 1
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 1
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 1
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChangePasswordOption(
      SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 3;
        // Get.to(() => ContactUsView());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 3
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 3
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Change Password',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 3
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLDeleteOption(SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.showDeleteAccountDialog(context);
        logic.selectedIndex.value = 7;
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 7
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 7
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Delete Account',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 7
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogOutOption(SettingsController logic, BuildContext context) {
    return FutureBuilder<bool>(
      future: _getGuestStatus(), // Call an async method to get the guest status
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // You can show a loading indicator while waiting
        }

        if (!snapshot.hasData) {
          return SizedBox(); // You can return a fallback widget if there's no data
        }

        bool isGuest = snapshot.data ?? false; // Default to false if data is null

        return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            if (isGuest) {
              logic.selectedIndex.value = 6;

              Get.to(() => SignupView()); // Navigate to Register page if guest
            } else {
              logic.selectedIndex.value = 6;
              logic.showLogoutDialog(context); // Show logout dialog for non-guest users
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: logic.selectedIndex.value == 6
                    ? Colors.transparent
                    : Color(0xFFFBF3D7),
              ),
              color: logic.selectedIndex.value == 6
                  ? Color(0xFFB7A06A)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 45,
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text(
                    isGuest ? 'Log In' : 'Log Out', // Change text based on guest status
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: logic.selectedIndex.value == 6
                          ? AppColors.appWhiteColor
                          : Color(0xFFB7A06A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// This method retrieves the guest status from SharedPreferences
  Future<bool> _getGuestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_guest') ?? false; // Return false if no value is found
  }

  Widget buildContactUsOption(SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 5;
        Get.to(() => ContactUsView());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 5
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 5
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 5
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutUsOption(SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 4;
        Get.to(() => AboutUs());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 30,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 4
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 4
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(
            left: 20,
          ),
          child: Row(
            children: [
              Text(
                'About Us',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 4
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrencyOption(SettingsController logic, BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 2;
        logic.showDialogForCurrency(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 2
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 2
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                logic.selectedCurrency.value.isNotEmpty
                    ? logic.selectedCurrency.value
                    : 'Select Currency',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 2
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
              SizedBox(
                width: 10,
              ),
              logic.selectedCurrency.value.isNotEmpty
                  ? Text(
                      '(Tap To Change)',
                      style: TextStyle(
                          color: logic.selectedIndex.value == 2
                              ? AppColors.appWhiteColor
                              : Color(0xFFB7A06A),
                          fontSize: 12),
                    )
                  : Container()
            ],
          ),
        ),
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
      'Settings',
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
