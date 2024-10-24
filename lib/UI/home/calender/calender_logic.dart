import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<void> deviceSchedule(RxString time) async {
    // Convert the RxString time to a List<String>
    List<String> timeList = time.value.split(','); // Adjust the delimiter as needed

    // Create the data map to be sent as JSON
    Map<String, dynamic> data = {
      "product_id": 'id',
      "product_name": 'name',
      "days": selectedDays,
      "time": timeList, // Pass the list to time
    };
    print('time===${time}');
    print('timeList===${timeList}');
    print('data===${data}');

    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? token = prefs.getString('token'); // Get the token from shared prefs
    //   String jsonBody = json.encode(data);
    //
    //   final url = Uri.parse(ApiUrls.deviceSchedule);
    //
    //   try {
    //     final response = await http.post(
    //       url,
    //       headers: {
    //         "Content-Type": "application/json", // Ensure the content type is JSON
    //         "Authorization": "Bearer $token", // Add Bearer token to the headers
    //       },
    //       body:jsonBody, // Convert the data to a JSON string
    //     );
    //
    //     // Check if the POST request was successful
    //     if (response.statusCode == 200 || response.statusCode == 201) {
    //       print('Data sent successfully!');
    //       Get.snackbar(
    //         'Success',
    //         'Request Submitted Successfully',
    //         backgroundColor: AppColors.appPrimaryBlackColor,
    //       );
    //       // Get.offAll(BottomBarHost());
    //       isLoading.value = false;
    //     } else {
    //       isLoading.value = false;
    //       print('Failed to send data. Status code: ${response.statusCode}');
    //     }
    //   } catch (e) {
    //     isLoading.value = false;
    //     print('Error sending data: $e');
    //   }
  }
}
