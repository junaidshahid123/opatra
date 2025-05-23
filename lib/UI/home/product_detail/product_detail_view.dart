import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/bag/bag_view.dart';
import 'package:opatra/UI/home/product_detail/product_detail_controller.dart';
import 'package:opatra/constant/AppColors.dart';

import '../../../models/MDProductDetail.dart';
import '../bag/bag_controller.dart';

class ProductDetailView extends StatefulWidget {
  final int productId; // Example value you want to pass
  final String currency; // Example value you want to pass

  const ProductDetailView(
      {super.key, required this.productId, required this.currency});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  final ProductDetailController controller =
      Get.put(ProductDetailController()); // Initialize the controller
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isExpanded = false;
  bool isLongText = false; // To check if the text is more than 6 lines
  final int maxLines = 4; // Maximum number of lines before showing "Read more"
  final String dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
      'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
      'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
      'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
      'id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
      'Nulla dui. Fusce feugiat malesuada odio. Morbi nunc odio, gravida at, cursus nec, '
      'luctus a, lorem. Maecenas tristique orci ac sem. Duis ultricies pharetra magna. '
      'Donec accumsan malesuada orci. Donec sit amet eros. Lorem ipsum dolor sit amet, '
      'consectetur adipiscing elit.';
  final String dummyTextShort =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.productId=====${widget.productId}');
    print('widget.currency=====${widget.currency}');
    controller.fetchProductDetail(widget.productId);
    controller.fetchAppModules();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailController>(
        init: ProductDetailController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildAppBar(),
                    controller.mdProductDetail == null
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFB7A06A),
                            ),
                          )
                        : Column(
                            children: [
                              buildPreviewProductImages(),
                              buildProductName(),
                              buildDescription(),
                              buildAddToBagButton(logic),
                            ],
                          )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget buildReviews() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryBlackColor),
              )
            ],
          ),
        ),
        buildReviewsList()
      ],
    );
  }

  Widget buildReviewsList() {
    return Column(
      children: List.generate(10, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/starIcon.png',
                          height: 15,
                          width: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: AppColors.appPrimaryBlackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  dummyTextShort,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: AppColors.appPrimaryBlackColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildDescription() {
    String bodyHtml = controller.mdProductDetail!.product!.bodyHtml!;

    // Determine whether to display full text or short version
    final String shortDescription =
        bodyHtml.length > 300 ? bodyHtml.substring(0, 300) + '...' : bodyHtml;
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlWidget(
            bodyHtml,
            textStyle: TextStyle(
              fontSize: 13,
              color: Color(0xFF797E86),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          // Only show "Read more" if the text exceeds 6 lines
          if (isLongText)
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'Read less' : 'Read more',
                style: TextStyle(color: Color(0xFFB7A06A), fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAddToBagButton(ProductDetailController logic) {
    return InkWell(
      onTap: () async {
        print(
            'controller.mdProductDetail.product.id====${controller.mdProductDetail!.product!.id}');
        print('controller.quantity.value====${controller.quantity.value}');
        print('widget.currency====${widget.currency}');

        // Ensure that the variants list is not null or empty and has the correct number of elements
        if (controller.mdProductDetail!.product!.variants == null ||
            controller.mdProductDetail!.product!.variants!.isEmpty) {
          print('No variants available for the product');
          return;
        }

        int? priceIndex;

        // Find the appropriate index based on the selected currency
        if (widget.currency == 'Pound') {
          priceIndex = 0; // Update the correct index for Pound
        } else if (widget.currency == 'Euro') {
          priceIndex = 4; // Update the correct index for Euro
        } else if (widget.currency == 'US Dollar') {
          priceIndex = 6; // Update the correct index for US Dollar
        }

        // Ensure the index is within the valid range
        if (priceIndex != null &&
            priceIndex >= 0 &&
            priceIndex < controller.mdProductDetail!.product!.variants!.length) {
          controller.price = controller.mdProductDetail!.product!.variants![priceIndex].price!;
          print(
              'controller.mdProductDetail!.product!.variants![priceIndex].price!====${controller.mdProductDetail!.product!.variants![priceIndex].title!}');
        } else if (controller.mdProductDetail!.product!.variants![0].title == 'Default Title') {
          // If the index is invalid, use the default variant
          controller.price = controller.mdProductDetail!.product!.variants![0].price!;
        } else {
          // If neither condition is met, print the error message
          print('Invalid index for selected currency');
          return;
        }


        print('price====${controller.price}');
        var priceA =
            controller.quantity.value * double.tryParse(controller.price!)!;

        print('priceA====${priceA}');

        if (controller.mdProductDetail!.product != null) {
          ProductA productToAdd = ProductA(
            id: controller.mdProductDetail!.product!.id,
            title: controller.mdProductDetail!.product!.title,
            image: controller.mdProductDetail!.product!.image,
            price: priceA.toDouble(),
            quantity: controller.quantity.value,
            selectedCurrency: widget.currency,
          );

          // Await the addToBag function to ensure it's completed
          await controller.addToBag(productToAdd, widget.currency);

          // Show toast after the operation is successfully done
          Fluttertoast.showToast(
            msg: "Product Added to Bag Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: AppColors.appPrimaryColor,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          print('No product found to add to the bag.');
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Color(0xFFB7A06A),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bagIcon.png',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Add To Bag',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                logic.tapOnDecrement();
              },
              child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFFFBF3D7)),
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset('assets/images/minusIcon.png'))),
            ),
            SizedBox(width: 10),
            Obx(
              () => Text(
                logic.quantity.value.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryBlackColor),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                logic.tapOnIncrement();
              },
              child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFFFBF3D7)),
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset('assets/images/addIcon.png'))),
            )
          ],
        ),
      ),
    );
  }

  Widget buildProductName() {
    // Define the indexes for each currency
    int usDollarIndex = 6;
    int euroIndex = 4;
    int poundIndex = 0;

    // Determine the price based on the selected currency and its variant availability
    String price;
    if (widget.currency == 'US Dollar') {
      price = (controller.mdProductDetail!.product!.variants != null &&
              controller.mdProductDetail!.product!.variants!.length >
                  usDollarIndex)
          ? '\$ ${controller.mdProductDetail!.product!.variants![usDollarIndex].price ?? '0.00'} USD'
          : '\$ ${controller.mdProductDetail!.product!.variants![poundIndex].price ?? '0.00'} ';
    } else if (widget.currency == 'Euro') {
      price = (controller.mdProductDetail!.product!.variants != null &&
              controller.mdProductDetail!.product!.variants!.length > euroIndex)
          ? '€ ${controller.mdProductDetail!.product!.variants![euroIndex].price ?? '0.00'} Euro'
          : '€ ${controller.mdProductDetail!.product!.variants![poundIndex].price ?? '0.00'}';
    } else {
      price = (controller.mdProductDetail!.product!.variants != null &&
              controller.mdProductDetail!.product!.variants!.length >
                  poundIndex)
          ? '£ ${controller.mdProductDetail!.product!.variants![poundIndex].price ?? '0.00'} Pound'
          : '£ 0.00 Pound';
    }

    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.mdProductDetail!.product!.title!.length > 30
                            ? '${controller.mdProductDetail!.product!.title!.substring(0, 30)}...'
                            : controller.mdProductDetail!.product!.title!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/starIcon.png',
                      height: 15,
                      width: 15,
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        Text(
                          ' (286) reviews',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Adjusting Spacer and alignment for flexible price display
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB7A06A),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPreviewProductImages() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      // color: AppColors.appPrimaryBlackColor,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: PageView.builder(
              controller: _pageController,
              itemCount: controller.mdProductDetail!.product!.images!.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.network(
                  controller.mdProductDetail!.product!.images![index].src!,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          Container(
            // margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  controller.mdProductDetail!.product!.images!.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  height: 10.0,
                  width: _currentPage == index ? 8.0 : 8.0,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index ? Color(0xFFB7A06A) : Colors.grey,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                );
              }),
            ),
          ),
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
          buildBackOption(), Spacer(),
          controller.mdProductDetail == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFB7A06A),
                  ),
                )
              : buildName(),
          Spacer(),
          Container()
          // buildNotificationOption()
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

  Widget buildNotificationOption() {
    return Stack(
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
    );
  }

  Widget buildName() {
    return Text(
      controller.mdProductDetail!.product!.title!,
      maxLines: 2,
      // Limit to one line
      // overflow: TextOverflow.ellipsis, // Truncate with ellipsis if it overflows
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }
}

class ReadMoreText extends StatefulWidget {
  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;
  final String dummyText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi '
      'ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit '
      'in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint '
      'occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim '
      'id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
      'Nulla dui. Fusce feugiat malesuada odio. Morbi nunc odio, gravida at, cursus nec, '
      'luctus a, lorem. Maecenas tristique orci ac sem. Duis ultricies pharetra magna. '
      'Donec accumsan malesuada orci. Donec sit amet eros. Lorem ipsum dolor sit amet, '
      'consectetur adipiscing elit.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read More Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isExpanded ? dummyText : dummyText.substring(0, 300) + '...',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? 'Read less' : 'Read more',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
