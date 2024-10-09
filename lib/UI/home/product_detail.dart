import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:opatra/constant/AppColors.dart';
import '../../controllers/product_detail_controller.dart';
import 'bag.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId; // Example value you want to pass
  final String currency; // Example value you want to pass

  const ProductDetailScreen(
      {super.key, required this.productId, required this.currency});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailController controller =
      Get.put(ProductDetailController()); // Initialize the controller
  RxInt quantity = 1.obs;
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
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailController>(
        init: ProductDetailController(),
        builder: (ProductDetailController) {
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
                              buildAddToBagButton(),

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

  Widget buildAddToBagButton() {
    return InkWell(
      onTap: () {
        Get.to(() => Bag());
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
                margin: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bagIcon.png',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Add To Bag',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                if (quantity.value > 1) {
                  quantity.value--;
                }
              },
              child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFFFBF3D7)),
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/minusIcon.png',
                      ))),
            ),
            SizedBox(
              width: 10,
            ),
            Obx(
              () => Text(
                quantity.value.toString(),
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appPrimaryBlackColor),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                quantity.value++;
              },
              child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color(0xFFFBF3D7)),
                  child: Container(
                      margin: EdgeInsets.all(15),
                      child: Image.asset(
                        'assets/images/addIcon.png',
                      ))),
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
      margin: EdgeInsets.only(top: 20, left: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    controller.mdProductDetail!.product!.title!,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333)),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/starIcon.png',
                    height: 15,
                    width: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '4.9',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333)),
                      ),
                      Text(
                        ' (286) reviews',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFAAAAAA)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          // Assuming widget.currency is a state that affects the price display
          Container(
            margin: EdgeInsets.only(
              right: 15,
            ),
            child: Text(
              price,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB7A06A),
              ),
            ),
          )
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
                  fit: BoxFit.cover,
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
          buildSideBarOption(),
          Spacer(),
          controller.mdProductDetail == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFB7A06A),
                  ),
                )
              : buildName(),
          Spacer(),
          buildNotificationOption()
        ],
      ),
    );
  }

  Widget buildSideBarOption() {
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
          child: Image.asset('assets/images/menuLines.png'),
        ),
      ],
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
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
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
