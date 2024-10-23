import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:opatra/UI/home/resgister_own_product/register_own_product_logic.dart';
import '../../../constant/AppColors.dart';

class RegisterYourOwnProductView extends StatelessWidget {
  const RegisterYourOwnProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterYourOwnProductController>(
        init: RegisterYourOwnProductController(),
        builder: (logic) {
          return Scaffold(
            backgroundColor: AppColors.appWhiteColor,
            body: SafeArea(
                child: Form(
              key: logic.registerProduct,
              child: Column(
                children: [buildAppBar(), buildForm(context, logic)],
              ),
            )),
          );
        });
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
      'Register Your Product',
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
    );
  }

  Widget buildForm(
      BuildContext context, RegisterYourOwnProductController logic) {
    return Expanded(
      child: SingleChildScrollView(
        controller: logic.scrollController,
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, bottom: 20),
          child: Column(
            children: [
              buildCustomersDetails(),
              buildFastNameField(context, logic),
              buildLastNameField(context, logic),
              buildAddressField(context, logic),
              buildCountryField(
                logic.selectedCountry,
                logic.setSelectedCountry,
              ),
              buildPhoneField(context, logic),
              buildDateOfBirthField(logic.onBirthdayTap, logic),
              buildProductDetails(),
              // buildSelectProductField(),
              buildSelectedList(logic),
              buildPlaceOfPurchaseField(context, logic),
              buildDateOfPurchaseField(logic.onPurchaseTap, logic),
              buildReceiptNumberField(context, logic),
              buildAdvisorNameField(context, logic),
              buildQuestion(),
              buildYesAndNoButtons(logic),
              buildMessage(),
              buildSubmitButton(context, logic)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectedList(RegisterYourOwnProductController logic) {
    return Container(
      margin: EdgeInsets.only(top: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container for DropdownButton to control width and height
          Container(
            height: 45,
            // Set the height of the dropdown field
            padding: EdgeInsets.symmetric(horizontal: 10),
            // Padding inside the container
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.appGrayColor),
              // Border for dropdown
              borderRadius: BorderRadius.circular(10),
              // Rounded corners
              color: Colors
                  .white, // Optional: Set a background color for the dropdown
            ),
            child: DropdownButtonHideUnderline(
              // Hide the default underline
              child: DropdownButton<String>(
                isExpanded: true,
                // Make dropdown take full width
                hint: Text(
                  "Select a product",
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                ),
                value: null,
                // Initial selected value
                items: logic.itemNames.map((String itemName) {
                  return DropdownMenuItem<String>(
                    value: itemName,
                    child: Text(itemName),
                  );
                }).toList(),
                onChanged: (String? selectedItem) {
                  if (selectedItem != null) {
                    logic.toggleSelection(selectedItem);
                  }
                },
                icon: Icon(Icons.arrow_drop_down,
                    color:
                        AppColors.appPrimaryBlackColor), // Custom dropdown icon
              ),
            ),
          ),

          SizedBox(height: 20), // Add some spacing

          // Show the selected items (similar to ListView.builder logic)
          Wrap(
            spacing: 10, // Spacing between items
            runSpacing: 10, // Spacing between rows
            children: logic.selectedItems.map((String selectedItem) {
              int index = logic.itemNames.indexOf(selectedItem);
              return InkWell(
                onTap: () {
                  print('Selected item index: $index, Name: $selectedItem');
                  logic.toggleSelection(selectedItem); // Toggle selection
                },
                child: buildItemWithCross(selectedItem, index, logic),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildItemWithCross(
      String itemName, int index, RegisterYourOwnProductController logic) {
    // Check if the item is selected
    bool isSelected = logic.selectedItems.contains(itemName);

    return Row(
      mainAxisSize: MainAxisSize.min,
      // Ensure the row only takes the needed space
      children: [
        // The square container that turns blue when selected
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xFFFBF3D7), // Background color for the item container
          ),
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$itemName', // Display item name
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFB7A06A),
                  ),
                ),
                SizedBox(width: 10),
                // Space between the name and the cross icon

                // Show the cross icon only if the item is selected
                if (isSelected)
                  InkWell(
                    onTap: () {
                      logic.toggleSelection(itemName);
                    },
                    child: Image.asset(
                      'assets/images/crossIcon.png',
                      height: 10,
                      width: 10,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildSubmitButton(
    BuildContext context, RegisterYourOwnProductController logic) {
  return Obx(() => InkWell(
        onTap: () {
          logic.sendData();
        },
        child: Container(
            margin: EdgeInsets.only(top: 50, right: 20),
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xFFB7A06A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: logic.isLoading.value == true
                    ? SizedBox(
                        width: 20.0, // Adjust the width
                        height: 20.0, // Adjust the height
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: AppColors.appWhiteColor,
                        ),
                      )
                    : Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ))),
      ));
}

Widget buildMessage() {
  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Text(
      'We hate spam! We promise to send you only valued information and offers that are tailoured to you! \n \nWe use email and targeted online advertising to send you product and service updates, promotional offers and other marketing communications based on the inofmation we collect about you, such as your email address,general location, and purchase and website browsing history. \n \nWe process your personal data as stated in our Privacy Policy. You may withdraw your consent or manage your prefernces at anytime by clicking the unsubscribe link at  the bottom of any of our marketing emails, or by emailing us at info@opatra.com ',
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFAAAAAA)),
    ),
  );
}

Widget buildYesAndNoButtons(RegisterYourOwnProductController logic) {
  return Obx(() => Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                logic.yesOption.value = true;
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
                          color: logic.yesOption.value == true
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
                logic.yesOption.value = false;
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
                          color: logic.yesOption.value == false
                              ? Color(0xFFB7A06A)
                              : Colors.transparent),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'No',
                      style: TextStyle(
                          color: logic.yesOption.value == false
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

// Widget buildSelectedList() {
//   return Container(
//     margin: EdgeInsets.only(top: 20),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'AIR FLOSS',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'CAVISHAPER',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'CAPSULATE CHAIR',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'DERMISYSYTEM',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//         SizedBox(
//           height: 5,
//         ),
//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'CAPSULATE CHAIR',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Color(0xFFFBF3D7)),
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 child: Row(
//                   children: [
//                     Text(
//                       'DERMISYSYTEM',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFFB7A06A)),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Image.asset(
//                       'assets/images/crossIcon.png',
//                       height: 10,
//                       width: 10,
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ],
//     ),
//   );
// }

Widget buildCustomersDetails() {
  return Row(
    children: [
      Text(
        'Customers Details',
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.appPrimaryBlackColor),
      ),
    ],
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

Widget buildFastNameField(
    BuildContext context, RegisterYourOwnProductController logic) {
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
          height: 65, // Fixed height to include space for potential error
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                  controller: logic.nameController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Focused border color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // General border color
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border for validation errors
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border when focused and error exists
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red, // Red color for the error message
                      fontSize:
                          12, // Optional: Adjust the error message text size
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fast Name cannot be empty'; // Error message
                    }
                    return null; // No error if input is valid
                  },
                ),
              ),
              // Space reserved for the error message to prevent layout shift
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildLastNameField(
    BuildContext context, RegisterYourOwnProductController logic) {
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
          height: 65, // Fixed height to include space for potential error
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                  controller: logic.lastNameController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Focused border color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // General border color
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border for validation errors
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border when focused and error exists
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red, // Red color for the error message
                      fontSize:
                          12, // Optional: Adjust the error message text size
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Name cannot be empty'; // Error message
                    }
                    return null; // No error if input is valid
                  },
                ),
              ),
              // Space reserved for the error message to prevent layout shift
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildAddressField(
    BuildContext context, RegisterYourOwnProductController logic) {
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
          height: 65, // Fixed height to include space for potential error
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                  controller: logic.addressController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Focused border color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // General border color
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border for validation errors
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border when focused and error exists
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red, // Red color for the error message
                      fontSize:
                          12, // Optional: Adjust the error message text size
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address cannot be empty'; // Error message
                    }
                    return null; // No error if input is valid
                  },
                ),
              ),
              // Space reserved for the error message to prevent layout shift
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildPhoneField(
    BuildContext context, RegisterYourOwnProductController logic) {
  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Your Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(width: 5),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 5),
        Container(
          height: 80,
          width: double.infinity,
          child: IntlPhoneField(
            enabled: true,
            flagsButtonPadding: EdgeInsets.only(left: 10),
            decoration: InputDecoration(
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
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.5,
                ),
              ),
              errorStyle: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 10),
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            initialCountryCode: 'GB',
            controller: logic.phoneController,
            showDropdownIcon: true,
            dropdownTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            keyboardType: TextInputType.phone,
            style: TextStyle(color: AppColors.appPrimaryBlackColor),
            onChanged: (phone) {
              // Update the selected country code whenever it changes
              logic.selectedCountryCode.value = phone.countryCode;
              logic.fullPhoneNumber =
                  '${logic.selectedCountryCode.value}${logic.phoneController.text}';

              print('Full Phone Number: ${logic.fullPhoneNumber}');
            },
            validator: (value) {
              if (value == null || value.completeNumber.isEmpty) {
                return 'Phone number cannot be empty';
              }
              if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value.number)) {
                return 'Enter a valid phone number (10-15 digits)';
              }
              return null;
            },
          ),
        ),
      ],
    ),
  );
}

