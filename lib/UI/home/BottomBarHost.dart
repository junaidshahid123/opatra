import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/auth/login/login_view.dart';
import 'package:opatra/UI/home/about_us.dart';
import 'package:opatra/UI/home/bag.dart';
import 'package:opatra/UI/home/contact_us/contact_us_view.dart';
import 'package:opatra/UI/home/product_detail.dart';
import 'package:opatra/UI/home/register_your_own_product.dart';
import 'package:opatra/UI/home/treatment.dart';
import 'package:opatra/UI/home/warranty_claim.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constant/AppLinks.dart';
import '../../controllers/bottom_bar_host_controller.dart';
import '../../models/MDAllVideos.dart';
import '../../models/MDProductsByCategory.dart';
import '../../models/MDVideosByCategory.dart';
import 'ask_ouur_experts/ask_our_experts_view.dart';
import 'live_stream.dart';
import 'notifications.dart';
import 'package:http/http.dart' as http;

class BottomBarHost extends StatefulWidget {
  const BottomBarHost({super.key});

  @override
  State<BottomBarHost> createState() => _BottomBarHost();
}

class _BottomBarHost extends State<BottomBarHost> {
  final BottomBarHostController controller =
      Get.put(BottomBarHostController()); // Initialize the controller
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentIndex = 0;
  RxBool home = true.obs;
  RxBool product = true.obs;
  RxBool video = true.obs;
  RxBool skinCare = true.obs;
  RxBool devices = true.obs;
  RxInt selectedCategoryForSkinCare = 0.obs;
  RxInt selectedCategoryForDevice = 0.obs;
  RxInt selectedCategoryForVideo = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isLoading = false.obs;
  TextEditingController searchTextController = TextEditingController();

// Declare a Timer variable to manage the debounce timing
  Timer? _debounce;

  Future<void> logOut() async {
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.logoutUrl);
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs

