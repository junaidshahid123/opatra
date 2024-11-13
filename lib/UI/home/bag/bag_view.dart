import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/bag/bag_controller.dart';
import 'package:opatra/models/MDProductDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppColors.dart';
import '../Payment.dart';
import '../bottom_bar_host/bottom_bar_host_view.dart';

class BagView extends StatelessWidget {
  final String selectedCurrency; // Declare a field for the amount

  // Constructor to initialize the amount
  BagView(this.selectedCurrency, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BagController>(
        init: BagController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
              child: Column(
                children: [
                  buildAppBar(),
                  buildListOfProducts(context, logic),
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    margin: EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 20),
                    decoration: BoxDecoration(
                        color: Color(0xFFB7A06A),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        children: [
                          buildSubTotal(logic),
                          buildDivider(context),
                          // buildTax(),
                          // buildDivider(context),
                          // buildDiscount(),
                          // buildDivider(context),
                          buildTotal(logic),
                          Spacer(),
                          buildCheckOutButton(context, logic)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget buildTotal(BagController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Total',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Text(
            '${logic.subTotal}',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildDiscount() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Discount',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Text(
            '5.00 \$',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildTax() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Tax',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Text(
            '2.99 \$',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildSubTotal(BagController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Sub Total',
              style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
          ),
          Text(
            '${logic.subTotal.value}',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildDivider(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
      ),
    );
  }

  Widget buildCheckOutButton(BuildContext context, BagController logic) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isGuest = prefs.getBool('is_guest') ?? false;

        if (isGuest) {
          // Show snackbar to alert guest users to log in or create an account
          Get.snackbar(
            'Login Required',
            'Please log in or create an account to proceed to checkout.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        } else {
          // If not a guest, proceed with the checkout process
          print('logic.subTotal.value========${logic.subTotal.value}');
          print('selectedCurrency========${selectedCurrency}');

          String parsedCurrency =
              selectedCurrency.isNotEmpty ? selectedCurrency : "usd";
          Get.to(() => Payment(logic.subTotal.value, parsedCurrency));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFFFBF3D7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'Check out',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFFB7A06A),
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build product name, currency, and increment/decrement controls
  Widget buildNameAndTime(ProductA product, int quantity, BagController logic,
      int index, double marginHorizontal) {
    return Container(
      margin: EdgeInsets.only(left: marginHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title!.length > 10
                ? '${product.title!.substring(0, 10)}...'
                : product.title!,
            style: TextStyle(
              color: AppColors.appPrimaryBlackColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Row(
            children: [
              _getCurrencyIcon(product.selectedCurrency!),
              SizedBox(width: 5),
              Text(
                '${product.price!.value}',
                style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Spacer(),
              Row(
                children: [
                  // Decrement Button
                  InkWell(
                    onTap: () {
                      if (quantity > 1) {
                        logic.tapOnDecrement(index);
                      }
                    },
                    child: Container(
                      height: (quantity > 99) ? 30 : 35,
                      // Smaller size for quantities over 99
                      width: (quantity > 99) ? 30 : 35,
                      // Smaller size for quantities over 99
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFFBF3D7),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.remove,
                          size: (quantity > 99) ? 16 : 18,
                          // Smaller icon for quantities over 99
                          color: AppColors.appPrimaryBlackColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: (quantity > 99) ? 5 : 10),
                  // Quantity Text
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: (quantity > 99) ? 16 : 20,
                      // Smaller font size for quantities over 99
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryBlackColor,
                    ),
                  ),
                  SizedBox(width: (quantity > 99) ? 5 : 10),
                  // Increment Button
                  InkWell(
                    onTap: () {
                      logic.tapOnIncrement(index);
                    },
                    child: Container(
                      height: (quantity > 99) ? 30 : 35,
                      // Smaller size for quantities over 99
                      width: (quantity > 99) ? 30 : 35,
                      // Smaller size for quantities over 99
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFFBF3D7),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: (quantity > 99) ? 16 : 18,
                          // Smaller icon for quantities over 99
                          color: AppColors.appPrimaryBlackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  // Widget to display the product image with dynamic sizing
  Widget buildImage(ProductA product, double imageSize) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFBF3D7),
      ),
      height: imageSize,
      width: imageSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: product.image != null &&
                product.image!.src != null &&
                product.image!.src!.isNotEmpty
            ? Image.network(
                product.image!.src!,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/skinCareDummy.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  // Widget to build the list of products with responsive margins and dynamic layout
  Widget buildListOfProducts(BuildContext context, BagController logic) {
    final cartItems = logic.getCartItems();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25;
    final double marginHorizontal =
        screenWidth * 0.05; // Dynamic margin based on screen width

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: marginHorizontal, vertical: marginHorizontal / 2),
        child: ListView.builder(
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final product = cartItems[index];
            final quantity = product.quantity!.value;

            return Container(
              margin: EdgeInsets.only(bottom: marginHorizontal / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFFBF3D7)),
              ),
              child: Padding(
                padding: EdgeInsets.all(marginHorizontal / 2),
                child: Row(
                  children: [
                    buildImage(product, imageSize),
                    SizedBox(width: marginHorizontal / 2),
                    Expanded(
                      child: buildNameAndTime(product, quantity, logic, index,
                          marginHorizontal / 2),
                    ),
                  ],
                ),
              ),
            );
          },
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
          InkWell(
              onTap: () {
                Get.offAll(() => BottomBarHostView());
              },
              child: buildSideBarOption()),
          Spacer(),
          buildName(),
          Spacer()
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
          child: Image.asset('assets/images/backArrow.png'),
        ),
      ],
    );
  }

  Widget buildName() {
    return const Text(
      'Your Bag',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  // Method to get the currency icon based on selected currency
  Widget _getCurrencyIcon(String? selectedCurrency) {
    switch (selectedCurrency) {
      case 'US Dollar':
        return Icon(Icons.attach_money,
            color: Color(0xFFB7A06A), size: 20); // Dollar icon
      case 'Euro':
        return Icon(Icons.euro_symbol,
            color: Color(0xFFB7A06A), size: 20); // Euro icon
      case 'Pound':
        return Icon(Icons.currency_pound,
            color: Color(0xFFB7A06A), size: 20); // Rupee icon
      // Add more currencies as needed
      default:
        return SizedBox(); // Return an empty widget for unknown currency
    }
  }
}
