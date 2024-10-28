import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment/treatment_model.dart';
import 'package:opatra/models/MDProductDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppLinks.dart';
import '../select_device/select_device_view.dart';
import 'package:http/http.dart' as http;

class TreatmentController extends GetxController {
  Rx<Product?> storedDevice = Rx<Product?>(null);
  RxBool deviceExists = false.obs;
  RxBool isLoading = false.obs;
  Rxn<MDGetDevices> mdGetDevices =
      Rxn<MDGetDevices>(); // Observable for device data
  var productImages = <int, String>{}.obs; // Map to store images with product_id as key


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // checkDeviceInStorage();
    fetchScheduledDevices();
  }
  // Future<void> fetchProductImage(int productId) async {
  //   final url = Uri.parse("${ApiUrls.productImage}/$productId");
  //
  //   try {
  //     final response = await http.get(url);
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final imageUrl = data['image_url']; // Replace with the actual key from API response
  //       productImages[productId] = imageUrl; // Store image URL in the map
  //     } else {
  //       print("Failed to fetch image for product $productId. Status Code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error fetching image for product $productId: $e");
  //   }
  // }
  //
  // Future<void> loadImagesForProducts() async {
  //   if (mdGetDevices.value != null) {
  //     for (var device in mdGetDevices.value!.data!) {
  //       if (device.productId != null) {
  //         await fetchProductImage(device.productId!);
  //       }
  //     }
  //   }
  // }

  Future<void> checkDeviceInStorage() async {
    deviceExists.value =
        await getDevice(); // Update the RxBool value based on result
  }

  Future<bool> getDevice() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? deviceJson = sharedPreferences.getString('selectedDevice');

    if (deviceJson != null) {
      Map<String, dynamic> deviceMap = jsonDecode(deviceJson);
      storedDevice.value = Product.fromJson(deviceMap);
      print('Retrieved Device: ${storedDevice.value!.title}');
      return true;
    } else {
      print('No device found in SharedPreferences.');
      return false;
    }
  }

  void onSelectDeviceTap() {
    Get.to(() => SelectDeviceView());
  }

  Future<void> fetchScheduledDevices() async {
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.deviceSchedule);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs
    if (token == null || token.isEmpty) {
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading.value = false; // Stop loading if no token
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
        mdGetDevices.value =
            MDGetDevices.fromJson(data); // Update the observable
        print('Fetched devices: ${mdGetDevices.value?.data?.length}');
      } else {
        isLoading.value = false;
        print(
            'Failed to load scheduled devices. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    } finally {
      isLoading.value = false; // Stop loading regardless of success or error
    }
  }
}
