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
      // "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAFA2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CiAgICAgICAgPHJkZjpSREYgeG1sbnM6cmRmPSdodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjJz4KCiAgICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICAgICAgICB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8nPgogICAgICAgIDxkYzp0aXRsZT4KICAgICAgICA8cmRmOkFsdD4KICAgICAgICA8cmRmOmxpIHhtbDpsYW5nPSd4LWRlZmF1bHQnPk9yYW5nZSAgQ29tbXVuaXR5IEZhbWlseSBDbHViIExvZ28gLSAxPC9yZGY6bGk+CiAgICAgICAgPC9yZGY6QWx0PgogICAgICAgIDwvZGM6dGl0bGU+CiAgICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CgogICAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgICAgICAgeG1sbnM6QXR0cmliPSdodHRwOi8vbnMuYXR0cmlidXRpb24uY29tL2Fkcy8xLjAvJz4KICAgICAgICA8QXR0cmliOkFkcz4KICAgICAgICA8cmRmOlNlcT4KICAgICAgICA8cmRmOmxpIHJkZjpwYXJzZVR5cGU9J1Jlc291cmNlJz4KICAgICAgICA8QXR0cmliOkNyZWF0ZWQ+MjAyNC0wOS0xODwvQXR0cmliOkNyZWF0ZWQ+CiAgICAgICAgPEF0dHJpYjpFeHRJZD40NzJkN2E4Yi1jNjE5LTQ5MmMtOTZmNi1hN2Q2NzczMWU3MzI8L0F0dHJpYjpFeHRJZD4KICAgICAgICA8QXR0cmliOkZiSWQ+NTI1MjY1OTE0MTc5NTgwPC9BdHRyaWI6RmJJZD4KICAgICAgICA8QXR0cmliOlRvdWNoVHlwZT4yPC9BdHRyaWI6VG91Y2hUeXBlPgogICAgICAgIDwvcmRmOmxpPgogICAgICAgIDwvcmRmOlNlcT4KICAgICAgICA8L0F0dHJpYjpBZHM+CiAgICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CgogICAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgICAgICAgeG1sbnM6cGRmPSdodHRwOi8vbnMuYWRvYmUuY29tL3BkZi8xLjMvJz4KICAgICAgICA8cGRmOkF1dGhvcj5GYWkgRGV2PC9wZGY6QXV0aG9yPgogICAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgoKICAgICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0nJwogICAgICAgIHhtbG5zOnhtcD0naHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyc+CiAgICAgICAgPHhtcDpDcmVhdG9yVG9vbD5DYW52YSAoUmVuZGVyZXIpPC94bXA6Q3JlYXRvclRvb2w+CiAgICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgICAgICAgCiAgICAgICAgPC9yZGY6UkRGPgogICAgICAgIDwveDp4bXBtZXRhPi5/7rcAADZCSURBVHic7NwvjJtlAMfx5217xzg3MTG1DNfJHYoExBQJCmYnCRgEaPQUAs2CY/bmSHpiilDFTV7dmlMntmSodx2lLYIsZH+S7a7v+3b8+vnYNs/7tMnb7/s87duqrutVAQD+13qbngAAsD5BB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQdAAIIOgAEEHQACCDoABBA0AEggKADQABBB4AAgg4AAQQd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0aKpx1mzpn7q66vvz5yp/v7+evDgQVVVzZs3rz5pb699+/a98XIo0zM0NPTKpeMfz52bMugXLlyY8LuGhoYafEeC3tHRUadOnarTp09Xz7O97qampvpi+/b6corbGC86eeLE85/nzp1by5Ytq4Pd3VM+oARvY9bY2NjT/3sSfBiePn36fH9yyZIlUz7TOpl79+7V48ePq7m52T41M2J0dLTGxsZq8eLF/sd4Lwg6AARwKA4AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAgg6AAQQdAAIIOgAEEDQASCAoANAAEEHgACCDgABBB0AAvwFje+gbZQP+X0AAAAASUVORK5CYII="
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
          snackPosition: SnackPosition.TOP,
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
