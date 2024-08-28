import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/warranty_claim.dart';
import '../../constant/AppColors.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  RxBool card = true.obs;
  RxBool wallet = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            buildCreditCardAndWalletOptions(),
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
      ),
    );
  }

  Widget buildCreditCardAndWalletOptions() {
    return Obx(() => Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Row(
            children: [
              buildCreditCardOption(),
              SizedBox(
                width: 10,
              ),
              buildWalletOption()
            ],
          ),
        ));
  }

  Widget buildCreditCardOption() {
    return Expanded(
      child: InkWell(
        onTap: () {
          card.value = true;
          wallet.value = false;
        },
        child: Container(
          height: 40,
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
          height: 40,
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
      onTap: () {},
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
}
