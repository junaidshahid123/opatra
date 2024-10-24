import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment/treatment_logic.dart';
import 'package:opatra/constant/AppColors.dart';

class TreatmentView extends StatelessWidget {
  const TreatmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TreatmentController>(
        init: TreatmentController(),
        builder: (logic) {
          return Scaffold(
              backgroundColor: AppColors.appWhiteColor,
              body: SafeArea(
                child: Column(
                  children: [
                    buildAppBar(),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildText(logic),
                            buildSelectDeviceButton(context, logic)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        });
  }

  Widget buildSelectDeviceButton(
      BuildContext context, TreatmentController logic) {
    return InkWell(
      onTap: () {
        logic.onSelectDeviceTap();
      },
      child: Container(
          margin: EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width / 3,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Select Device',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFFFFFFFF)),
            ),
          )),
    );
  }

  Widget buildText(TreatmentController logic) {
    return Obx(() {
      // Check if the stored device is available
      if (logic.storedDevice.value != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Load image from the model's imageUrl property
            Image.network(
              logic.storedDevice.value!.image!.src ?? '', // Load from model
              width: 100, // Set appropriate width
              height: 100, // Set appropriate height
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.broken_image,
                    size: 100); // Default icon if loading fails
              },
            ),
            SizedBox(height: 10), // Add space between image and text
            Text(
              'Selected Device: ${logic.storedDevice.value!.title}',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Default image or icon if no device is selected
            Icon(
              Icons.devices, // Default icon
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 10), // Add space between image and text
            Text(
              "You don't have any selected\ndevice",
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFF333333)),
              textAlign: TextAlign.center,
            ),
          ],
        );
      }
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
          buildSideBarOption(),
          Spacer(),
          buildName(),
          Spacer(),
          Container(),
          Spacer()
        ],
      ),
    );
  }

  Widget buildSideBarOption() {
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

  Widget buildName() {
    return Text(
      'Treatment',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