    //  Ensure the token exists before proceeding
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Include the Bearer token in headers
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');
        prefs.remove('token');
        Get.snackbar('Success', 'Log Out Successfully');
        Get.offAll(LoginView());
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to log out user';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading spinner
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void _showDialogForCurrency(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFB7A06A),
          child: Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFB7A06A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Select Currency',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appWhiteColor),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.makeUsDollar();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: controller.usd.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: controller.usd.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'US Dollar',
                                    style: TextStyle(
                                      color: controller.usd.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.makeEuro();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: controller.euro.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: controller.euro.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Euro',
                                    style: TextStyle(
                                      color: controller.euro.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.makePound();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: controller.pound.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: controller.pound.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Pound',
                                    style: TextStyle(
                                      color: controller.pound.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home.value = true;
    product.value = false;
    video.value = false;
    selectedIndex.value = -1;
    skinCare.value = true;
    devices.value = false;
    _getUserName();
  }

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ??
        'Guest'; // Default to 'Guest' if no value is found
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /
                      2.5, // Adjusted height for new content
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Are you sure you want to Log Out?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No button
                            InkWell(
                              onTap: () {
                                Get.back(); // Close the dialog
                                selectedIndex.value = -1;
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  // Grey color for "No" button
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Yes button
                            InkWell(
                              onTap: () {
                                // Add your logout functionality here
                                logOut();
                              },
                              child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB7A06A),
                                    // Custom color for "Yes" button
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: isLoading.value == true
                                          ? SizedBox(
                                              width: 20.0, // Adjust the width
                                              height: 20.0, // Adjust the height
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            )
                                          : Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarHostController>(
        init: BottomBarHostController(),
        builder: (BottomBarHostController) {
          return Scaffold(
            drawer: buildDrawer(),
            onDrawerChanged: (isOpened) {
              controller.isCurrencyDropDown.value = false;
            },
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  controller.isCurrencyDropDown.value = false;
                },
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
                                      ? buildLatestProductsTextForHome()
                                      : Container(),
                                ),
                                controller.mdLatestProducts == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.appPrimaryBlackColor,
                                        ),
                                      )
                                    : Obx(
                                        () => home.value == true
                                            ? Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2.6,
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: PageView.builder(
                                                  controller: _controller,
                                                  itemCount: controller
                                                      .mdLatestProducts!
                                                      .products
                                                      .length,
                                                  onPageChanged: (int index) {
                                                    setState(() {
                                                      _currentIndex = index;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, index) {
                                                    bool isCurrent =
                                                        index == _currentIndex;
                                                    return AnimatedContainer(
                                                      duration: Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.easeInOut,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            isCurrent ? 10 : 20,
                                                        vertical:
                                                            isCurrent ? 5 : 20,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.95,
                                                      decoration: BoxDecoration(
                                                        color: isCurrent
                                                            ? Colors.blue
                                                            : Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: isCurrent
                                                            ? [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    blurRadius:
                                                                        10)
                                                              ]
                                                            : [],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        // Clip the image to the container's rounded corners
                                                        child: Stack(
                                                          children: [
                                                            controller
                                                                            .mdLatestProducts!
                                                                            .products[
                                                                                index]
                                                                            .image !=
                                                                        null &&
                                                                    controller
                                                                            .mdLatestProducts!
                                                                            .products[index]
                                                                            .image!
                                                                            .src !=
                                                                        null
                                                                ? Image.network(
                                                                    controller
                                                                        .mdLatestProducts!
                                                                        .products[
                                                                            index]
                                                                        .image!
                                                                        .src!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    // Ensure the image covers the entire container
                                                                    height: double
                                                                        .infinity,
                                                                    // Make the image take up the full container height
                                                                    width: double
                                                                        .infinity, // Make the image take up the full container width
                                                                  )
                                                                : Image.asset(
                                                                    'assets/images/skinCareDummy.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    // Fallback image should also cover the container
                                                                    height: double
                                                                        .infinity,
                                                                    width: double
                                                                        .infinity,
                                                                  ),
                                                            Positioned(
                                                              top: 20,
                                                              left: 20,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    controller
                                                                        .mdLatestProducts!
                                                                        .products[
                                                                            index]
                                                                        .title,
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .appPrimaryBlackColor,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  Text(
                                                                    controller
                                                                        .mdLatestProducts!
                                                                        .products[
                                                                            index]
                                                                        .vendor,
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .appPrimaryBlackColor,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ))
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
                                        ? buildProductListView()
                                        : buildProductListViewForBanners()),
                                Obx(
                                  () => product.value || video.value == true
                                      ? buildSearchField()
                                      : Container(),
                                ),

                                Obx(() => product.value == true
                                    ? buildSkinCareAndDevicesOptions()
                                    : Container()),
                                Obx(
                                  () => product.value == true &&
                                          skinCare.value == true
                                      ? buildSkinCareCategories()
                                      : Container(),
                                ),
                                Obx(
                                  () => product.value == true &&
                                          devices.value == true
                                      ? buildDevicesCategories()
                                      : Container(),
                                ),
                                Obx(() => product.value
                                    ? Obx(() {
                                        // Initially show the default popular products
                                        if (controller.searchQuery.isEmpty &&
                                            controller
                                                .filteredProducts.isEmpty) {
                                          // Populate filteredProducts with popular products if empty
                                          controller.filteredProducts.value =
                                              controller.mdProductsByCategory
                                                      ?.products ??
                                                  [];
                                          // Show the popular products grid view
                                          return buildProductGridViewPopular();
                                        }

                                        // If the controller is loading, show a progress indicator
                                        if (controller.isLoading.value) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        // Check if there are filtered products after the search query
                                        if (controller
                                            .filteredProducts.isNotEmpty) {
                                          // Display filtered products based on the search query
                                          return buildProductGridViewPopularA(
                                              controller.filteredProducts);
                                        }

                                        // If there are no matching products for the search query
                                        else if (controller
                                                .filteredProducts.isEmpty &&
                                            controller.searchQuery.isNotEmpty) {
                                          // No products found, show a message for 5 seconds
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            Timer(Duration(seconds: 3), () {
                                              // Clear the search query and reset the products to popular products
                                              controller.searchQuery.value = '';
                                              searchTextController.clear();
                                              FocusScope.of(context).unfocus();

                                              // Reset the filtered products to the popular products
                                              controller.filteredProducts
                                                  .value = controller
                                                      .mdProductsByCategory
                                                      ?.products ??
                                                  [];

                                              // Ensure loading is false
                                              controller.isLoading.value =
                                                  false;
                                            });
                                          });

                                          // Show the "No products found" message
                                          return Center(
                                            child: Text(
                                              maxLines: 2,
                                              'No products found with this alphabetic query. Try Another.',
                                              style: TextStyle(
                                                  color: AppColors
                                                      .appPrimaryBlackColor),
                                            ),
                                          );
                                        }

                                        // Default to showing popular products if none of the conditions are met
                                        return buildProductGridViewPopular();
                                      })
                                    : Container()),
                                //video heading
                                Obx(
                                      () => video.value == true
                                      ? buildCategoriesForVideos()
                                      : Container(),
                                ),
                                // Inside the Obx that controls showing videos based on selected category
                                Obx(() {
                                  return video.value == true
                                      ? controller.mdVideosByCategory == null
                                      ? Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFB7A06A),
                                    ),
                                  )
                                      : VideoGridWidget(
                                    videos: controller.mdVideosByCategory!.data!.videos!,
                                  )
                                      : Container(); // Empty container if the video value is false
                                }),
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
            ),
          );
        });
  }

