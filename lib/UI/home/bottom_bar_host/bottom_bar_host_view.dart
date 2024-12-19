import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/about_us.dart';
import 'package:opatra/UI/home/bag/bag_view.dart';
import 'package:opatra/UI/home/contact_us/contact_us_view.dart';
import 'package:opatra/UI/home/product_detail/product_detail_view.dart';
import 'package:opatra/UI/home/resgister_own_product/register_own_product_view.dart';
import 'package:opatra/UI/home/settings/settings_view.dart';
import 'package:opatra/UI/home/treatment/treatment_view.dart';
import 'package:opatra/UI/home/warranty_claim/warranty_claim_view.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/MDAllSkinCareProducts.dart';
import '../../../models/MDAllVideos.dart';
import '../../../models/MDLatestProducts.dart';
import '../../../models/MDProductsByCategory.dart';
import '../../../models/MDVideosByCategory.dart';
import '../ask_ouur_experts/ask_our_experts_view.dart';
import '../live_stream.dart';
import '../notifications.dart';
import 'bottom_bar_host_logic.dart';

class BottomBarHostView extends StatefulWidget {
  const BottomBarHostView({super.key});

  @override
  State<BottomBarHostView> createState() => _BottomBarHostView();
}

class _BottomBarHostView extends State<BottomBarHostView> {
  final PageController _controller = PageController(viewportFraction: 0.8);

// Declare a Timer variable to manage the debounce timing
  Timer? _debounce;

// Filter only active products

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarHostController>(
        init: BottomBarHostController(),
        builder: (logic) {
          return Scaffold(
            drawer: buildDrawer(logic),
            onDrawerChanged: (isOpened) {
              logic.isCurrencyDropDown.value = false;
            },
            resizeToAvoidBottomInset: true,
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  logic.isCurrencyDropDown.value = false;
                },
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        buildAppBar(logic),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height /
                                  4, // Adjust this value as needed
                            ),
                            child: Column(
                              children: [
                                Obx(
                                  () => logic.home.value == true
                                      ? buildProductListViewForBanners(logic)
                                      : Container(),
                                ),

                                Obx(
                                  () => logic.home.value == true
                                      ? buildLatestProductsTextForHome()
                                      : Container(),
                                ),
                                logic.mdLatestProducts == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.appPrimaryBlackColor,
                                        ),
                                      )
                                    : Obx(
                                        () => logic.home.value == true
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
                                                  itemCount: logic
                                                      .mdLatestProducts!
                                                      .products!
                                                      .length,
                                                  onPageChanged: (int index) {
                                                    setState(() {
                                                      logic.currentIndex =
                                                          index;
                                                    });
                                                  },
                                                  itemBuilder:
                                                      (context, index) {
                                                    bool isCurrent = index ==
                                                        logic.currentIndex;
                                                    return InkWell(
                                                      onTap: () {
                                                        // Navigate to ProductDetailScreen
                                                        int? id = logic
                                                            .mdLatestProducts!
                                                            .products![index]
                                                            .id;
                                                        print('id=====${id}');
                                                        // print('logic.mdLatestProducts!.products[index].variants[0].title=====${logic.mdLatestProducts!.products![index].variants[0].title}');

                                                        Get.to(() =>
                                                            ProductDetailView(
                                                              productId: id!,
                                                              currency: logic
                                                                  .selectedCurrency
                                                                  .value,
                                                              // currency: logic
                                                              //             .mdLatestProducts!
                                                              //             .products[
                                                              //                 index]
                                                              //             .variants[
                                                              //                 0]
                                                              //             .title ==
                                                              //         'Default Title'
                                                              //     ? 'Pound'
                                                              //     : logic
                                                              //         .selectedCurrency
                                                              //         .value,
                                                            ));
                                                      },
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 300),
                                                        curve: Curves.easeInOut,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                          horizontal: isCurrent
                                                              ? 10
                                                              : 20,
                                                          vertical: isCurrent
                                                              ? 5
                                                              : 20,
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .appPrimaryColor),
                                                          // color: isCurrent
                                                          //     ? Colors.blue
                                                          //     : Colors.grey,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          // boxShadow: isCurrent
                                                          //     ? [
                                                          //         BoxShadow(
                                                          //             color: Colors
                                                          //                 .black26,
                                                          //             blurRadius:
                                                          //                 10)
                                                          //       ]
                                                          //     : [],
                                                        ),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            // Clip the image to the container's rounded corners
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          6.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          logic
                                                                              .mdLatestProducts!
                                                                              .products![index]
                                                                              .title!,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.appPrimaryBlackColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8),
                                                                      // Space between title and vendor text
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          logic
                                                                              .mdLatestProducts!
                                                                              .products![index]
                                                                              .vendor!,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                AppColors.appPrimaryBlackColor,
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: logic.mdLatestProducts!.products![index].image !=
                                                                              null &&
                                                                          logic.mdLatestProducts!.products![index].image!.src !=
                                                                              null
                                                                      ? Image
                                                                          .network(
                                                                          logic
                                                                              .mdLatestProducts!
                                                                              .products![index]
                                                                              .image!
                                                                              .src!,
                                                                          fit: BoxFit
                                                                              .fitHeight,
                                                                          width:
                                                                              double.infinity,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'assets/images/skinCareDummy.png',
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          width:
                                                                              double.infinity,
                                                                        ),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    );
                                                  },
                                                ))
                                            : Container(),
                                      ),
                                Obx(
                                  () => logic.home.value == true
                                      ? buildSkinCareHeading()
                                      : Container(),
                                ),
                                Obx(() => logic.home.value == true
                                    ? buildHomeProductListView(logic)
                                    : logic.video.value == true
                                        ? buildProductListView()
                                        : buildProductListViewForBanners(
                                            logic)),
                                Obx(
                                  () => logic.home.value == true
                                      ? buildDevicesHeading()
                                      : Container(),
                                ),
                                Obx(() => logic.home.value == true
                                    ? logic.mdSkinCareDevicesProducts == null
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.appPrimaryColor,
                                            ),
                                          )
                                        : buildDevicesListView(logic)
                                    : Container()),
                                Obx(
                                  () => logic.product.value ||
                                          logic.video.value == true
                                      ? buildSearchField(logic)
                                      : Container(),
                                ),

                                Obx(() => logic.product.value == true
                                    ? buildSkinCareAndDevicesOptions(logic)
                                    : Container()),
                                Obx(
                                  () => logic.product.value == true &&
                                          logic.skinCare.value == true
                                      ? buildSkinCareCategories(logic)
                                      : Container(),
                                ),
                                Obx(
                                  () => logic.product.value == true &&
                                          logic.devices.value == true
                                      ? logic.mdDevicesProducts == null
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                color:
                                                    AppColors.appPrimaryColor,
                                              ),
                                            )
                                          : buildDevicesCategories(logic)
                                      : Container(),
                                ),

                                Obx(() => logic.product.value
                                    ? Obx(() {
                                        print(
                                            'Current Product Value: ${logic.product.value}');
                                        print(
                                            'Filtered Products Length: ${logic.filteredProducts.length}');
                                        print(
                                            'Search Query: ${logic.searchQuery}');

                                        // Initially show the default popular products
                                        if (logic.searchQuery.isEmpty &&
                                            logic.filteredProducts.isEmpty) {
                                          print(
                                              'No search query and no filtered products. Showing popular products.');
                                          return buildProductGridViewPopular(
                                              logic);
                                        }

                                        // If the controller is loading, show a progress indicator
                                        if (logic.isLoading.value) {
                                          print('Loading products...');
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        // Check if there are filtered products after the search query
                                        if (logic.filteredProducts.isNotEmpty) {
                                          print(
                                              'Filtered products are available. Showing filtered products.');
                                          return buildProductGridViewPopularA(
                                              logic.filteredProducts, logic);
                                        }

                                        // If there are no matching products for the search query
                                        if (logic.filteredProducts.isEmpty &&
                                            logic.searchQuery.isNotEmpty) {
                                          print(
                                              'No matching products found for the search query: ${logic.searchQuery}');

                                          // Show "No products found" message for a few seconds
                                          return Container(
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                            height: 300,
                                            child: Center(
                                              child: Text(
                                                'No products found with this alphabetic query. Try Another.',
                                                maxLines: 3,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors
                                                        .appPrimaryBlackColor),
                                              ),
                                            ),
                                          );
                                        }

                                        // After showing the message, reset the filtered products after a delay
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          Timer(Duration(seconds: 3), () {
                                            print(
                                                'Resetting search query and filtered products after delay.');
                                            FocusScope.of(context).unfocus();

                                            // Reset the filtered products to the popular products
                                            logic.filteredProducts.value = logic
                                                    .mdProductsByCategory
                                                    ?.products ??
                                                [];
                                            logic.isLoading.value = false;
                                          });
                                        });

                                        // If all conditions fail, show the default popular products
                                        print(
                                            'No conditions met, showing default popular products.');
                                        return buildProductGridViewPopular(
                                            logic);
                                      })
                                    : Container()),

                                //     video heading
                                Obx(
                                  () => logic.video.value == true
                                      ? buildCategoriesForVideos(logic)
                                      : Container(),
                                ),
                                // Inside the Obx that controls showing videos based on selected category
                                Obx(() {
                                  return logic.video.value == true
                                      ? logic.mdVideosByCategory == null
                                          ? Container(
                                              margin: EdgeInsets.only(top: 20),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Color(0xFFB7A06A),
                                                ),
                                              ),
                                            )
                                          : logic.isLoading.value == true
                                              ? Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Color(0xFFB7A06A),
                                                    ),
                                                  ),
                                                )
                                              : VideoGridWidget(
                                                  videos: logic
                                                      .mdVideosByCategory!
                                                      .data!
                                                      .videos!,
                                                )
                                      : Container(); // Empty container if the video value is false
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    buildBottomBar(logic),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildSkinCareAndDevicesOptions(BottomBarHostController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space between the two containers
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                logic.searchQuery.value = '';
                logic.searchTextController.clear();
                logic.filteredProducts.clear();
                logic.skinCare.value = true;
                logic.devices.value = false;
                logic.selectedCategoryForSkinCare.value = 0;
                logic.fetchProductByCategory(
                    logic.mdSkinCareCategories!.customCollections![0].id!);
              },
              child: Container(
                padding: EdgeInsets.all(5), // Padding inside the container
                decoration: BoxDecoration(
                  border: logic.skinCare.value == true
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: AppColors.appGrayColor),
                  color: logic.skinCare.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Center(
                  child: Text(
                    'SKINCARE',
                    style: TextStyle(
                      color: logic.skinCare.value == true
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
                logic.searchQuery.value = '';
                logic.searchTextController.clear();
                logic.filteredProducts.clear();
                logic.skinCare.value = false;
                logic.devices.value = true;
                logic.selectedCategoryForDevice.value = 0;
                logic.fetchProductByCategory(
                    logic.mdDevicesProducts!.customCollections![0].id!);
              },
              child: Container(
                padding: EdgeInsets.all(5), // Padding inside the container
                decoration: BoxDecoration(
                  border: logic.devices.value == true
                      ? Border.all(color: Colors.transparent)
                      : Border.all(color: AppColors.appGrayColor),
                  color: logic.devices.value == true
                      ? Color(0xFFB7A06A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'DEVICES',
                    style: TextStyle(
                      color: logic.devices.value == true
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

  Widget buildDrawer(BottomBarHostController logic) {
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
                    'assets/images/splashLogo.png',
                    height: 150,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
              buildOptions(logic)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptions(BottomBarHostController logic) {
    return Obx(() => Expanded(
          child: ListView(
            children: [
              Column(
                children: [
                  buildCurrencyOption(logic),
                  buildTreatmentOption(logic),
                  buildLiveStreamOption(logic),
                  buildAskOurExpertsOption(logic),
                  // buildAboutUsOption(logic),
                  //  buildContactUsOption(logic),
                  buildRegisterYourProductOption(logic),
                  buildWarrantyClaimsOption(logic),
                  buildSettingsOption(logic),
                  // buildLogOutOption(logic),
                  // buildSocialOptions(logic)
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildSocialOptions(BottomBarHostController logic) {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Center the row items
        children: [
          buildFbOption(),
          SizedBox(width: 20), // Add some spacing between the icons
          buildInstaOption(),
          SizedBox(width: 20), // Add some spacing between the icons
          buildTwitterOption(),
          SizedBox(width: 20), // Add some spacing between the icons

          buildYoutubeOption()
        ],
      ),
    );
  }

  void _launchURL() async {
    final Uri url = Uri.parse('https://www.facebook.com/opatraskincare');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildFbOption() {
    return InkWell(
      onTap: () async {
        // Using launchUrl and Uri instead of launch() for newer versions of url_launcher
        _launchURL();
      },
      child: Image.asset(
        'assets/images/fcIcon.png',
        height: 25,
        width: 25,
      ),
    );
  }

  Widget buildInstaOption() {
    return Image.asset(
      'assets/images/instaIcon.png',
      height: 25,
      width: 25,
    );
  }

  Widget buildTwitterOption() {
    return Image.asset(
      'assets/images/twitterIcon.png',
      height: 25,
      width: 25,
    );
  }

  Widget buildYoutubeOption() {
    return InkWell(
      onTap: () async {
        final Uri youTubeUri = Uri.parse(
            'https://www.youtube.com/channel/UClBMMEa5NFxdrxo7Cfs-KOQ'); // Facebook URL

        try {
          // Attempt to launch the URL in the default browser or appropriate app
          if (await canLaunchUrl(youTubeUri)) {
            await launchUrl(youTubeUri,
                mode: LaunchMode
                    .inAppWebView); // Let the system decide the app (browser or external app)
          } else {
            throw 'Could not launch $youTubeUri';
          }
        } catch (e) {
          print('Error: $e');
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.appPrimaryColor),
          ),
          Container(
            margin: EdgeInsets.all(15),
            child: Image.asset(
              'assets/images/youtubeIcon.png',
              height: 15,
              width: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogOutOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 8;
        logic.showLogoutDialog(context);
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 8
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 8
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
                    color: logic.selectedIndex.value == 8
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSettingsOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 6;
        Get.to(() => SettingsView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 6
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 6
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
                'Settings',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 6
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildWarrantyClaimsOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 5;
        Get.to(() => WarrantyClaimView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 5
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 5
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
                    color: logic.selectedIndex.value == 5
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegisterYourProductOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 4;
        Get.to(() => RegisterYourOwnProductView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 4
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 4
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
                    color: logic.selectedIndex.value == 4
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContactUsOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 5;
        Get.to(() => ContactUsView());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 5
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 5
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
                    color: logic.selectedIndex.value == 5
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAboutUsOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 4;
        Get.to(() => AboutUs());
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 4
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 4
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
                    color: logic.selectedIndex.value == 4
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAskOurExpertsOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 3;
        Get.to(() => AskOurExpertsView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 3
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 3
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
                    color: logic.selectedIndex.value == 3
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCurrencyOption(BottomBarHostController logic) {
    print('logic.selectedCurrency.value===============${logic.selectedCurrency.value}');
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 0;
        logic.showDialogForCurrency(context);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 0
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 0
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
                logic.selectedCurrency.value.isNotEmpty
                    ? logic.selectedCurrency.value
                    : 'Select Currency',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: logic.selectedIndex.value == 0
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
              SizedBox(
                width: 10,
              ),
              logic.selectedCurrency.value.isNotEmpty
                  ? Text(
                      '(Tap To Change)',
                      style: TextStyle(
                          color: logic.selectedIndex.value == 0
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

  Widget buildTreatmentOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 1;

        Get.to(() => TreatmentView());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 1
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 1
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
                    color: logic.selectedIndex.value == 1
                        ? AppColors.appWhiteColor
                        : Color(0xFFB7A06A)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLiveStreamOption(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.selectedIndex.value = 2;
        Get.to(() => LiveStream());
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            border: Border.all(
                color: logic.selectedIndex.value == 2
                    ? Colors.transparent
                    : Color(0xFFFBF3D7)),
            color: logic.selectedIndex.value == 2
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
                    color: logic.selectedIndex.value == 2
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
                            "${video.thumbnail}",
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  'Error loading image: $error'); // Add this to debug errors
                              return Icon(Icons
                                  .error); // Show error icon if image fails to load
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child:
                                      CircularProgressIndicator()); // Show loader while the image is loading
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

  Widget buildCategoriesForVideos(BottomBarHostController logic) {
    return logic.mdVideosByCategory == null
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.mdAllVideoCategories!.data!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    logic.searchTextController.clear();
                    logic.selectedCategoryForVideo.value = index;
                    logic.fetchVideoByCategory(
                        logic.mdAllVideoCategories!.data![index].id!);
                  },
                  child: Obx(
                    () => Container(
                        margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                        // width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: logic.selectedCategoryForVideo.value ==
                                        index
                                    ? Colors.transparent
                                    : Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color: logic.selectedCategoryForVideo.value == index
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            logic.mdAllVideoCategories!.data![index].name!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: logic.selectedCategoryForVideo.value ==
                                        index
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

  Widget buildDevicesCategories(BottomBarHostController logic) {
    return logic.mdDevicesProducts!.customCollections!.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.mdDevicesProducts!.customCollections!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                // Get the title of the category
                String categoryTitle =
                    logic.mdDevicesProducts!.customCollections![index].title ??
                        '';

                // If the title is "ANTI AGING CARE", show a custom label
                String displayTitle = categoryTitle == 'ANTI AGING CARE'
                    ? 'ANTI AGING DEVICE'
                    : categoryTitle;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    logic.searchTextController.clear();
                    logic.selectedCategoryForDevice.value = index;

                    if (logic.mdDevicesProducts!.customCollections![index]
                            .title ==
                        'ANTI AGING CARE') {
                      logic.fetchProductByCategory(292370284659);
                    } else {
                      logic.fetchProductByCategory(logic
                          .mdDevicesProducts!.customCollections![index].id!);
                    }
                  },
                  child: Obx(
                    () => Container(
                      margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: logic.selectedCategoryForDevice.value == index
                              ? Colors.transparent
                              : Color(0xFFFBF3D7),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        color: logic.selectedCategoryForDevice.value == index
                            ? Color(0xFFB7A06A)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            displayTitle, // Display the updated title
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color:
                                  logic.selectedCategoryForDevice.value == index
                                      ? AppColors.appWhiteColor
                                      : AppColors.appPrimaryBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget buildSkinCareCategories(BottomBarHostController logic) {
    return logic.mdSkinCareCategories!.customCollections!.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.mdSkinCareCategories!.customCollections!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    logic.searchTextController.clear();
                    logic.selectedCategoryForSkinCare.value = index;
                    logic.fetchProductByCategory(logic
                        .mdSkinCareCategories!.customCollections![index].id!);
                  },
                  child: Obx(
                    () => Container(
                        margin: EdgeInsets.only(left: 20, right: 5, top: 20),
                        // width: 60,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    logic.selectedCategoryForSkinCare.value ==
                                            index
                                        ? Colors.transparent
                                        : Color(0xFFFBF3D7)),
                            borderRadius: BorderRadius.circular(20),
                            color:
                                logic.selectedCategoryForSkinCare.value == index
                                    ? Color(0xFFB7A06A)
                                    : Colors.transparent),
                        child: Center(
                            child: Container(
                          margin: EdgeInsets.all(5),
                          child: Text(
                            logic.mdSkinCareCategories!
                                .customCollections![index].title!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color:
                                    logic.selectedCategoryForSkinCare.value ==
                                            index
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

  Widget buildSearchField(BottomBarHostController logic) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFBF3D7)),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: logic.searchTextController,
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
            logic.updateSearchQuery(query);
          });
        },
      ),
    );
  }

  Widget buildAppBar(BottomBarHostController logic) {
    return InkWell(
      onTap: () {
        logic.isCurrencyDropDown.value = false;
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Row(
          children: [
            buildSideBarOption(context, logic),
            Spacer(),
            buildName(logic),
            Spacer(),
            buildCartOption(logic),
            SizedBox(
              width: 5,
            ),
            buildNotificationOption()
          ],
        ),
      ),
    );
  }

  Widget buildSideBarOption(
      BuildContext context, BottomBarHostController logic) {
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
            logic.isCurrencyDropDown.value = false;
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

  Widget buildCartOption(BottomBarHostController logic) {
    return InkWell(
      onTap: () {
        Get.to(() => BagView(logic.selectedCurrency.value));
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

  Widget buildName(BottomBarHostController logic) {
    return Obx(() => logic.home.value == true
        ? Text(
            'Hello ${logic.userName.split(' ')[0]}', // Only take the first word
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          )
        : logic.product.value == true
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

  // Widget buildCurrencyOptionA() {
  //   return Obx(() => Column(
  //         children: [
  //           InkWell(
  //             splashColor: Colors.transparent,
  //             highlightColor: Colors.transparent,
  //             onTap: () {
  //               _showDialogForCurrency(context);
  //             },
  //             child: Container(
  //               margin: EdgeInsets.only(left: 20, right: 20),
  //               decoration: BoxDecoration(
  //                 borderRadius: logic.isCurrencyDropDown.value == false
  //                     ? BorderRadius.circular(10)
  //                     : BorderRadius.only(
  //                         topLeft: Radius.circular(10),
  //                         topRight: Radius.circular(10)),
  //                 color: Color(0xFFB7A06A),
  //               ),
  //               height: 45,
  //               width: MediaQuery.of(context).size.width / 2,
  //               child: Center(
  //                 child: Text(
  //                   controller.selectedCurrency.value.isNotEmpty
  //                       ? controller.selectedCurrency.value
  //                       : 'Select Currency',
  //                   style: TextStyle(
  //                       fontSize: 15,
  //                       fontWeight: FontWeight.w500,
  //                       color: AppColors.appWhiteColor),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  Widget buildBottomBar(BottomBarHostController logic) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        logic.isCurrencyDropDown.value = false;
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
            buildHomeOption(logic),
            Spacer(),
            buildProductOption(logic),
            Spacer(),
            buildVideoOption(logic),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget buildHomeOption(BottomBarHostController logic) {
    return InkWell(
        onTap: () {
          logic.makeHome();
        },
        child: Obx(() => Container(
              margin: EdgeInsets.only(bottom: 2, top: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: logic.home.value == true
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
                          color: logic.home.value == true
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
                          color: logic.home.value == true
                              ? AppColors.appPrimaryBlackColor
                              : AppColors.appWhiteColor),
                    )
                  ],
                ),
              ),
            )));
  }

  Widget buildProductOption(BottomBarHostController logic) {
    return InkWell(
        onTap: () {
          logic.makeProduct();
        },
        child: Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: 2, top: 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: logic.product.value == true
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
                          color: logic.product.value == true
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
                        color: logic.product.value == true
                            ? AppColors.appPrimaryBlackColor
                            : AppColors.appWhiteColor),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildVideoOption(BottomBarHostController logic) {
    return InkWell(
        onTap: () {
          logic.makeVideo();
        },
        child: Obx(
          () => Container(
            margin: EdgeInsets.only(bottom: 2.sp, top: 2.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: logic.video.value == true
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
                          color: logic.video.value == true
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
                        color: logic.video.value == true
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
              'Popular Products',
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

  Widget buildDevicesHeading() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: const Text(
              'Devices',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
            ),
          ),
          // Text(
          //   'see all',
          //   style: TextStyle(
          //       color: Color(0xFFB7A06A),
          //       fontWeight: FontWeight.w600,
          //       fontSize: 12),
          // )
        ],
      ),
    );
  }

  Widget buildSkinCareHeading() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: const Text(
              'SkinCare',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333)),
            ),
          ),
          // Text(
          //   'see all',
          //   style: TextStyle(
          //       color: Color(0xFFB7A06A),
          //       fontWeight: FontWeight.w600,
          //       fontSize: 12),
          // )
        ],
      ),
    );
  }

  // Widget buildFeaturedProductListView() {
  //   return controller.mdProducts == null
  //       ? Center(
  //           child: CircularProgressIndicator(
  //             color: AppColors.appPrimaryBlackColor,
  //           ),
  //         )
  //       : Container(
  //           height: 150,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: controller.mdProducts!.products!.length ?? 0,
  //             itemBuilder: (context, index) {
  //               // Extract SmartCollections data from the controller
  //               final smartCollection = controller.mdProducts!.products![index];
  //
  //               int usDollarIndex = 6;
  //               int euroIndex = 4;
  //               int poundIndex = 0;
  //
  //               // Check if the product has a variant with the title "Default Title"
  //               bool hasDefaultTitle = smartCollection.variants
  //                       ?.any((variant) => variant.title == "Default Title") ??
  //                   false;
  //
  //               // Define the updated price based on selected currency and "Default Title" presence
  //               String price;
  //
  //               if (hasDefaultTitle) {
  //                 price =
  //                     '£ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
  //               } else if (controller.selectedCurrency.value == 'US Dollar') {
  //                 price = (smartCollection.variants != null &&
  //                         smartCollection.variants!.length > usDollarIndex)
  //                     ? '\$ ${smartCollection.variants![usDollarIndex].price ?? '0.00'} USD'
  //                     : '\$ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
  //               } else if (controller.selectedCurrency.value == 'Euro') {
  //                 price = (smartCollection.variants != null &&
  //                         smartCollection.variants!.length > euroIndex)
  //                     ? '€ ${smartCollection.variants![euroIndex].price ?? '0.00'} Euro'
  //                     : '€ ${smartCollection.variants != null && smartCollection.variants!.length > poundIndex ? smartCollection.variants![poundIndex].price ?? '0.00' : '0.00'} Pound';
  //               } else {
  //                 price = (smartCollection.variants != null &&
  //                         smartCollection.variants!.length > poundIndex)
  //                     ? '£ ${smartCollection.variants![poundIndex].price ?? '0.00'} Pound'
  //                     : '£ 0.00 Pound';
  //               }
  //
  //               return InkWell(
  //                 onTap: () {
  //                   // Navigate to ProductDetailScreen
  //                   int? id = smartCollection.id;
  //                   print('id=====${id}');
  //                   Get.to(() => ProductDetailView(
  //                         productId: id!,
  //                         currency: smartCollection.variants![0].title ==
  //                                 'Default Title'
  //                             ? 'Pound'
  //                             : controller.selectedCurrency.value,
  //                       ));
  //                 },
  //                 child: Container(
  //                   width: 150,
  //                   margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Color(0xFFFBF3D7), width: 1),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Spacer(),
  //                       // Load image from SmartCollections data
  //                       smartCollection.image != null &&
  //                               smartCollection.image!.src != null
  //                           ? Image.network(
  //                               smartCollection.image!.src!,
  //                               height: 50,
  //                               width: 50,
  //                               fit: BoxFit.cover,
  //                             )
  //                           : Image.asset(
  //                               'assets/images/skinCareDummy.png', // Fallback image
  //                               height: 50,
  //                               width: 50,
  //                               fit: BoxFit.cover,
  //                             ),
  //                       SizedBox(height: 10),
  //                       // Display the title of the product category
  //                       Text(
  //                         smartCollection.title ?? 'Unknown Title',
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.w600,
  //                           color: AppColors.appPrimaryBlackColor,
  //                         ),
  //                         textAlign: TextAlign.center,
  //                         maxLines: 1,
  //                       ),
  //                       SizedBox(height: 5),
  //                       // Display the updated price
  //                       GetBuilder<BottomBarHostController>(
  //                           init: BottomBarHostController(),
  //                           builder: (BottomBarHostController) {
  //                             return Text(
  //                               price,
  //                               style: TextStyle(
  //                                 fontSize: 10,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: AppColors.appPrimaryBlackColor,
  //                               ),
  //                             );
  //                           }),
  //                       Spacer(),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  // }

  Widget buildDevicesListView(BottomBarHostController logic) {
    // Check if products are null or empty and show a loading spinner if so
    if (logic.mdSkinCareDevicesProducts == null ||
        logic.mdSkinCareDevicesProducts!.products == null ||
        logic.mdSkinCareDevicesProducts!.products!.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.appPrimaryBlackColor,
        ),
      );
    }

    // Filter the active products (assuming a 'status' field or 'isActive' flag)
    List<Product> activeProducts = logic.mdSkinCareDevicesProducts!.products!
        .where((product) =>
            product.status == 'active') // Adjust condition based on your model
        .toList();

    // Handle case where the filtered product list is empty
    if (activeProducts.isEmpty) {
      return Center(
        child: Text(
          'No active products available',
          style: TextStyle(
            color: AppColors.appPrimaryBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activeProducts.length, // Use filtered list here
        itemBuilder: (context, index) {
          // Safely extract data from the filtered list
          final smartCollection = activeProducts[index];
          print("Tamoor Device");
          print(activeProducts.length);
          return InkWell(
            onTap: () {
              // Safely navigate to ProductDetailView with a valid product ID
              final id = smartCollection.id;
              if (id != null) {
                print('id=====${id}');
                print(
                    'smartCollection.productType=====${smartCollection.productType}');
                Get.to(() => ProductDetailView(
                      productId: id,
                      currency: logic.selectedCurrency.value,
                    ));
              }
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
                  // Load image from SmartCollections data with null checks
                  Image.network(
                    smartCollection.image?.src ?? '',
                    // Fallback to empty string if image is null
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/skinCareDummy.png', // Fallback image
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Display the title of the product category with null check
                  Text(
                    smartCollection.title ?? 'Unknown Title',
                    // Fallback to 'Unknown Title' if null
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryBlackColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHomeProductListView(BottomBarHostController logic) {
    // Check if the product list or products are null
    if (logic.mdSkinCareProducts == null ||
        logic.mdSkinCareProducts!.products == null) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.appPrimaryBlackColor,
        ),
      );
    }

    // Filter the active products (assuming a 'status' field or 'isActive' flag)
    List<Product> activeProducts = logic.mdSkinCareProducts!.products!
        .where((product) =>
            product.status == 'active') // Adjust condition based on your model
        .toList();

    // Handle case where the filtered product list is empty
    if (activeProducts.isEmpty) {
      return Center(
        child: Text(
          'No active products available',
          style: TextStyle(
            color: AppColors.appPrimaryBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: activeProducts.length, // Use filtered list here
        itemBuilder: (context, index) {
          // Safely access the filtered active product
          final skinProduct = activeProducts[index];
          print("Tamoor Skin Care");
          print(activeProducts.length);
          // Handle null `skinProduct` or its properties
          final int? id = skinProduct.id;
          final String title = skinProduct.title ?? 'Unknown Title';
          final String imageUrl = skinProduct.image?.src ?? '';

          return InkWell(
            onTap: () {
              if (id != null) {
                print('id=====${id}');
                print(
                    'skinProduct.productType=====${skinProduct.productType ?? 'Unknown Type'}');
                Get.to(() => ProductDetailView(
                      productId: id,
                      currency: logic.selectedCurrency.value,
                    ));
              } else {
                print('Product ID is null');
              }
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
                  // Safely load image or fallback
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/skinCareDummy.png',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                  SizedBox(height: 10),
                  // Display the title of the product
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryBlackColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  SizedBox(height: 5),
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

  Widget buildProductListViewForBanners(BottomBarHostController logic) {
    return logic.mdAllBanners == null
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFFB7A06A),
            ),
          )
        : Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: logic.mdAllBanners!.data!.length,
              itemBuilder: (context, index) {
                // Adjusting width to account for left and right margins
                double containerWidth = MediaQuery.of(context).size.width - 40;

                return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  width: containerWidth,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Colors.grey.shade200, // Change to any color you like
                      width: 1.0, // Adjust the thickness of the border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        // Shadow color with opacity
                        spreadRadius: 2,
                        // How much the shadow spreads
                        blurRadius: 8,
                        // Blur radius to soften the shadow
                        offset: Offset(0,
                            4), // Shadow position (x, y) (Here it is below the container)
                      ),
                    ],
                    color: AppColors.appWhiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        logic.mdAllBanners!.data![index].imageUrl!,
                        fit: BoxFit.fill,
                        // Ensure the image covers the entire container
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/images/skinCareDummy.png',
                            // Path to your placeholder image
                            fit: BoxFit.contain,
                          );
                        },
                      )),
                );
              },
            ),
          );
  }

  Widget buildProductGridViewPopularA(
      RxList<ProductsA> filteredProducts, BottomBarHostController logic) {
    return logic.filteredProducts.isEmpty || logic.isLoading.value == true
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
              itemCount: logic.filteredProducts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print('index========${index}');
                    final smartCollection = logic.filteredProducts[index];

                    int? id = smartCollection.id;
                    print('id=====${id}');
                    Get.to(() => ProductDetailView(
                          productId: logic.filteredProducts[index].id!,
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
                          logic.filteredProducts[index].image!.src!,
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
                                logic.filteredProducts[index].title!.length > 10
                                    ? logic.filteredProducts[index].title!
                                            .substring(0, 10) +
                                        '...'
                                    : logic.filteredProducts[index].title!,
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

  Widget buildProductGridViewPopular(BottomBarHostController logic) {
    return logic.mdProductsByCategory == null || logic.isLoading.value == true
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.appPrimaryColor,
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
              itemCount: logic.mdProductsByCategory!.products!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print('index========${index}');
                    final smartCollection =
                        logic.mdProductsByCategory!.products![index];

                    int? id = smartCollection.id;
                    print('id=====${id}');
                    Get.to(() => ProductDetailView(
                          productId:
                              logic.mdProductsByCategory!.products![index].id!,
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
                          logic.mdProductsByCategory!.products![index].image!
                              .src!,
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
                                logic.mdProductsByCategory!.products![index]
                                            .title!.length >
                                        10
                                    ? logic.mdProductsByCategory!
                                            .products![index].title!
                                            .substring(0, 10) +
                                        '...'
                                    : logic.mdProductsByCategory!
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
          childAspectRatio: 0.9,
        ),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final videoUrl = video.videoUrl ?? '';
          final thumbnailUrl =
              video.thumbnail != null ? '${video.thumbnail}' : '';
          final videoName = video.name ?? 'No Name';

          return GestureDetector(
            onTap: () {
              _playVideo(videoUrl); // Play video on tap
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120.0, // Fixed height for thumbnail
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Constrain FadeInImage within the defined size
                        thumbnailUrl.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/youtubeLogo.png',
                                image: thumbnailUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child:
                                          Icon(Icons.error, color: Colors.red),
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
                ),
                const SizedBox(height: 8.0), // Space between thumbnail and name
                Text(
                  videoName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
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
