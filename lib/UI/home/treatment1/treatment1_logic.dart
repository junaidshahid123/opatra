import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/AppColors.dart';
import '../../../constant/AppLinks.dart';
import 'package:http/http.dart' as http;

import '../bottom_bar_host/bottom_bar_host_view.dart';

class Treatment1Controller extends GetxController {
  RxBool isLoading = false.obs;

  List<int> selectedAreasList = [];

  List<Map<String, dynamic>> areas = [
    {'number': 1, 'name': 'Forehead'},
    {'number': 2, 'name': 'Right Cheek'},
    {'number': 3, 'name': 'Left Cheek'},
    {'number': 4, 'name': 'Chin'},
  ];

  // Map with integer keys instead of names
  Map<int, bool> selectedAreas = {
    1: false, // Represents Forehead
    2: false, // Represents Cheeks
    3: false, // Represents Nose
    4: false, // Represents Chin
  };

  // Toggle selection status of a numbered area
  void toggleAreaSelection(int area) {
    selectedAreas[area] = !selectedAreas[area]!;
    // Add or remove the area from the selectedAreasList based on its new status
    if (selectedAreas[area]!) {
      // Area is now selected, add to the list
      selectedAreasList.add(area);
    } else {
      // Area is now deselected, remove from the list
      selectedAreasList.remove(area);
    }

    update(); // Update UI
  }

  // Check if a numbered area is selected
  bool isAreaSelected(int area) {
    return selectedAreas[area] ?? false;
  }

  // Select area based on index (1-based for consistency with new keys)
  void selectAreaByIndex(int index) {
    toggleAreaSelection(index + 1);
  }

  // Optionally, you can expose the selectedAreasList
  List<int> getSelectedAreas() {
    return selectedAreasList;
  }

  Future<void> deviceSchedule(String time, int product_id, String product_name,
      List<DateTime> selectedDays) async {
    // Show loading spinner
    isLoading.value = true;

    // Convert the RxString time to a List<String>
    List<String> timeList = time.split(',');
    print('Converted timeList: $timeList');

    // Format selectedDays to "dd-MM-yyyy" format
    List<String> formattedDays = formatDays(selectedDays);
    print('Formatted selectedDays: $formattedDays');

    // Convert days and timeList to JSON strings
    String daysJson = jsonEncode(formattedDays);
    String timeJson = jsonEncode(timeList);
    // String productNameJson = jsonEncode(product_name);
    print('Days JSON: $daysJson');
    print('Time JSON: $timeJson');
// Create the data map to be sent as JSON
    Map<String, dynamic> data = {
      "product_id": product_id,
      "product_name": product_name, // Use the raw string, not jsonEncode
      "days": formattedDays, // Use the list directly, not jsonEncode
      "time": timeList, // Use the list directly, not jsonEncode
      "areas": selectedAreasList, // Use the list directly, not jsonEncode
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

class Area {
  final int number;
  final String name;

  Area({required this.number, required this.name});
}

List<Area> areas = [
  Area(number: 1, name: 'Forehead'),
  Area(number: 2, name: 'Right Cheek'),
  Area(number: 3, name: 'Left Cheek'),
  Area(number: 4, name: 'Chin'),
];