Widget buildAdvisorNameField(
    BuildContext context, RegisterYourOwnProductController logic) {
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
            style: TextStyle(color: AppColors.appPrimaryBlackColor),
            controller: logic.adviceController,
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

Widget buildReceiptNumberField(
    BuildContext context, RegisterYourOwnProductController logic) {
  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          height: 65, // Fixed height to include space for potential error
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                  controller: logic.receiptNumberController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Focused border color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // General border color
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border for validation errors
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border when focused and error exists
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red, // Red color for the error message
                      fontSize:
                          12, // Optional: Adjust the error message text size
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Receipt Number cannot be empty'; // Error message
                  //   }
                  //   return null; // No error if input is valid
                  // },
                ),
              ),
              // Space reserved for the error message to prevent layout shift
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildPlaceOfPurchaseField(
    BuildContext context, RegisterYourOwnProductController logic) {
  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Place of Purchase',
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
          height: 65, // Fixed height to include space for potential error
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  style: TextStyle(color: AppColors.appPrimaryBlackColor),
                  controller: logic.placeOfPurchaseController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // Focused border color
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFEDEDED), // General border color
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border for validation errors
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                        // Red border when focused and error exists
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red, // Red color for the error message
                      fontSize:
                          12, // Optional: Adjust the error message text size
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Place cannot be empty'; // Error message
                    }
                    return null; // No error if input is valid
                  },
                ),
              ),
              // Space reserved for the error message to prevent layout shift
            ],
          ),
        ),
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
      ],
    ),
  );
}

