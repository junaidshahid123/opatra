import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../constant/AppLinks.dart';
import '../BottomBarHost.dart';

class WarrantyClaimController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool yesOption = false.obs;
  RxString selectedCountry = 'United Kingdom'.obs;
  final fastNameController = TextEditingController(),
      nameController = TextEditingController(),
      lastNameController = TextEditingController(),
      emailController = TextEditingController(),
      addressController = TextEditingController(),
      adviceController = TextEditingController(),
      phoneController = TextEditingController(),
      messageController = TextEditingController(),
      receiptNumberController = TextEditingController(),
      issueFoundController = TextEditingController(),
      placeOfPurchaseController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final warrantyClaims = GlobalKey<FormState>();
  DateTime? dateOfBirth;
  DateTime? dateOfPurchase;
  final dobController = TextEditingController();
  final doPController = TextEditingController();
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state
  String fullPhoneNumber = '';
  var selectedImage = ''.obs; // To hold the path of the selected image
  var base64Image = ''.obs; // To hold the Base64 representation of the image

  void showImageSourceDialog(WarrantyClaimController logic) {
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
                      image_picker.ImageSource.camera); // Use alias here
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Camera'),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  logic.pickImage(
                      image_picker.ImageSource.gallery); // Use alias here
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

  // Method to pick an image from the camera or gallery
  Future<void> pickImage(image_picker.ImageSource source) async {
    final picker = image_picker.ImagePicker();
    try {
      final pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        selectedImage.value = pickedImage.path; // Store the path of the image
        base64Image.value = await convertImageToBase64(
            File(selectedImage.value)); // Convert to Base64
        print('Image picked: ${pickedImage.path}'); // Debug print
        print(
            'Base64 image: ${base64Image.value.substring(0, 30)}...'); // Print part of the Base64 for debugging
      } else {
        print('No image selected.'); // Debug print
      }
    } catch (e) {
      print('Error picking image: $e'); // Error handling
    }
  }

  Future<String> convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes); // Return the Base64 string
  }

  void setSelectedCountry(String country) {
    selectedCountry.value = country;
  }

  Future<void> onBirthdayTap() async {
    print("Opening date picker for Date of Birth...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate =
        DateTime(currentDate.year - 18, currentDate.month, currentDate.day);
    DateTime firstDate = DateTime(currentDate.year - 100);
    DateTime lastDate = initialDate;

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfBirth = pickedDate;
      dobController.clear();
      dobController.text = DateFormat('dd/MM/yyyy').format(dateOfBirth!);
      print("Selected Date of Birth: $pickedDate");
      update();
    } else {
      print("Date of Birth is not selected");
    }
  }

  Future<void> onPurchaseTap() async {
    print("Opening date picker for Date of Purchase...");

    DateTime currentDate = DateTime.now();
    DateTime initialDate = currentDate;
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = currentDate;

    print("Current Date: $currentDate");
    print("Initial Date: $initialDate");
    print("First Date: $firstDate");
    print("Last Date: $lastDate");

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      dateOfPurchase = pickedDate;
      doPController.clear();
      doPController.text = DateFormat('dd/MM/yyyy').format(dateOfPurchase!);
      print("Selected Date of Purchase: $pickedDate");
      update();
    } else {
      print("Date of Purchase is not selected");
    }
  }

  Future<void> sendData() async {
    // Validate the form using formKey
    final isValid = warrantyClaims.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }

    // Show loading spinner
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.warrantyClaims);

    String formattedDob = convertDateToCorrectFormat(dobController.text);
    String formattedDoP = convertDateToCorrectFormat(doPController.text);

    // Data to be sent in the POST request
    final Map<String, dynamic> data = {
      "product_name": "Product 1", // Add this field
      "first_name": nameController.text,
      "last_name": lastNameController.text,
      "email": "junaid459561@gmail.com",
      "address": addressController.text,
      "phone": fullPhoneNumber,
      "dob": formattedDob,
      "place_of_purchase": placeOfPurchaseController.text,
      "date_of_purchase": formattedDoP,
      "recipient_number": receiptNumberController.text,
      "advisor_name": "", // You can set this based on your logic
      "notification": yesOption.value == true ? true : false,
      "country_id": 1,
      "issue_found": 'bfchjbfchf', // Add this field
      "image": base64Image.value, // Include the Base64 image
    };

    print('data===${data}');

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString('token'); // Get the token from shared prefs
    // try {
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json", // Ensure the content type is JSON
    //       "Authorization": "Bearer $token", // Add Bearer token to the headers
    //     },
    //     body: jsonEncode(data), // Convert the data to a JSON string
    //   );
    //
    //   // Check if the POST request was successful
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     print('Data sent successfully!');
    //     Get.snackbar(
    //       'Success',
    //       'Request Submitted Successfully',
    //       backgroundColor: Color(0xFFB7A06A),
    //     );
    //     Get.offAll(BottomBarHost());
    //     isLoading.value = false;
    //   } else {
    //     isLoading.value = false;
    //     print('Failed to send data. Status code: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   isLoading.value = false;
    //   print('Error sending data: $e');
    // }
  }

  String convertDateToCorrectFormat(String date) {
    List<String> dateParts = date.split('/'); // Split the date by '/'

    if (dateParts.length == 3) {
      // Re-arrange the date parts: [2] for year, [1] for month, [0] for day
      return '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}'; // Returns YYYY-MM-DD format
    } else {
      return date; // Return the original date if format is incorrect
    }
  }
}
