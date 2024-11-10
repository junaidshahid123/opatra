import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/bag/bag_controller.dart';
import 'package:opatra/models/MDProductDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppColors.dart';
import '../Payment.dart';

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
                  buildListOfProducts(logic),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
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
                          buildTax(),
                          buildDivider(context),
                          buildDiscount(),
                          buildDivider(context),
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

          String parsedCurrency = selectedCurrency.isNotEmpty ? selectedCurrency : "usd";
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

  Widget buildNameAndTime(
      ProductA product, int quantity, BagController logic, int index) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.title!.length > 4
                ? product.title!.substring(0, 10)
                : product.title!, // Display only the first 4 characters
            style: TextStyle(
              color: AppColors.appPrimaryBlackColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
            overflow:
                TextOverflow.ellipsis, // Add ellipsis if the text overflows
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              // Currency icon based on selected currency
              _getCurrencyIcon(product.selectedCurrency!),
              SizedBox(width: 5), // Space between icon and price
              Text(
                '${product.price!.value}',
                // Assuming Product has a 'price' property
                style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      print('index======${index}');
                      print('======${product.title}');
                      if (quantity > 1) {
                        logic.tapOnDecrement(index);
                      }
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFFBF3D7),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/minusIcon.png',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.appPrimaryBlackColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      print('productPrice.value=======${product.price}');
                      logic.tapOnIncrement(index);
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFFFBF3D7),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/images/addIcon.png',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImage(ProductA product) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFFBF3D7),
      ),
      height: 100,
      width: 100,
      child: product.image != null &&
              product.image!.src != null &&
              product.image!.src!.isNotEmpty
          ? Image.network(
              product.image!.src!, // Product image path
              fit: BoxFit
                  .cover, // Adjusts the image to cover the entire container
            )
          : Image.asset(
              'assets/images/skinCareDummy.png', // Path to your placeholder image
              fit: BoxFit
                  .cover, // Adjusts the image to cover the entire container
            ),
    );
  }

  Widget buildListOfProducts(BagController logic) {
    final cartItems = logic.getCartItems(); // Get the cart items

    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final product = cartItems[index]; // Get the ProductA instance
            final quantity =
                product.quantity; // Access the observable quantity safely

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
                    buildImage(product),
                    // Pass the ProductA instance to buildImage
                    buildNameAndTime(product, quantity!.value, logic, index),
                    // Pass product and quantity to buildNameAndTime
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
        children: [buildSideBarOption(), Spacer(), buildName(), Spacer()],
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
