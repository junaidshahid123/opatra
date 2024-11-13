import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/AppLinks.dart';
import '../bottom_bar_host/bottom_bar_host_view.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = false.obs;

  final phoneController = TextEditingController(),
      nameController = TextEditingController(),
      emailController = TextEditingController();
  final editProfile = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  var selectedCountryCode = ''.obs; // Default country code
  bool isPhoneValid = true; // Track phone validation state
  String fullPhoneNumber = '';

  Future<void> sendData() async {
    // Validate the form using formKey
    final isValid = editProfile.currentState!.validate();

    // If the form is not valid, show validation errors and stop further execution
    if (!isValid) {
      autoValidateMode =
          AutovalidateMode.onUserInteraction; // Enable auto validation
      update(); // Call update() to refresh the UI
      return; // Stop execution here since the form is invalid
    }
    if (phoneController.text.isEmpty) {
      Get.snackbar('Alert', 'Phone Field cannot be empty',
          backgroundColor: Colors.red);
      return;
    }

    // Show loading spinner
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.editProfile);

    // Data to be sent in the POST request
    final Map<String, dynamic> data = {
      "name": nameController.text,
      "phone": fullPhoneNumber,
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
        Get.offAll(BottomBarHostView());
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
