import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant/AppLinks.dart';
import '../../../models/NotifcationModel.dart';

class NotificationController extends GetxController {
  // Observable variables to hold notifications, loading state, and error message
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  // Function to fetch user notifications
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    error.value = '';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        error.value = 'No token found';
        isLoading.value = false;
        return;
      }

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(Uri.parse(ApiUrls.userNotifications),
          headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          List<dynamic> notificationsJson = data['data'];
          notifications.value = notificationsJson
              .map((json) => NotificationModel.fromJson(json))
              .toList();
        } else {
          error.value = 'Failed to fetch notifications';
        }
      } else {
        error.value = 'Failed to connect to the API';
      }
    } catch (e) {
      error.value = 'Error: $e';
    }

    isLoading.value = false;
  }
}
