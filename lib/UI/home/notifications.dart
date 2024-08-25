import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:opatra/constant/AppColors.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [buildAppBar(), buildListOfNotifications()],
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
          Container(),
          Spacer()
        ],
      ),
    );
  }

  Widget buildName() {
    return Text(
      'Notifications',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildListOfNotifications() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFFBF3D7))),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [buildImage(), buildNameAndTime()],
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget buildNameAndTime() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'COLLAGEN MASK IS ON 40% OFF',
                style: TextStyle(
                    color: AppColors.appPrimaryBlackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                '4:45 Am',
                style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFFBF3D7)),
      height: 50,
      width: 50,
      child: Image.asset('assets/images/skinCareDummy.png'),
    );
  }

  Widget buildBackOption() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          Stack(
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
        ],
      ),
    );
  }
}
