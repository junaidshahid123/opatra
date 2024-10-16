import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/constant/AppColors.dart';

class Treatment2 extends StatefulWidget {
  @override
  _Treatment2State createState() => _Treatment2State();
}

class _Treatment2State extends State<Treatment2> {
  RxBool isVideoPlaying = false.obs;
  final RxList<int> selectedIndices = <int>[].obs;
  final String dummyTextShort =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ';

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
                    buildTimeAndVideoIcon(),
                    buildDescription(),
                    Spacer(),
                    buildNextButton()
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

  Widget buildDescription() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Text(
        dummyTextShort,
        style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF797E86)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTimeAndVideoIcon() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '14:00 Min',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.appPrimaryBlackColor),
          ),
          SizedBox(
            width: 10,
          ),
          Obx(() => InkWell(
                onTap: () {
                  isVideoPlaying.value = !isVideoPlaying.value;
                },
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFFBF3D7)),
                    height: 30,
                    width: 30,
                    child: Container(
                        margin: EdgeInsets.all(5),
                        child: isVideoPlaying.value == true
                            ? Image.asset('assets/images/pauseIcon.png')
                            : Image.asset('assets/images/playIcon.png'))),
              ))
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

  Widget buildNextButton() {
    return InkWell(
      onTap: () {
        // Get.to(() => Treatment1());
      },
      child: Container(
          margin: EdgeInsets.only( bottom: 20, left: 20, right: 20),
          width: MediaQuery.of(context).size.width,
          height: 45,
          decoration: BoxDecoration(
            color: Color(0xFFB7A06A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          )),
    );
  }
}
