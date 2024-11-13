import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/constant/AppColors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opatra/constant/AppLinks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/NotifcationModel.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

// Function to fetch user notifications
Future<List<NotificationModel>> getNotifications() async {
  // Retrieve token from SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Get the token from shared prefs

  Map<String, String> headers = {
    "Accept": "application/json",
    "Authorization": "Bearer $token", // Include the Bearer token in headers
  };
  final response = await http.get(
      Uri.parse(ApiUrls.userNotifications),
      headers: headers);

  if (response.statusCode == 200) {
    // Parse the JSON response
    final data = json.decode(response.body);

    // Check if API returned success
    if (data['success']) {
      List<dynamic> notificationsJson = data['data'];

      // Map JSON to list of NotificationModel
      return notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  } else {
    throw Exception('Failed to connect to the API');
  }
}

late Future<List<NotificationModel>> notifications;

@override
void initState() {
  // Fetch notifications when the screen is loaded
  notifications = getNotifications();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.appPrimaryWhiteColor,
      body: SafeArea(
        child: FutureBuilder<List<NotificationModel>>(
          future: getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No notifications found"));
            }

            // Display notifications
            return Column(
              children: [
                buildAppBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final notification = snapshot.data![index];
                      return buildNotificationCard(notification);
                    },
                  ),
                ),
              ],
            );
          },
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
