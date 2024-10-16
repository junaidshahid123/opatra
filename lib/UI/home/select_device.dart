import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/AppColors.dart';
import 'create_schedule.dart';

class SelectDevice extends StatefulWidget {
  const SelectDevice({super.key});

  @override
  State<SelectDevice> createState() => _SelectDeviceState();
}

class _SelectDeviceState extends State<SelectDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [buildAppBar(), buildGridView()],
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
      'Select Device',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildGridView() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
        height: MediaQuery.of(context).size.height, // Maintain height
        width: MediaQuery.of(context).size.width, // Maintain width
        child: GridView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 20.0, // Space between columns
            mainAxisSpacing: 20.0, // Space between rows
            childAspectRatio: 0.8, // Adjust aspect ratio if needed
          ),
          itemCount: 10,
          // Number of items in the grid
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(() => CreateSchedule());
              },
              child: Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFBF3D7)),
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.appWhiteColor,
                      ),
                      child: Container(
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Image.asset(
                                    'assets/images/treatmentDeviceIcon.png'),
                              Container(
                                margin: EdgeInsets.only(left: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Device Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color:
                                              AppColors.appPrimaryBlackColor),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
