import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constant/AppColors.dart';
import 'package:http/http.dart'
    as http; // Add this dependency to your pubspec.yaml

class Payment extends StatefulWidget {
  final double amount; // Declare a field for the amount
  final String currency; // Declare a field for the amount

  // Constructor to initialize the amount
  Payment(this.amount, this.currency, {super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  RxBool payPal = true.obs;
  RxBool klarna = false.obs;
  RxBool card = true.obs;
  RxBool wallet = false.obs;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/cardDetails.png',
    'assets/images/cardDetails.png',
    'assets/images/cardDetails.png',
  ];

  @override
  void initState() {
    super.initState();
  }

  // Map<String, dynamic>? paymentIntent;

  // Future<void> makePayment(double amount, String selectedCurrency) async {
  //   try {
  //     // Step 1: Create the Payment Intent
  //     print('amount====$amount');
  //
  //     // Use the received amount directly without parsing
  //     final paymentIntent = await createPaymentIntent(amount, selectedCurrency);
  //
  //     if (paymentIntent['client_secret'] == null) {
  //       throw Exception("Failed to retrieve client_secret from PaymentIntent.");
  //     }
  //
  //     // Step 2: Initialize the Payment Sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent['client_secret'],
  //         merchantDisplayName: 'Opatra',
  //         allowsDelayedPaymentMethods: true,
  //       ),
  //     );
  //
  //     // Step 3: Display the Payment Sheet
  //     await displayPaymentSheet();
  //   } catch (e) {
  //     print('Error in payment flow: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error during payment: $e')),
  //     );
  //   }
  // }
  //
  // createPaymentIntent(double amount, String selectedCurrency) async {
  //   try {
  //     // Define the request body with all values as strings
  //     String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
  //     print('amount=${amount}');
  //     print('selectedCurrency=${selectedCurrency}');
  //
  //     // Convert amount to cents and ensure it's an integer
  //     int amountInCents = (amount * 100)
  //         .round(); // Use round() to avoid any floating point issues
  //
  //     Map<String, dynamic> body = {
  //       "amount": amountInCents.toString(),
  //       // Send amount as a string, which is required by the API
  //       "currency": selectedCurrency,
  //       "payment_method_types[]": "card",
  //     };
  //
  //     // Make the POST request to Stripe API
  //     http.Response response = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       body: body,
  //       headers: {
  //         "Authorization": "Bearer ${secretKey}",
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final paymentIntent = json.decode(response.body);
  //       print("Payment Intent Status: ${paymentIntent['status']}");
  //       return paymentIntent;
  //     } else {
  //       print("Error in response: ${response.body}");
  //       throw Exception("Failed to create payment intent: ${response.body}");
  //     }
  //   } catch (e) {
  //     print('Error creating payment intent: ${e.toString()}');
  //     throw Exception(
  //         "Exception during payment intent creation: ${e.toString()}");
  //   }
  // }
  //
  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: const [
  //                     Icon(
  //                       Icons.check_circle,
  //                       color: Colors.green,
  //                       size: 100.0,
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Text("Payment Successful!"),
  //                   ],
  //                 ),
  //               ));
  //
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: const [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Transparent background
          insetPadding: EdgeInsets.only(left: 20, right: 20),
          // Remove default padding around the dialog
          child: Material(
            type: MaterialType.transparency, // Transparent material
            child: Container(
              width:
                  MediaQuery.of(context).size.width, // Full width of the screen
              height: MediaQuery.of(context).size.height /
                  2, // Half the height of the screen
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: Padding(
                padding: EdgeInsets.all(20), // Padding inside the container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/paymentTickIcon.png',
                      width: 100, // Adjust the size as needed
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Payment Successful",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        // Font weight of 600 for more emphasis
                        color: AppColors
                            .appPrimaryBlackColor, // Match color with the icon or theme
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "You have completed the treatment.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:
                            Color(0xFF4E5256), // Text color as per your theme
                      ),
                      textAlign: TextAlign.center, // Center align the text
                    ),
                    SizedBox(height: 30),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 4,
                        decoration: BoxDecoration(
                          color: Color(0xFFB7A06A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'OK',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.appWhiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
          child: Obx(
        () => Column(
          children: [
            buildAppBar(),
            buildCreditCardAndWalletOptions(),
            card.value == true ? buildPreviewProductImages() : Container(),
            card.value == true ? addNewCardButton() : Container(),
            wallet.value == true ? payPalOption() : Container(),
            wallet.value == true ? klarnaOption() : Container(),
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
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
                    buildSubTotal(),
                    buildDivider(),
                    buildTax(),
                    buildDivider(),
                    buildDiscount(),
                    buildDivider(),
                    buildTotal(),
                    Spacer(),
                    buildContinueButton()
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget buildCreditCardAndWalletOptions() {
    return Obx(() => Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            children: [
              buildCreditCardOption(),
              SizedBox(
                width: 20,
              ),
              buildWalletOption()
            ],
          ),
        ));
  }

  Widget buildCreditCardOption() {
    return Expanded(
      child: InkWell(
        onTap: () async {
          card.value = true;
          wallet.value = false;
          // makePayment(widget.amount, widget.currency.toString());
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: card.value == true ? Color(0xFFB7A06A) : Colors.transparent,
            border: Border.all(
                color: card.value == true
                    ? Colors.transparent
                    : AppColors.appGrayColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            // margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/cardIcon.png',
                  color: card.value == true
                      ? AppColors.appWhiteColor
                      : Color(0xFFB7A06A),
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Credit Card',
                  style: TextStyle(
                      color: card.value == true
                          ? AppColors.appWhiteColor
                          : Color(0xFFB7A06A),
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildWalletOption() {
    return Expanded(
      child: InkWell(
        onTap: () {
          card.value = false;
          wallet.value = true;
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color:
                wallet.value == true ? Color(0xFFB7A06A) : Colors.transparent,
            border: Border.all(
                color: wallet.value == true
                    ? Colors.transparent
                    : AppColors.appGrayColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/walletIcon.png',
                  color: wallet.value == true
                      ? AppColors.appWhiteColor
                      : Color(0xFFB7A06A),
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Wallet',
                  style: TextStyle(
                      color: wallet.value == true
                          ? AppColors.appWhiteColor
                          : Color(0xFFB7A06A),
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                )
              ],
            ),
          ),
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
          height: 50.sp,
          width: 50.sp,
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
      'Payment',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildTotal() {
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
            '34.00 \$',
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

  Widget buildSubTotal() {
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
            '36.00 \$',
            style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.w700,
                fontSize: 14),
          )
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: AppColors.appWhiteColor,
      ),
    );
  }

  Widget buildContinueButton() {
    return InkWell(
      onTap: () {
        _showDialog(context);
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
                  color: Color(0xFFB7A06A)),
            ),
          )),
    );
  }

  Widget buildPreviewProductImages() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      // color: AppColors.appPrimaryBlackColor,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4.5,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset(
                        'assets/images/cardContainer.png',
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Image.asset(
                        _images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            // margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  height: 10.0,
                  width: _currentPage == index ? 20.0 : 8.0,
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

  Widget klarnaOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        payPal.value = false;
        klarna.value = true;
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFB7A06A), width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Image.asset(
                'assets/images/klarnaIcon.png',
                height: 20,
                width: 20,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    'Klarna',
                    style: TextStyle(
                      color: Color(0xFFB7A06A),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: klarna.value == true
                          ? Color(0xFFB7A06A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: klarna.value == true
                              ? Colors.transparent
                              : Color(0xFFB7A06A))),
                  child: klarna.value == true
                      ? Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Color(0xFFB7A06A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: AppColors.appWhiteColor)),
                        )
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget payPalOption() {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        payPal.value = true;
        klarna.value = false;
      },
      child: Container(
        margin: EdgeInsets.only(top: 20, right: 20, left: 20),
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFB7A06A), width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Image.asset(
                'assets/images/payPalIcon.png',
                height: 20,
                width: 20,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    'Paypal',
                    style: TextStyle(
                      color: Color(0xFFB7A06A),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: payPal.value == true
                          ? Color(0xFFB7A06A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: payPal.value == true
                              ? Colors.transparent
                              : Color(0xFFB7A06A))),
                  child: payPal.value == true
                      ? Container(
                          margin: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Color(0xFFB7A06A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: AppColors.appWhiteColor)),
                        )
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget addNewCardButton() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20, left: 20),
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFFBF3D7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                'Add New Card',
                style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 20),
            child: Image.asset(
              'assets/images/addSquareIcon.png',
              width: 24, // Adjust the size as needed
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
