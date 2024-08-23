import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:opatra/UI/home/ask_our_experts.dart';
import 'package:opatra/UI/home/product_detail.dart';
import 'package:opatra/UI/home/register_your_own_product.dart';
import 'package:opatra/UI/home/warranty_claim.dart';
import 'package:opatra/constant/AppColors.dart';

import 'contact_us.dart';

class BottomBarHost extends StatefulWidget {
  const BottomBarHost({super.key});

  @override
  State<BottomBarHost> createState() => _BottomBarHost();
}

class _BottomBarHost extends State<BottomBarHost> {
  RxBool home = true.obs;
  RxBool product = true.obs;
  RxBool video = true.obs;
  RxInt selectedCategory = 0.obs;
  RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home.value = true;
    product.value = false;
    video.value = false;
    selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height /
                          4, // Adjust this value as needed
                    ),
                    child: Column(
                      children: [
                        Obx(
                          () => home.value == true
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height / 2.2,
                                  margin: EdgeInsets.only(top: 20),
                                  width: MediaQuery.of(context).size.width,
                                  child: CenteredExpandingPageView())
                              : Container(),
                        ),
                        Obx(
                          () => home.value == true
                              ? buildHeadingTextForHome()
                              : Container(),
                        ),
                        Obx(() => home.value == true
                            ? buildHomeProductListView()
                            : video.value == true
                                ? buildProductListViewForVideos()
                                : buildProductListView()),
                        Obx(
                          () => video.value == true
                              ? buildSearchField()
                              : Container(),
                        ),
                        Obx(
                          () => product.value == true
                              ? buildSearchField()
                              : Container(),
                        ),
                        Obx(
                          () => product.value || video.value == true
                              ? buildCategories()
                              : Container(),
                        ),
                        Obx(
                          () => product.value == true
                              ? Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Popular Products',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppColors.appPrimaryBlackColor,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                        Obx(
                          () => product.value == true
                              ? buildProductListViewPopular()
                              : Container(),
                        ),
                        Obx(
                          () => product.value == true
                              ? Container(
                                  margin: EdgeInsets.only(left: 20, top: 20),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Recent Products',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color:
                                                AppColors.appPrimaryBlackColor,
                                            fontSize: 20),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                        ),
                        Obx(
                          () => product.value == true
                              ? buildProductListViewRecent()
                              : Container(),
                        ),
                        Obx(() =>
                            video.value == true ? buildGridView() : Container())
                      ],
                    ),
                  ),
                ),
              ],
            ),
            buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.appWhiteColor,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logoForSideDrawer.png',
                    height: 100,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
              buildOptions()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptions() {
    return Obx(() => Column(
          children: [
            buildTreatmentOption(),
            buildLiveStreamOption(),
            buildAskOurExpertsOption(),
            buildAboutUsOption(),
            buildContactUsOption(),
            buildRegisterYourProductOption(),
            buildWarrantyClaimsOption(),
            buildSocialOptions()
          ],
        ));
  }

  Widget buildSocialOptions() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [buildFbOption(), buildInstaOption(), buildTwitterOption()],
      ),
    );
  }

  Widget buildFbOption() {
    return Container(
      // margin: EdgeInsets.only(left: 20,),
      child: Row(
        children: [
          Image.asset(
            'assets/images/fcIcon.png',
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Facebook',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFFB7A06A)),
          )
        ],
      ),
    );
  }

  Widget buildInstaOption() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/instaIcon.png',
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Instagram',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFFB7A06A)),
          )
        ],
      ),
    );
  }

  Widget buildTwitterOption() {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/twitterIcon.png',
            height: 25,
            width: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Twitter',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Color(0xFFB7A06A)),
          )
        ],
      ),
    );
  }

  Widget buildWarrantyClaimsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 6;
        Get.to(() => WarrantyClaim());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 6
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 6
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Warranty Claims',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 6
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterYourProductOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 5;
        Get.to(() => RegisterYourOwnProduct());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 5
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 5
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Register Your Product',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 5
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactUsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 4;
        Get.to(() => ContactUs());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 4
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 4
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Contact Us',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 4
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutUsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 3;
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 3
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 3
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(
            left: 20,
          ),
          child: Row(
            children: [
              Text(
                'About Us',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 3
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAskOurExpertsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 2;
        Get.to(() => AskOurExperts());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 2
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 2
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Ask Our Experts',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 2
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTreatmentOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 0;
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 0
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 0
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Treatment',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 0
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLiveStreamOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 1;
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 1
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 1
                ? Color(0xFFB7A06A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10)),
        height: 45,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Live Stream',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 1
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridView() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        height: MediaQuery.of(context).size.height, // Maintain height
        width: MediaQuery.of(context).size.width, // Maintain width
        child: GridView.builder(
          shrinkWrap: true,
          // Makes the GridView content take up only as much space as needed
          physics: NeverScrollableScrollPhysics(),
          // Disable GridView's own scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 20.0, // Space between columns
            mainAxisSpacing: 20.0, // Space between rows
            childAspectRatio: 1.2, // Adjust aspect ratio if needed
          ),
          itemCount: 10,
          // Number of items in the grid
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.appGrayColor,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/images/skinCareDummy.png',
                      fit: BoxFit.fill),
                  Image.asset('assets/images/videoIcon.png',
                      height: 30, width: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCategories() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          // Adjusting width to account for left and right margins
          double containerWidth = MediaQuery.of(context).size.width - 40;

          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              selectedCategory.value = index;
            },
            child: Obx(
              () => Container(
                  margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                  width: 60,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: selectedCategory.value == index
                              ? Colors.transparent
                              : Color(0xFFFBF3D7)),
                      borderRadius: BorderRadius.circular(20),
                      color: selectedCategory.value == index
                          ? Color(0xFFB7A06A)
                          : Colors.transparent),
                  child: Center(
                      child: Text(
                    'All',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: selectedCategory.value == index
                            ? AppColors.appWhiteColor
                            : AppColors.appPrimaryBlackColor),
                  ))),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFBF3D7)),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search Here',
          hintStyle: TextStyle(color: Colors.grey),
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset('assets/images/seachIcon.png'),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.appWhiteColor,
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
          buildSideBarOption(context),
          Spacer(),
          buildName(),
          Spacer(),
          buildNotificationOption()
        ],
      ),
    );
  }

  Widget buildSideBarOption(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
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
                child: Image.asset('assets/images/menuLines.png'),
              ),
            ],
          ),
        );
      },
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
    return Obx(() => home.value == true
        ? Text(
            'Hello Marta',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333)),
          )
        : product.value == true
            ? const Text(
                'All Products',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333)),
              )
            : const Text(
                'Videos',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333)),
              ));
  }

  Widget buildBottomBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFB7A06A),
      ),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Spacer(),
          buildHomeOption(),
          Spacer(),
          buildProductOption(),
          Spacer(),
          buildVideoOption(),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildHomeOption() {
    return InkWell(
        onTap: () {
          home.value = true;
          product.value = false;
          video.value = false;
        },
        child: Obx(() => Container(
              margin: EdgeInsets.only(bottom: 2, top: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: home.value == true
                      ? AppColors.appWhiteColor
                      : Colors.transparent),
              height: 30,
              child: Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
                child: Row(
                  children: [
                    Container(
                        height: 16.5,
                        width: 16.5,
                        child: Image.asset(
                          'assets/images/homeIcon.png',
                          color: home.value == true
                              ? AppColors.appPrimaryBlackColor
                              : AppColors.appWhiteColor,
                        )),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: home.value == true
                              ? AppColors.appPrimaryBlackColor
                              : AppColors.appWhiteColor),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget buildProductOption() {
    return InkWell(
        onTap: () {
          home.value = false;
          product.value = true;
          video.value = false;
        },
        child: Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: 2, top: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: product.value == true
                    ? AppColors.appWhiteColor
                    : Colors.transparent),
            height: 30,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
              child: Row(
                children: [
                  Container(
                      height: 16.5,
                      width: 16.5,
                      child: Image.asset('assets/images/productIcon.png',
                          color: product.value == true
                              ? AppColors.appPrimaryBlackColor
                              : AppColors.appWhiteColor)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Product',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: product.value == true
                            ? AppColors.appPrimaryBlackColor
                            : AppColors.appWhiteColor),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildVideoOption() {
    return InkWell(
        onTap: () {
          home.value = false;
          product.value = false;
          video.value = true;
        },
        child: Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: 2.sp, top: 2.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: video.value == true
                    ? AppColors.appWhiteColor
                    : Colors.transparent),
            height: 30,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 2, top: 2),
              child: Row(
                children: [
                  Container(
                      height: 16.5,
                      width: 16.5,
                      child: Image.asset('assets/images/video.png',
                          color: video.value == true
                              ? AppColors.appPrimaryBlackColor
                              : AppColors.appWhiteColor)),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Video',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: video.value == true
                            ? AppColors.appPrimaryBlackColor
                            : AppColors.appWhiteColor),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildHeadingTextForHome() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: const Text(
              'Best-Selling Skincare',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
            ),
          ),
          Text(
            'see all',
            style: TextStyle(
                color: Color(0xFFB7A06A),
                fontWeight: FontWeight.w600,
                fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget buildHomeProductListView() {
    return Container(
      height: 150,
      // color: AppColors.languageArBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.to(() => ProductDetailScreen());
            },
            child: Container(
              // height: 200,
              width: 150,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                // color: AppColors.appPrimaryBlackColor,
                border: Border.all(color: Color(0xFFFBF3D7), width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Image.asset('assets/images/skinCareDummy.png',
                      height: 50, width: 50, fit: BoxFit.cover),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'COLLAGEN MASK',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appPrimaryBlackColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              '\$374.00 USD',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appPrimaryBlackColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildProductListView() {
    return Container(
      // color: AppColors.appGrayColor,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          // Adjusting width to account for left and right margins
          double containerWidth = MediaQuery.of(context).size.width - 40;

          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            width: containerWidth,
            decoration: BoxDecoration(
              color: AppColors.appPrimaryBlackColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/skinCareDummy.png',
                  width: containerWidth,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        // Semi-transparent background color
                        padding: EdgeInsets.all(10),
                        // Padding inside the container
                        child: Text(
                          'New product for your skin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors
                                .white, // White text color for better contrast
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xFFB7A06A),
                        ),
                        child: Center(
                          child: Text(
                            'Shop now',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProductListViewForVideos() {
    return Container(
      color: AppColors.appGrayColor,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          // Adjusting width to account for left and right margins
          double containerWidth = MediaQuery.of(context).size.width - 40;

          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                  'assets/images/batteryChargingIcon.png',
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

  Widget buildProductListViewPopular() {
    return Container(
      height: 150,
      // color: AppColors.languageArBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            // height: 200,
            width: 150,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              // color: AppColors.appPrimaryBlackColor,
              border: Border.all(color: Color(0xFFFBF3D7), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset('assets/images/skinCareDummy.png',
                    height: 50, width: 50, fit: BoxFit.cover),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'COLLAGEN MASK',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appPrimaryBlackColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '\$374.00 USD',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appPrimaryBlackColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProductListViewRecent() {
    return Container(
      height: 150,
      // color: AppColors.languageArBackgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            // height: 200,
            width: 150,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              // color: AppColors.appPrimaryBlackColor,
              border: Border.all(color: Color(0xFFFBF3D7), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Image.asset('assets/images/skinCareDummy.png',
                    height: 50, width: 50, fit: BoxFit.cover),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'COLLAGEN MASK',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appPrimaryBlackColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '\$374.00 USD',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.appPrimaryBlackColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          );
        },
      ),
    );
  }
}

class CenteredExpandingPageView extends StatefulWidget {
  @override
  _CenteredExpandingPageViewState createState() =>
      _CenteredExpandingPageViewState();
}

class _CenteredExpandingPageViewState extends State<CenteredExpandingPageView> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: 10,
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (context, index) {
        bool isCurrent = index == _currentIndex;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(
              horizontal: isCurrent ? 10 : 20, vertical: isCurrent ? 5 : 20),
          // height: isCurrent ? 300 : 180,
          width: isCurrent
              ? MediaQuery.of(context).size.width * 0.95
              : MediaQuery.of(context).size.width * 0.95,
          decoration: BoxDecoration(
            color: isCurrent ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isCurrent
                ? [BoxShadow(color: Colors.black26, blurRadius: 10)]
                : [],
          ),
          child: Center(
            child: Text(
              'Item $index',
              style: TextStyle(
                color: Colors.white,
                fontSize: isCurrent ? 24 : 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