  Widget buildSkinCareAndDevicesOptions() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space between the two containers
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                skinCare.value = true;
                devices.value = false;
                controller.fetchProductByCategory(
                    controller.skinCareCategories[0].id!);
              },
              child: Container(
                padding: EdgeInsets.all(5), // Padding inside the container
                decoration: BoxDecoration(
                  border: skinCare.value == true
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: AppColors.appGrayColor),
                  color: skinCare.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    'SKINCARE',
                    style: TextStyle(
                      color: skinCare.value == true
                          ? Colors.white
                          : Color(0xFFB7A06A), // Text color
                      fontSize: 18, // Font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16), // Space between the containers
          Expanded(
            child: InkWell(
              onTap: () {
                skinCare.value = false;
                devices.value = true;
                controller.fetchProductByCategory(
                    controller.devicesCategories[0].id!);
              },
              child: Container(
                padding: EdgeInsets.all(5), // Padding inside the container
                decoration: BoxDecoration(
                  border: devices.value == true
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: AppColors.appGrayColor),
                  color: devices.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'DEVICES',
                    style: TextStyle(
                      color: devices.value == true
                          ? Colors.white
                          : Color(0xFFB7A06A), // Text color
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCurrencyDropDown() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.appPrimaryBlackColor),
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
    return Obx(() => Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  buildCurrencyOption(),
                  buildTreatmentOption(),
                  buildLiveStreamOption(),
                  buildAskOurExpertsOption(),
                  buildAboutUsOption(),
                  buildContactUsOption(),
                  buildRegisterYourProductOption(),
                  buildWarrantyClaimsOption(),
                  buildLogOutOption(),
                  buildSocialOptions()
                ],
              ),
            ],
          ),
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

  Widget buildLogOutOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 8;
        _showLogoutDialog(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 8
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 8
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
                'Log Out',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 8
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWarrantyClaimsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 7;
        Get.to(() => WarrantyClaim());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: selectedIndex.value == 7
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: selectedIndex.value == 7
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
                    color: selectedIndex.value == 7
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
        selectedIndex.value = 6;
        Get.to(() => RegisterYourOwnProduct());
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
                'Register Your Product',
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

  Widget buildContactUsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 5;
        Get.to(() => ContactUsView());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
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
                'Contact Us',
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

  Widget buildAboutUsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 4;
        Get.to(() => AboutUs());
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

  Widget buildAskOurExpertsOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 3;
        Get.to(() => AskOurExpertsView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
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
          margin: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Ask Our Experts',
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

  Widget buildCurrencyOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 0;
        _showDialogForCurrency(context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                controller.selectedCurrency.value.isNotEmpty
                    ? controller.selectedCurrency.value
                    : 'Select Currency',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selectedIndex.value == 0
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
              SizedBox(
                width: 10,
              ),
              controller.selectedCurrency.value.isNotEmpty
                  ? Text(
                      '(Tap To Change)',
                      style: TextStyle(
                          color: selectedIndex.value == 0
                              ? AppColors.appWhiteColor
                              : Color(0xFFB7A06A),
                          fontSize: 12),
                    )
                  : Container()
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
        selectedIndex.value = 1;
        Get.to(() => Treatment());
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Treatment',
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

  Widget buildLiveStreamOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        selectedIndex.value = 2;
        Get.to(() => LiveStream());
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
                'Live Stream',
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

  Widget buildGridView(List<Video> videos) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        height: MediaQuery.of(context).size.height, // Maintain height
        width: MediaQuery.of(context).size.width, // Maintain width
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          // Disable GridView's own scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 20.0, // Space between columns
            mainAxisSpacing: 20.0, // Space between rows
            childAspectRatio: 1.2, // Adjust aspect ratio if needed
          ),
          itemCount: videos.length,
          // Use the length of the videos list
          itemBuilder: (context, index) {
            final video = videos[index]; // Get video object from the list

            return GestureDetector(
              onTap: () {
                // Handle video tap (e.g., navigate to a video player)
                print('Tapped on video: ${video.videoUrl}');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.appGrayColor,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    // Access 'thumbnail' using dot notation
                    video.thumbnail != null
                        ? Image.network(
                     "https://opatra.fai-tech.online/${video.thumbnail}",
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error'); // Add this to debug errors
                        return Icon(Icons.error); // Show error icon if image fails to load
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator()); // Show loader while the image is loading
                      },
                    )

                        : Container(
                            color: Colors
                                .grey, // Default background if thumbnail is missing
                          ),
                    Image.asset(
                      'assets/images/videoIcon.png',
                      height: 30,
                      width: 30,
                    ), // Play icon overlay
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildCategoriesForVideos() {
    return controller.mdVideosByCategory == null
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mdAllVideoCategories!.data!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    searchTextController.clear();
                    selectedCategoryForVideo.value = index;
                    controller.fetchProductByCategory(
                        controller.mdCategories!.smartCollections![index].id!);
                  },
                  child: Obx(
                    () => Container(
                        margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                        // width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedCategoryForVideo.value == index
                                    ? Colors.transparent
                                    : Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color: selectedCategoryForVideo.value == index
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            controller.mdAllVideoCategories!.data![index].name!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: selectedCategoryForVideo.value == index
                                    ? AppColors.appWhiteColor
                                    : AppColors.appPrimaryBlackColor),
                          ),
                        ))),
                  ),
                );
              },
            ),
          );
  }

  Widget buildDevicesCategories() {
    return controller.devicesCategories.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.devicesCategories.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    searchTextController.clear();
                    selectedCategoryForDevice.value = index;
                    controller.fetchProductByCategory(
                        controller.devicesCategories[index].id!);
                  },
                  child: Obx(
                    () => Container(
                        margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                        // width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedCategoryForDevice.value == index
                                    ? Colors.transparent
                                    : Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color: selectedCategoryForDevice.value == index
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            controller.devicesCategories[index].title!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: selectedCategoryForDevice.value == index
                                    ? AppColors.appWhiteColor
                                    : AppColors.appPrimaryBlackColor),
                          ),
                        ))),
                  ),
                );
              },
            ),
          );
  }

  Widget buildSkinCareCategories() {
    return controller.skinCareCategories.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.skinCareCategories.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    searchTextController.clear();
                    selectedCategoryForSkinCare.value = index;
                    controller.fetchProductByCategory(
                        controller.skinCareCategories[index].id!);
                  },
                  child: Obx(
                    () => Container(
                        margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                        // width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedCategoryForSkinCare.value == index
                                    ? Colors.transparent
                                    : Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color: selectedCategoryForSkinCare.value == index
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            controller.skinCareCategories[index].title!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: selectedCategoryForSkinCare.value == index
                                    ? AppColors.appWhiteColor
                                    : AppColors.appPrimaryBlackColor),
                          ),
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
        controller: searchTextController,
        style: TextStyle(color: AppColors.appPrimaryBlackColor),
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
        onChanged: (query) {
          // Cancel any existing timer
          if (_debounce?.isActive ?? false) _debounce?.cancel();

          // Start a new timer
          _debounce = Timer(const Duration(seconds: 3), () {
            // Close the keyboard
            FocusScope.of(context).unfocus();

            // Filter products based on the query
            controller.filterProducts(query);
          });
        },
      ),
    );
  }

  Widget buildAppBar() {
    return InkWell(
      onTap: () {
        controller.isCurrencyDropDown.value = false;
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Row(
          children: [
            buildSideBarOption(context),
            Spacer(),
            buildName(),
            Spacer(),
            buildCartOption(),
            SizedBox(
              width: 5,
            ),
            buildNotificationOption()
          ],
        ),
      ),
    );
  }

  Widget buildSideBarOption(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
            controller.isCurrencyDropDown.value = false;
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 40.sp,
                width: 40.sp,
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

  Widget buildCartOption() {
    return InkWell(
      onTap: () {
        Get.to(() => Bag());
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40.sp,
            width: 40.sp,
            child: Image.asset('assets/images/ellipse.png'),
          ),
          Container(
            height: 15,
            width: 15,
            child: Image.asset('assets/images/bagIconBlack.png'),
          ),
        ],
      ),
    );
  }

  Widget buildNotificationOption() {
    return InkWell(
      onTap: () {
        Get.to(() => Notifications());
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40.sp,
            width: 40.sp,
            child: Image.asset('assets/images/ellipse.png'),
          ),
          Container(
            height: 15,
            width: 15,
            child: Image.asset('assets/images/bellIcon.png'),
          ),
        ],
      ),
    );
  }

  Widget buildName() {
    return Obx(() => home.value == true
        ? Text(
      'Hello ${controller.userName.split(' ')[0]}', // Only take the first word
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      ),
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

  Widget buildCurrencyOptionA() {
    return Obx(() => Column(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                _showDialogForCurrency(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: controller.isCurrencyDropDown.value == false
                      ? BorderRadius.circular(10)
                      : BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                  color: Color(0xFFB7A06A),
                ),
                height: 45,
                width: MediaQuery.of(context).size.width / 2,
                child: Center(
                  child: Text(
                    controller.selectedCurrency.value.isNotEmpty
                        ? controller.selectedCurrency.value
                        : 'Select Currency',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.appWhiteColor),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildBottomBar() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        controller.isCurrencyDropDown.value = false;
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFB7A06A),
        ),
        height: 50,
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

  Widget buildLatestProductsTextForHome() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: const Text(
              'Latest Products',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
            ),
          ),
        ],
      ),
    );
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

  Widget buildFeaturedProductListView() {
    return controller.mdProducts == null
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.appPrimaryBlackColor,
            ),
          )
        : Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mdProducts!.products!.length ?? 0,
              itemBuilder: (context, index) {
                // Extract SmartCollections data from the controller
                final smartCollection = controller.mdProducts!.products![index];

                int usDollarIndex = 6;
                int euroIndex = 4;
                int poundIndex = 0;

                // Check if the product has a variant with the title "Default Title"
                bool hasDefaultTitle = smartCollection.variants
                        ?.any((variant) => variant.title == "Default Title") ??
                    false;

                // Define the updated price based on selected currency and "Default Title" presence
                String price;

                if (hasDefaultTitle) {
                  price =
                      '£ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else if (controller.selectedCurrency.value == 'US Dollar') {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > usDollarIndex)
                      ? '\$ ${smartCollection.variants![usDollarIndex].price ?? '0.00'} USD'
                      : '\$ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else if (controller.selectedCurrency.value == 'Euro') {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > euroIndex)
                      ? '€ ${smartCollection.variants![euroIndex].price ?? '0.00'} Euro'
                      : '€ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > poundIndex)
                      ? '£ ${smartCollection.variants![poundIndex].price ?? '0.00'} Pound'
                      : '£ 0.00 Pound';
                }

                return InkWell(
                  onTap: () {
                    // Navigate to ProductDetailScreen
                    int? id = smartCollection.id;
                    print('id=====${id}');
                    Get.to(() => ProductDetailScreen(
                          productId: id!,
                          currency: smartCollection.variants![0].title ==
                                  'Default Title'
                              ? 'Pound'
                              : controller.selectedCurrency.value,
                        ));
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFBF3D7), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        // Load image from SmartCollections data
                        smartCollection.image != null &&
                                smartCollection.image!.src != null
                            ? Image.network(
                                smartCollection.image!.src!,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/skinCareDummy.png', // Fallback image
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(height: 10),
                        // Display the title of the product category
                        Text(
                          smartCollection.title ?? 'Unknown Title',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        // Display the updated price
                        GetBuilder<BottomBarHostController>(
                            init: BottomBarHostController(),
                            builder: (BottomBarHostController) {
                              return Text(
                                price,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appPrimaryBlackColor,
                                ),
                              );
                            }),
                        Spacer(),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildHomeProductListView() {
    return controller.mdProducts == null
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.appPrimaryBlackColor,
            ),
          )
        : Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mdProducts!.products!.length ?? 0,
              itemBuilder: (context, index) {
                // Extract SmartCollections data from the controller
                final smartCollection = controller.mdProducts!.products![index];

                int usDollarIndex = 6;
                int euroIndex = 4;
                int poundIndex = 0;

                // Check if the product has a variant with the title "Default Title"
                bool hasDefaultTitle = smartCollection.variants
                        ?.any((variant) => variant.title == "Default Title") ??
                    false;

                // Define the updated price based on selected currency and "Default Title" presence
                String price;

                if (hasDefaultTitle) {
                  price =
                      '£ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else if (controller.selectedCurrency.value == 'US Dollar') {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > usDollarIndex)
                      ? '\$ ${smartCollection.variants![usDollarIndex].price ?? '0.00'} USD'
                      : '\$ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else if (controller.selectedCurrency.value == 'Euro') {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > euroIndex)
                      ? '€ ${smartCollection.variants![euroIndex].price ?? '0.00'} Euro'
                      : '€ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
                } else {
                  price = (smartCollection.variants != null &&
                          smartCollection.variants!.length > poundIndex)
                      ? '£ ${smartCollection.variants![poundIndex].price ?? '0.00'} Pound'
                      : '£ 0.00 Pound';
                }

                return InkWell(
                  onTap: () {
                    // Navigate to ProductDetailScreen
                    int? id = smartCollection.id;
                    print('id=====${id}');
                    Get.to(() => ProductDetailScreen(
                          productId: id!,
                          currency: smartCollection.variants![0].title ==
                                  'Default Title'
                              ? 'Pound'
                              : controller.selectedCurrency.value,
                        ));
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFBF3D7), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        // Load image from SmartCollections data
                        smartCollection.image != null &&
                                smartCollection.image!.src != null
                            ? Image.network(
                                smartCollection.image!.src!,
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/skinCareDummy.png', // Fallback image
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                        SizedBox(height: 10),
                        // Display the title of the product category
                        Text(
                          smartCollection.title ?? 'Unknown Title',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        // Display the updated price
                        GetBuilder<BottomBarHostController>(
                            init: BottomBarHostController(),
                            builder: (BottomBarHostController) {
                              return Text(
                                price,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appPrimaryBlackColor,
                                ),
                              );
                            }),
                        Spacer(),
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
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Make the background image fill the container
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/skinCareDummy.png',
                      fit: BoxFit
                          .cover, // Fills the entire container while keeping aspect ratio
                    ),
                  ),
                ),
                // Other widgets like battery icon and container with text
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
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                          SizedBox(width: 5),
                          Text(
                            '124 K',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appPrimaryBlackColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildProductListViewForBanners() {
    return controller.mdAllBanners == null
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 200,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.mdAllBanners!.data!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: containerWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade200, // Change to any color you like
                      width: 1.0,          // Adjust the thickness of the border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color with opacity
                        spreadRadius: 2,  // How much the shadow spreads
                        blurRadius: 8,    // Blur radius to soften the shadow
                        offset: Offset(0, 4), // Shadow position (x, y) (Here it is below the container)
                      ),
                    ],
                    color: AppColors.appWhiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      // Image filling the parent container
                      Positioned.fill(
                        left: 100,
                        top: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            controller.mdAllBanners!.data![index].imageUrl!,
                            fit: BoxFit
                                .contain, // Ensure the image covers the entire container
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                controller.mdAllBanners!.data![index].title!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors
                                      .black, // White text color for better contrast
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFFB7A06A),
                              ),
                              child: Center(
                                child: Text(
                                  'Shop now',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
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

  Widget buildProductGridViewPopularA(RxList<ProductsA> filteredProducts) {
    return controller.mdProductsByCategory == null ||
            controller.isLoading.value == true
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 300, // Adjust based on your layout requirements
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // Increase the number of items per row for smaller items
                crossAxisSpacing: 8,
                // Reduce spacing between columns
                mainAxisSpacing: 8,
                // Reduce spacing between rows
                childAspectRatio: 1.5, // Adjust for smaller items
              ),
              itemCount: controller.mdProductsByCategory!.products!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFFBF3D7), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.network(
                        controller
                            .mdProductsByCategory!.products![index].image!.src!,
                        height: 50, // Smaller image size
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.mdProductsByCategory!.products![index]
                                          .title!.length >
                                      10
                                  ? controller.mdProductsByCategory!
                                          .products![index].title!
                                          .substring(0, 10) +
                                      '...'
                                  : controller.mdProductsByCategory!
                                      .products![index].title!,
                              style: TextStyle(
                                  fontSize: 11, // Smaller font size
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.appPrimaryBlackColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: 9, // Smaller font size
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appPrimaryBlackColor),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          );
  }

  Widget buildProductGridViewPopular() {
    return controller.mdProductsByCategory == null ||
            controller.isLoading.value == true
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 300, // Adjust based on your layout requirements
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // Increase the number of items per row for smaller items
                crossAxisSpacing: 8,
                // Reduce spacing between columns
                mainAxisSpacing: 8,
                // Reduce spacing between rows
                childAspectRatio: 1.5, // Adjust for smaller items
              ),
              itemCount: controller.mdProductsByCategory!.products!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    final smartCollection =
                        controller.mdProductsByCategory!.products![index];

                    int? id = smartCollection.id;
                    print('id=====${id}');
                    Get.to(() => ProductDetailScreen(
                          productId: controller
                              .mdProductsByCategory!.products![index].id!,
                          currency: 'Pound',
                        ));
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFBF3D7), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Image.network(
                          controller.mdProductsByCategory!.products![index]
                              .image!.src!,
                          height: 50, // Smaller image size
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.mdProductsByCategory!
                                            .products![index].title!.length >
                                        10
                                    ? controller.mdProductsByCategory!
                                            .products![index].title!
                                            .substring(0, 10) +
                                        '...'
                                    : controller.mdProductsByCategory!
                                        .products![index].title!,
                                style: TextStyle(
                                    fontSize: 11, // Smaller font size
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.appPrimaryBlackColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Price',
                                style: TextStyle(
                                    fontSize: 9, // Smaller font size
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.appPrimaryBlackColor),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
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

class VideoGridWidget extends StatelessWidget {
  final List<Videos> videos;

  VideoGridWidget({required this.videos});

  // Function to play video using URL launcher
  void _playVideo(String videoUrl) async {
    if (videoUrl.isEmpty) {
      print('Error: Empty video URL');
      return;
    }

    try {
      final Uri videoUri = Uri.parse(Uri.encodeFull(videoUrl));
      if (await canLaunchUrl(videoUri)) {
        await launchUrl(videoUri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $videoUrl');
      }
    } catch (e) {
      print('Exception while launching video URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 1.2,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final videoUrl = video.videoUrl ?? '';
          final thumbnailUrl =
          video.thumbnail != null ? 'https://opatra.fai-tech.online/${video.thumbnail}' : '';

          return GestureDetector(
            onTap: () {
              _playVideo(videoUrl); // Play video on tap
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade300,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Display thumbnail with FadeInImage for a smoother image loading experience
                  thumbnailUrl.isNotEmpty
                      ? FadeInImage.assetNetwork(
                    placeholder: 'assets/images/youtubeLogo.png',
                    image: thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    imageErrorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  )
                      : Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                  // Play icon overlay
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 50,
                  ),
                ],
              ),
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
