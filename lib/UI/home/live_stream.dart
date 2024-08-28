import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opatra/constant/AppColors.dart';

class LiveStream extends StatefulWidget {
  const LiveStream({super.key});

  @override
  State<LiveStream> createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  final String dummyTextShort =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              buildAppBar(),
              Expanded(
                  child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      buildProductListViewForVideos(),
                      buildHeading(),
                      buildViewsAndLikesRow(),
                      buildDescription(),
                      buildReviewsList(),
                      SizedBox(height: MediaQuery.of(context).size.height / 8),
                    ],
                  ),
                ),
              ))
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width:
                  MediaQuery.of(context).size.width, // Full width of the screen
              height: MediaQuery.of(context).size.height /
                  8, // Adjust the height as needed
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.appGrayColor),
                color: Colors.white, // Background color for the container
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // The spread radius
                    blurRadius: 8, // The blur radius
                    offset: Offset(0, 4), // The position of the shadow
                  ),
                ],
              ),

              child: buildCommentField(),
            ),
          ),
        ],
      )),
    );
  }

  Widget buildReviewsList() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: List.generate(10, (index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFFBF3D7),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/profileImage.png',
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Alex Jordan',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    dummyTextShort,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: AppColors.appPrimaryBlackColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildDescription() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        dummyTextShort,
        style: TextStyle(
            color: Color(0xFF797E86),
            fontWeight: FontWeight.w500,
            fontSize: 12),
      ),
    );
  }

  Widget buildViewsAndLikesRow() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFFBF3D7),
                borderRadius: BorderRadius.circular(20)),
            height: 30,
            width: 60,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/profileIcon.png',
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '124 K',
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appPrimaryBlackColor),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFFBF3D7),
                borderRadius: BorderRadius.circular(20)),
            height: 30,
            width: 60,
            child: Container(
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/likeIcon.png',
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '124 K',
                    style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appPrimaryBlackColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildHeading() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'COLLAGEN MASK',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.appPrimaryBlackColor),
          ),
        ],
      ),
    );
  }

  Widget buildCommentField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                hintText: 'Comment Here',
                hintStyle: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
                suffixIcon: Container(
                  height: 10, // Specific height
                  width: 10, // Specific width
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/images/sendIcon.png', // Adjust the image within the container
                    ),
                  ),
                ),
              ),
            ),
          )
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
          buildSideBarOption(),
          Spacer(),
          buildName(),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildSideBarOption() {
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
          child: Image.asset('assets/images/arrowLeft.png'),
        ),
      ],
    );
  }

  Widget buildName() {
    return const Text(
      'Live Stream',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildProductListViewForVideos() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          // Adjusting width to account for left and right margins
          double containerWidth = MediaQuery.of(context).size.width - 40;

          return Container(
            margin: EdgeInsets.only(top: 20),
            width: containerWidth,
            decoration: BoxDecoration(
              color: AppColors.appPrimaryBlackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image.asset(
                //   'assets/images/skinCareDummy.png',
                //   width: containerWidth,
                //   fit: BoxFit.cover,
                // ),
                Image.asset(
                  'assets/images/videoIcon.png',
                  height: 40,
                  width: 40,
                ),
                Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.appWhiteColor,
                          borderRadius: BorderRadius.circular(20)),
                      height: 20,
                      width: 60,
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/profileIcon.png',
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '124 K',
                              style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appPrimaryBlackColor),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}
