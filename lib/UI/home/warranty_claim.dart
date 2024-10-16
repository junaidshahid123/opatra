import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constant/AppColors.dart';

class WarrantyClaim extends StatefulWidget {
  const WarrantyClaim({super.key});

  @override
  State<WarrantyClaim> createState() => _WarrantyClaimState();
}

class _WarrantyClaimState extends State<WarrantyClaim> {
  RxBool yesOption = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      body: SafeArea(
        child: Column(
          children: [buildAppBar(), buildForm()],
        ),
      ),
    );
  }

  Widget buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              buildNote(),
              buildCustomersDetails(),
              buildFastNameField(),
              buildLastNameField(),
              buildAddressField(),
              buildCountryField(),
              buildPhoneField(),
              buildDateOFBirthField(),
              buildProductDetails(),
              buildPlaceOfPurchaseField(),
              buildDateOfPurchaseField(),
              buildReceiptNumberField(),
              buildAdvisorNameField(),
              buildDescribeIssueField(),
              buildUploadImageOption(),
              buildQuestion(),
              buildYesAndNoButtons(),
              buildMessage(),
              buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadImageOption() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xFFEDEDED),
          ),
          borderRadius: BorderRadius.circular(10)),
      // color: Colors.grey[200], // Optional: Background color for the container
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/uploadImageIcon.png',
              height: 40,
              width: 40,
            ),
            SizedBox(height: 10), // Space between image and text
            Text(
              'Upload an image of the \nproduct/issue (if applicable)',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appPrimaryBlackColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMessage() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Text(
        'We hate spam! We promise to send you only valued information and offers that are tailoured to you! \n \nWe use email and targeted online advertising to send you product and service updates, promotional offers and other marketing communications based on the inofmation we collect about you, such as your email address,general location, and purchase and website browsing history. \n \nWe process your personal data as stated in our Privacy Policy. You may withdraw your consent or manage your prefernces at anytime by clicking the unsubscribe link at  the bottom of any of our marketing emails, or by emailing us at info@opatra.com ',
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFFAAAAAA)),
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
        margin: EdgeInsets.only(top: 50, right: 20, bottom: 20),
        width: MediaQuery.of(context).size.width,
        height: 45,
        decoration: BoxDecoration(
          color: Color(0xFFB7A06A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Submit',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ));
  }

  Widget buildYesAndNoButtons() {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 20),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  yesOption.value = true;
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Color(0xFFEDEDED),
                            ),
                            color: yesOption.value == true
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
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
                  yesOption.value = false;
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Color(0xFFEDEDED),
                            ),
                            color: yesOption.value == false
                                ? Color(0xFFB7A06A)
                                : Colors.transparent),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'No',
                        style: TextStyle(
                            color: yesOption.value == false
                                ? Color(0xFFB7A06A)
                                : Colors.transparent,
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildQuestion() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Text(
        'Would you like to hear from us? (Special Offers, Birthday Gifts, New Products and more) *',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: AppColors.appPrimaryBlackColor),
      ),
    );
  }

  Widget buildNote() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Text(
        'Note: Product Registration required to be able to make a claim. Please fill in the claim form for one product at a time.',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFFAAAAAA)),
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
          buildBackOption(),
          Spacer(),
          buildName(),
          Spacer(),
          buildNotificationOption()
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
    return const Text(
      'Warranty Claim',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildCustomersDetails() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'Customers Details',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.appPrimaryBlackColor),
          ),
        ],
      ),
    );
  }

  Widget buildProductDetails() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Text(
            'Product Details',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.appPrimaryBlackColor),
          ),
        ],
      ),
    );
  }

  Widget buildSubjectField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Subject',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildFastNameField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Fast Name',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildLastNameField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Last Name',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAddressField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Address',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPhoneField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Phone',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildAdvisorNameField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Advisor Name (if applicable)',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildReceiptNumberField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Receipt Number',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDescribeIssueField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Please Describe the issue',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPlaceOfPurchaseField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Place Of Purchase',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSelectProductField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Select Your Product',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                suffixIcon: Container(
                  height: 10, // Specific height
                  width: 10, // Specific width
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/downIcon.png', // Adjust the image within the container
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCountryField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Country',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                suffixIcon: Container(
                  height: 10, // Specific height
                  width: 10, // Specific width
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/downIcon.png', // Adjust the image within the container
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateOfPurchaseField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Date of Purchase',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                suffixIcon: Container(
                  height: 10, // Specific height
                  width: 10, // Specific width
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/calenderIcon.png', // Adjust the image within the container
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateOFBirthField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Date of birth',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                suffixIcon: Container(
                  height: 10, // Specific height
                  width: 10, // Specific width
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Image.asset(
                      'assets/images/calenderIcon.png', // Adjust the image within the container
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Your Email',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 45,
            width: double.infinity, // Full width
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMessageField() {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Your Message',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666)),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 100,
            width: double.infinity, // Full width
            child: TextField(
              maxLines: 5,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
