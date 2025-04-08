import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/constant/AppColors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opatra/constant/AppLinks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/NotifcationModel.dart';
import 'notifications_logic.dart';


class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the NotificationController instance
    final NotificationController notificationController =
    Get.put(NotificationController());

    // Fetch notifications when the screen is loaded
    notificationController.fetchNotifications();

    return Scaffold(
      backgroundColor: AppColors.appPrimaryWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            Expanded(
              child: Obx(() {
                // Observing the loading state
                if (notificationController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                // Display error if there's any
                if (notificationController.error.value.isNotEmpty) {
                  return Center(
                      child:
                      Text("Error: ${notificationController.error.value}"));
                }

                // Display a message if there are no notifications
                if (notificationController.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      "No notifications found",
                      style: TextStyle(
                        color: AppColors.appPrimaryColor,
                        fontSize: 20,
                      ),
                    ),
                  );
                }

                // Display notifications
                return ListView.builder(
                  itemCount: notificationController.notifications.length,
                  itemBuilder: (context, index) {
                    final notification =
                    notificationController.notifications[index];
                    return buildNotificationCard(notification);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationCard(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFFBF3D7)),
      ),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            buildImage(),
            SizedBox(width: 20),
            buildNameAndTime(notification),
          ],
        ),
      ),
    );
  }

  Widget buildNameAndTime(NotificationModel notification) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 260,
          child: Text(
            notification.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          notification.createdAt,
          style: TextStyle(
            color: Color(0xFFAAAAAA),
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFFFFFF),
      ),
      height: 50,
      width: 50,
      child: Image.asset('assets/images/app_logo.png'),
    );
  }

  // App Bar
  Widget buildAppBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Row(
        children: [
          buildBackOption(),
          Spacer(),
          buildName(),
          Spacer(),
          Container(),
          Spacer(),
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

