import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/select_device.dart';
import 'package:opatra/constant/AppColors.dart';

class Treatment extends StatefulWidget {
  const Treatment({super.key});

  @override
  State<Treatment> createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  @override
  Widget build(BuildContext context) {
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
                    children: [buildText(), buildSelectDeviceButton()],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildSelectDeviceButton() {
    return InkWell(
      onTap: () {
        Get.to(() => SelectDevice());
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

  Widget buildText() {
    return Text(
      "You don't have any selected\ndevice",
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xFF333333)),
      textAlign: TextAlign
          .center, // Optional: To center the text horizontally within the text widget
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
      'Treatment',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
