import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constant/AppColors.dart';
import '../../../constant/AppLinks.dart';
import '../../auth/login/login_view.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

import '../../auth/signup/signup_view.dart';

class SettingsController extends GetxController {
  RxBool showReasonField = false.obs;
  RxInt selectedIndex = 0.obs;
  RxBool usd = false.obs;
  RxBool pound = false.obs;
  RxBool euro = false.obs;
  RxBool isCurrencyDropDown = false.obs;
  RxString selectedCurrency = ''.obs; // Observable search query
  RxBool isLoading = false.obs;
  var selectedImage = ''.obs; // To hold the path of the selected image
  // Inside your SettingsController
  RxString base64Image = ''.obs;
  TextEditingController reasonController = TextEditingController();

  void showImageSourceDialog(SettingsController logic) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                onTap: () {
                  logic.pickImage(
                      image_picker.ImageSource.camera); // Pick from camera
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Camera'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  logic.pickImage(
                      image_picker.ImageSource.gallery); // Pick from gallery
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(image_picker.ImageSource source) async {
    final picker = image_picker.ImagePicker();

    try {
      final pickedImage = await picker.pickImage(source: source);

      if (pickedImage != null) {
        // Update selected image path and base64 encoded value
        selectedImage.value = pickedImage.path;
        base64Image.value =
            await convertImageToBase64(File(selectedImage.value));

        print('Image picked: ${pickedImage.path}'); // Log selected image path
        print(
            'Base64 image: ${base64Image.value.substring(0, 30)}...'); // Log part of Base64 data
      } else {
        print('No image selected.'); // Log if no image was selected
      }
    } catch (e) {
      print('Error picking image: $e'); // Handle any errors
    }
  }

  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes); // Return the Base64 string
  }

  void showDialogForCurrency(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFB7A06A),
          child: Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFB7A06A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Select Currency',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appWhiteColor),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                makeUsDollar();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: usd.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: usd.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'US Dollar',
                                    style: TextStyle(
                                      color: usd.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makeEuro();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: euro.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: euro.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Euro',
                                    style: TextStyle(
                                      color: euro.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makePound();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: pound.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: pound.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Pound',
                                    style: TextStyle(
                                      color: pound.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /
                      2.5, // Adjusted height for new content
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Are you sure you want to Log Out?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No button
                            InkWell(
                              onTap: () {
                                Get.back(); // Close the dialog
                                selectedIndex.value = -1;
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  // Grey color for "No" button
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Yes button
                            InkWell(
                              onTap: () {
                                // Add your logout functionality here
                                logOut();
                              },
                              child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB7A06A),
                                    // Custom color for "Yes" button
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: isLoading.value == true
                                          ? SizedBox(
                                              width: 20.0, // Adjust the width
                                              height: 20.0, // Adjust the height
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            )
                                          : Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /
                      (showReasonField.value ? 2 : 2.5),
                  // Adjusted height for new content
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          showReasonField.value
                              ? "Please Fill in the Reason for Account Deletion"
                              : "Are you sure you want to Delete Account?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        if (showReasonField.value) ...[
                          TextField(
                            cursorColor: AppColors.appPrimaryBlackColor,
                            // Set cursor color to black

                            controller: reasonController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Enter reason here...",
                              hintStyle: TextStyle(
                                  color: AppColors.appPrimaryBlackColor
                                      .withOpacity(0.5)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: AppColors
                                      .appPrimaryBlackColor, // Set focused border color to black
                                ),
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors
                                  .appPrimaryBlackColor, // Set input text color to black
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No button
                            InkWell(
                              onTap: () {
                                Get.back(); // Close the dialog
                                selectedIndex.value = -1;
                                showReasonField.value = false; // Reset state
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Yes button
                            InkWell(
                              onTap: () {
                                if (!showReasonField.value) {
                                  // Show reason input field if not already displayed
                                  showReasonField.value = true;
                                } else {
                                  // Call deleteAccount with the entered reason
                                  if (reasonController.text.isEmpty) {
                                    Get.snackbar('Alert', 'Please Enter Reason',
                                        backgroundColor: Colors.red);
                                  } else {
                                    deleteAccount(reasonController.text);
                                  }
                                }
                              },
                              child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB7A06A),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: isLoading.value
                                          ? SizedBox(
                                              width: 20.0,
                                              height: 20.0,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            )
                                          : Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  Future<void> logOut() async {
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.logoutUrl);
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs

    //  Ensure the token exists before proceeding
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Include the Bearer token in headers
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');
        prefs.remove('token');
        Get.snackbar('Success', 'Log Out Successfully');
        Get.offAll(LoginView());
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to log out user';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading spinner
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> deleteAccount(String reason) async {
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.deleteAccount);

    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Ensure the token exists before proceeding
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "reason": reason, // Add the reason parameter in the body
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        url,
        headers: headers,
        body: json.encode(body), // Encode the body as JSON
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========$responseData');
        prefs.remove('token');
        Get.snackbar('Success', 'Account Deleted Successfully');
        Get.offAll(() => SignupView());
      } else {
        isLoading.value = false;

        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to delete account';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void makeUsDollar() {
    usd.value = true;
    euro.value = false;
    pound.value = false;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'US Dollar';
    update();
  }

  void makeEuro() {
    usd.value = false;
    euro.value = true;
    pound.value = false;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'Euro';
    update();
  }

  void makePound() {
    usd.value = false;
    euro.value = false;
    pound.value = true;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'Pound';
    update();
  }
}
