import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/create_schedule/create_schedule_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constant/AppLinks.dart';
import '../../../models/MDProducts.dart';

class SelectDeviceController extends GetxController {
  MDProducts? mdProducts;
  List<Products> devices = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllProducts();
  }

  // Function to handle the device selection and store it in SharedPreferences
  Future<void> selectAndStoreDevice(int index) async {
    // Get the current device object
    var selectedDevice = devices[index];

    // Serialize the object to JSON format
    String deviceJson = jsonEncode(selectedDevice.toJson());

    // Save the JSON string to SharedPreferences
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('selectedDevice', deviceJson);

    // For confirmation, print the device ID and the JSON
    print('Selected Device ID: ${selectedDevice.id}');
    print('Stored Device JSON: $deviceJson');
    Get.to(() => CreateScheduleView());
  }

  Future<void> fetchAllProducts() async {
    devices
        .clear(); // You may want to retain this only if you always want to refresh the list
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.products);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Include the Bearer token in headers
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        isLoading.value = false;

        final data = jsonDecode(response.body);
        print('mdProducts: $data');
        mdProducts = MDProducts.fromJson(data);
        print('mdProducts: $mdProducts');
        update();

        for (int i = 0; i < mdProducts!.products!.length; i++) {
          print('title============${mdProducts!.products![i].title}');
          print(
              'productType============${mdProducts!.products![i].productType}');

          // Check if the productType contains the text 'device' anywhere
          if (mdProducts!.products![i].productType!
              .toLowerCase()
              .contains('device')) {
            // Check if the product is already in the devices list to avoid duplicates
            if (!devices.contains(mdProducts!.products![i])) {
              devices.add(mdProducts!.products![i]);
            }
          }
        }

        print('devices=======${devices.length}');
      } else {
        isLoading.value = false;
        print('Failed to load products. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }
}
