import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/UI/home/warranty_claim.dart';
import 'package:opatra/constant/AppColors.dart';

class Treatment1 extends StatefulWidget {
  @override
  _Treatment1State createState() => _Treatment1State();
}

class _Treatment1State extends State<Treatment1> {
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
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/faceIcon.jpg',
                fit: BoxFit
                    .cover, // Ensures the image covers the whole background
              ),
            ),
            // Container with curved top corners
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context)
                    .size
                    .width, // Full width of the screen
                height: MediaQuery.of(context).size.height /
                    3, // Adjust the height as needed
                decoration: BoxDecoration(
                  color: Colors.white, // Background color for the container
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    buildSelectYourTreatmentAreas(),
                    buildList(),
                    buildTime(),
                    buildContinueButton()
                  ],
                ),
              ),
            ),
            Positioned(top: 20, left: 20, child: buildBackOption())
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    return Container(
      margin: EdgeInsets.only(top: 2),
      child: Text(
        '14:00',
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.appPrimaryBlackColor),
      ),
    );
  }

  Widget buildList() {
    return Container(
      height: 100,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              // Use GetX or Obx to wrap only the part that needs to be reactive
              return Obx(
                () {
                  final bool isSelected = selectedIndices.contains(index);
                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        selectedIndices.remove(index);
                      } else {
                        selectedIndices.add(index);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Color(0xFFB7A06A)
                            : Colors.transparent,
                        border: Border.all(
                          color: Color(0xFFC9CBCF),
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 20,
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            })
      ]),
    );
  }

  Widget buildSelectYourTreatmentAreas() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        'Please select your treatment\nareas',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: AppColors.appPrimaryBlackColor),
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

  Widget buildContinueButton() {
    return InkWell(
      onTap: () {
        // Get.to(() => Treatment1());
      },
      child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Continue',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
    );
  }
}
