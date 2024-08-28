import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constant/AppColors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final String dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
      'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
      'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
      'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
      'id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
      'Nulla dui. Fusce feugiat malesuada odio. Morbi nunc odio, gravida at, cursus nec, '
      'luctus a, lorem. Maecenas tristique orci ac sem. Duis ultricies pharetra magna. '
      'Donec accumsan malesuada orci. Donec sit amet eros. Lorem ipsum dolor sit amet, '
      'consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
      'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
      'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
      'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
      'id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
      'Nulla dui. Fusce feugiat malesuada odio. Morbi nunc odio, gravida at, cursus nec, '
      'luctus a, lorem. Maecenas tristique orci ac sem. Duis ultricies pharetra magna. '
      'Donec accumsan malesuada orci. Donec sit amet eros. Lorem ipsum dolor sit amet, '
      'consectetur adipiscing elit.'
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
      'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
      'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
      'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
      'id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
      'Nulla dui. Fusce feugiat malesuada odio. Morbi nunc odio, gravida at, cursus nec, '
      'luctus a, lorem. Maecenas tristique orci ac sem. Duis ultricies pharetra magna. '
      'Donec accumsan malesuada orci. Donec sit amet eros. Lorem ipsum dolor sit amet, '
      'consectetur adipiscing elit.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      buildHeadingText(),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          dummyText,
                          style: TextStyle(
                              color: Color(0xFF797E86),
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeadingText() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'OUR STORY',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.appPrimaryBlackColor),
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
      'About Us',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
