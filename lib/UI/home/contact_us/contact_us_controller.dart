import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../BottomBarHost.dart';

class ContactUsController extends GetxController {
  RxBool isLoading = false.obs;
  final subjectController = TextEditingController(),
      nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      messageController = TextEditingController();
  final contactUs = GlobalKey<FormState>();
  RxBool emailOption = false.obs;
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state


  Future<void> sendData() async {
    String fullPhoneNumber = '${selectedCountryCode.value}${phoneController.text}';

    print('Full Phone Number: $fullPhoneNumber');


    // Validate the form using formKey
    final isValid = contactUs.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }

    // Show loading spinner
    isLoading.value = true;
    final url = Uri.parse(
        'https://opatra.fai-tech.online/api/contact-us'); // API endpoint

    // Data to be sent in the POST request
    final Map<String, dynamic> data = {
      "subject": subjectController.text,
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "message": messageController.text,
      "notified_by": emailOption.value==true ? 'email' : 'phone',
    };
    print('data===${data}');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Ensure the content type is JSON
          "Authorization": "Bearer $token", // Add Bearer token to the headers
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
        );
        Get.offAll(BottomBarHost());
        isLoading.value = false;
      } else {
        isLoading.value = false;
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error sending data: $e');
    }
  }
}
