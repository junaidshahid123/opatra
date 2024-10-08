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
      'Opatra London is a British brand internationally acclaimed for our customer-orientated approach and global prominence within the skincare industry.\n\n'
      'Our contemporary way of perceiving beauty and skincare has allowed us to incorporate cutting-edge technology for deeply nourishing skincare products.\n\n'
      'One of our visions is to redefine antiquated beauty standards, and attempt to find consistent and achievable outcomes for all skin types.\n\n'
      'Based on this ethos, Opatra has created a unique and versatile range of products and devices ideal for all skin types.\n\n'
      'We transform scientific breakthroughs and technological innovations into potent skincare solutions.\n\n'
      'Since 2010, we have been pioneering easy-to-use devices and skincare formulations that help all skin types look firmer, younger, brighter, and more beautiful.\n\n'
      'We develop, design, and source ground-breaking skin care devices and skincare products for both professional and at-home use.\n\n'
      'Our effective products are specially formulated for the skin\'s daily care, and are used by professionals in beauty salons, spas, and aesthetics clinics, and are available to both the professional and consumer market.\n\n'
      'Our product lines include handheld anti-aging devices, skincare formulations, professional facial and body equipment, and accessories.';

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
