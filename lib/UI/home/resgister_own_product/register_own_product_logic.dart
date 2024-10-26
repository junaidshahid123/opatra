import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constant/AppLinks.dart';
import '../bottom_bar_host/bottom_bar_host_view.dart';

class RegisterYourOwnProductController extends GetxController {
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
      placeOfPurchaseController = TextEditingController();
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state
  String fullPhoneNumber = '';
  final dobController = TextEditingController();
  final doPController = TextEditingController();
  DateTime? dateOfBirth;
  DateTime? dateOfPurchase;
  List<String> selectedItems = [];
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final registerProduct = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  // Scroll to the first error field
  void _scrollToFirstError() {
    final firstErrorPosition =
        registerProduct.currentContext!.findRenderObject()!.paintBounds.topLeft;
    scrollController.animateTo(
      firstErrorPosition.dy,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void toggleSelection(String itemName) {
    if (selectedItems.contains(itemName)) {
      selectedItems
          .remove(itemName); // If the item is already selected, remove it
    } else {
      selectedItems.add(itemName); // If the item is not selected, add it
    }
    update(); // Update the UI after adding or removing the item
  }

  // Sample list of item names
  final List<String> itemNames = [
    'AIR FLOSS',
    'CAVISHAPER',
    'CYROFACE',
    'CELLUSHAPER',
    'CLEO GOLD MASK',
    'CLEANLIFT',
    'CAPSULATE CHAIR',
    'CLEAN PRO5',
    'COOL GLOBE',
    'DERMISONIC',
    'DERMISONIC II',
    'DERMINECK',
    'DERMIEYE',
    'DERMIEYE PLUS',
    'DERMILIGHT',
    'DERMISYSTEM',
    'DERMILIPS',
    'DERMIPORES',
    'DERMISTEAM',
    'DERMIBRASION',
    'EYEPOD',
    'FACECARE +',
    'FLEXILED',
    'GLAMBRUSH',
    'GLOW MASK',
    'GLOW MASK PRO',
    'HANDYLIGHT',
    'HANDYSPA',
    'IBROW',
    'LIGHT MASK',
    'LUX BRUSH',
    'LUMICAP',
    'LUMIQUARTZ FACE WAND',
    'MICROLIFT',
    'NECOLLAGE',
    'OPATRA LIGHT MACHINE (COMPACT)',
    'OPATRA LIGHT PRO MACHINE',
    'OPULENCE BRUSH',
    'PURE BRUSH',
    'PURE DUO',
    'PULSE',
    'PULSE NECK',
    'PROSHAPER',
    'PURIFY BRUSH',
    'ROBOLIGHT',
    'SYNERGY FACE',
    'SYNERGY NECK',
    'SYNERGY EYE',
    'SYNERGY COLLECTION SUITCASE',
    'SMILE TEETH WHITENING',
    'SYNERGY MARBLE',
    'SYNERGY MARBLE EYE',
    'SYNERGY MARBLE ROSE QUARTZ',
    'THERAPAD',
    ' VITA+',
  ];

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
    final isValid = registerProduct.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      _scrollToFirstError(); // Scroll to the first field with an error

      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }

    // Show loading spinner
    isLoading.value = true;
    final url = Uri.parse(
        ApiUrls.registerProduct); // API endpoint for registering the product

    // Format dates
    String formattedDob = convertDateToCorrectFormat(dobController.text);
    String formattedDoP = convertDateToCorrectFormat(doPController.text);

    // Data to be sent in the POST request
    final Map<String, dynamic> data = {
      "product_name": selectedItems,
      "first_name": nameController.text,
      "last_name": lastNameController.text,
      "email": "junaid459561@gmail.com",
      // Email hardcoded, replace if needed
      "address": addressController.text,
      "phone": fullPhoneNumber,
      // Ensure phone number is validated before sending
      "dob": formattedDob,
      // Date of Birth in correct format
      "place_of_purchase": placeOfPurchaseController.text,
      "date_of_purchase": formattedDoP,
      // Date of Purchase in correct format
      "recipient_number": receiptNumberController.text,
      "advisor_name":
          adviceController.text.isEmpty ? "N/A" : adviceController.text,
      // Advisor name optional
      "notification": yesOption.value == true ? true : false,
      // Check if the user agreed to receive notifications
      "country_id": 1,
      // Country ID, change if dynamic based on selection
    };

    print('Data being sent: $data');

    // Fetch the saved token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs

    try {
      // Sending the POST request to the server
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // Ensure the content type is JSON
          "Authorization": "Bearer $token",
          // Add Bearer token to the headers for authentication
        },
        body: jsonEncode(data), // Convert the data to a JSON string
      );

      // Check if the POST request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data sent successfully!');
        Get.snackbar(
          'Success',
          'Request Submitted Successfully',
          backgroundColor: Color(0xFFB7A06A),
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(
            BottomBarHostView()); // Navigate to the bottom navigation bar after success
        isLoading.value = false; // Hide loading spinner
      } else {
        isLoading.value = false; // Hide loading spinner
        print('Failed to send data. Status code: ${response.statusCode}');

        // Extract message from the server's response
        String message;
        try {
          var responseBody = jsonDecode(response.body);
          if (responseBody.containsKey('message')) {
            message = responseBody['message'];
          } else {
            message =
                'Failed to send data. Status code: ${response.statusCode}';
          }
        } catch (e) {
          message = 'Failed to parse server response.';
        }

        Get.snackbar(
          'Error',
          message, // Show the extracted message
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // Handle any exceptions that occur during the POST request
      isLoading.value = false; // Hide loading spinner
      print('Error sending data: $e');

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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
