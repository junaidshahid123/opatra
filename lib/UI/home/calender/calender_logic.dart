import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:opatra/UI/home/bottom_bar_host/bottom_bar_host_logic.dart';
import 'package:opatra/UI/home/bottom_bar_host/bottom_bar_host_view.dart';
import 'package:opatra/constant/AppColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/AppLinks.dart';

class CalenderController extends GetxController {
  // List to store selected days
  var selectedDays = <DateTime>[].obs;
  RxBool isLoading = false.obs;

  // Method to update selected days
  void updateSelectedDays(List<DateTime> days) {
    selectedDays.assignAll(days);
    print("Selected Days: $selectedDays");
  }

  Future<void> deviceSchedule(
      RxString time, int product_id, String product_name) async {
    // Show loading spinner
    isLoading.value = true;

    // Convert the RxString time to a List<String>
    List<String> timeList = time.value.split(',');
    print('Converted timeList: $timeList');

    // Format selectedDays to "dd-MM-yyyy" format
    List<String> formattedDays = formatDays(selectedDays);
    print('Formatted selectedDays: $formattedDays');

    // Convert days and timeList to JSON strings
    String daysJson = jsonEncode(formattedDays);
    String timeJson = jsonEncode(timeList);
    String productNameJson = jsonEncode(product_name);
    print('Days JSON: $daysJson');
    print('Time JSON: $timeJson');
// Create the data map to be sent as JSON
    Map<String, dynamic> data = {
      "product_id": product_id,
      "product_name": product_name, // Use the raw string, not jsonEncode
      "days": formattedDays, // Use the list directly, not jsonEncode
      "time": timeList, // Use the list directly, not jsonEncode
    };
    print('Data to be sent: $data');

    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found. Make sure the user is logged in.');
      isLoading.value = false; // Set loading to false if there's no token
      return;
    } else {
      print('Token retrieved: $token');
    }

    String jsonBody = json.encode(data);
    final url = Uri.parse(ApiUrls.deviceSchedule);
    print('Sending request to: $url');
    try {
      print('Sending data to: $url');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonBody,
      );

      // Check if the POST request was successful
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data sent successfully! Status code: ${response.statusCode}');
        print('Server response: ${response.body}');
        isLoading.value = false;

        Get.snackbar(
          'Success',
          'Request Submitted Successfully',
          backgroundColor: AppColors.appPrimaryBlackColor,
        );
        Get.offAll(BottomBarHostView());
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Server response: ${response.body}');
        isLoading.value = false; // Make sure to set loading to false on failure
      }
    } catch (e) {
      print('Error during POST request: $e');
      isLoading.value = false; // Ensure loading is set to false on error
    }
  }

  // Helper function to format each DateTime in selectedDays
  List<String> formatDays(List<DateTime> days) {
    return days.map((day) => DateFormat("dd-MM-yyyy").format(day)).toList();
  }
}