Widget buildCountryField(
    RxString selectedCountry, Function(String) onCountrySelected) {
  return Obx(() => Container(
        margin: EdgeInsets.only(top: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Country',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: Get.context!,
                  showPhoneCode: false,
                  // optional, shows phone code before country name
                  onSelect: (Country country) {
                    onCountrySelected(
                        country.name); // Call external state update function
                  },
                );
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFEDEDED),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        selectedCountry.value.isEmpty
                            ? 'Select Country'
                            : selectedCountry.value,
                        style: TextStyle(
                          color: selectedCountry.value.isEmpty
                              ? Colors.grey
                              : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/images/downIcon.png', // Adjust the image within the container
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ));
}

Widget buildDateOfBirthField(
    Function onBirthdayTap, RegisterYourOwnProductController logic) {
  String formattedDate = logic.dateOfBirth != null
      ? DateFormat('dd/MM/yyyy').format(logic.dateOfBirth!)
      : 'Select Date of Birth';

  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Date of birth',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(width: 5),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: logic.onBirthdayTap, // Trigger the onBirthdayTap function
          child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFEDEDED),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color:
                        logic.dateOfBirth == null ? Colors.grey : Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/calenderIcon.png',
                    width: 20, // Adjust icon size
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDateOfPurchaseField(
    Function onPurchaseTap, RegisterYourOwnProductController logic) {
  String formattedDate = logic.dateOfPurchase != null
      ? DateFormat('dd/MM/yyyy').format(logic.dateOfPurchase!)
      : 'Select Date of Purchase';

  return Container(
    margin: EdgeInsets.only(top: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Date of Purchase',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(width: 5),
            Text(
              '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: logic.onPurchaseTap, // Trigger the onPurchaseTap function
          child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFEDEDED),
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: logic.dateOfPurchase == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Image.asset(
                    'assets/images/calenderIcon.png',
                    width: 20, // Adjust icon size
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
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
