import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../constant/AppColors.dart';
import 'Payment.dart';

class Bag extends StatefulWidget {
  const Bag({super.key});

  @override
  State<Bag> createState() => _BagState();
}

class _BagState extends State<Bag> {
  RxInt quantity = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [
            buildAppBar(),
            buildListOfProducts(),
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
      onTap: (){
        Get.to(()=>Payment());
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

  Widget buildNameAndTime() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COLLAGEN MASK',
            style: TextStyle(
              color: AppColors.appPrimaryBlackColor,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                '\$ 374.00',
                style: TextStyle(
                  color: Color(0xFFB7A06A),
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (quantity.value > 1) {
                        quantity.value--;
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
                  Obx(
                    () => Text(
                      quantity.value.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.appPrimaryBlackColor,
                      ),
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

  Widget buildImage() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFFFBF3D7)),
      height: 100,
      width: 100,
      child: Image.asset('assets/images/skinCareDummy.png'),
    );
  }

  Widget buildListOfProducts() {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 20,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFFFBF3D7))),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [buildImage(), buildNameAndTime()],
              ),
            ),
          );
        },
      ),
    ));
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
      'Your Bag',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }
}
