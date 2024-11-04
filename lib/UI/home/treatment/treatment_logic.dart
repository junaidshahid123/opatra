import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opatra/UI/home/treatment/treatment_model.dart';
import 'package:opatra/models/MDProductDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppLinks.dart';
import '../bottom_bar_host/bottom_bar_host_model.dart';
import '../select_device/select_device_view.dart';
import 'package:http/http.dart' as http;

class TreatmentController extends GetxController {
  // Reactive variables to manage state
  Rx<Product?> storedDevice = Rx<Product?>(null);
  RxBool deviceExists = false.obs;
  RxBool isLoading = false.obs;
  Rxn<MDGetDevices> mdGetDevices =
      Rxn<MDGetDevices>(); // Observable for device data
  MDGetAppModules? mdGetAppModules;

  @override
  void onInit() {
    super.onInit();
    fetchScheduledDevices(); // Fetch devices on initialization
    fetchAppModules();
  }

  Future<void> activeUser(int id) async {
    Map<String, dynamic> data = {"app_module_id": id};
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
    final url = Uri.parse(ApiUrls.activeUser);
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
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Server response: ${response.body}');
      }
    } catch (e) {
      print('Error during POST request: $e');
    }
  }

  Future<void> fetchAppModules() async {
    final url = Uri.parse(ApiUrls.appModules);

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
        final data = jsonDecode(response.body);
        mdGetAppModules = MDGetAppModules.fromJson(data);
        print('mdGetAppModules: ${mdGetAppModules}');
        update();

        // Check if home.value is true
        final homeModule = data['data'].firstWhere(
            (module) => module['name'] == 'Devices',
            orElse: () => null);
        if (homeModule != null) {
          int deviceId = homeModule['id'];
          print('Devices ID: $deviceId');
          prefs.setInt('devicesID', deviceId); // Store home ID
          activeUser(deviceId);
        }
      } else {
        print(
            'Failed to load mdGetAppModules. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Fetches devices and assigns images to them
  Future<void> fetchScheduledDevices() async {
    isLoading.value = true; // Set loading state
    final url = Uri.parse(ApiUrls.deviceSchedule);

    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

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
        final data = jsonDecode(response.body);
        mdGetDevices.value =
            MDGetDevices.fromJson(data); // Update the observable

        // Load images after devices are fetched
        await loadImagesForProducts();
        print('Fetched devices: ${mdGetDevices.value?.data?.length}');
      } else {
        print(
            'Failed to load scheduled devices. Status Code: ${response.statusCode}');
        Get.snackbar('Error', 'Failed to load scheduled devices.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar('Error', 'An error occurred while fetching devices.',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false; // Stop loading regardless of success or error
    }
  }

  /// Loads images for each product device
  Future<void> loadImagesForProducts() async {
    if (mdGetDevices.value != null) {
      for (var device in mdGetDevices.value!.data!) {
        if (device.productId != null) {
          String? imageUrl = await fetchImageUrlForDevice(device.productId!);
          if (imageUrl != null) {
            device.imageUrl = imageUrl; // Assign the image URL to the device
          }
        }
      }
    }
  }

  /// Fetches the image URL for a specific device based on its ID
  Future<String?> fetchImageUrlForDevice(String deviceId) async {
    final url = Uri.parse(
        "https://opatra.fai-tech.online/api/product/$deviceId/images");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        print('Error: No token found. Please log in again.');
        return null;
      }

      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['images'] != null && data['images'].isNotEmpty) {
          return data['images'][0]['src']; // Return the first image URL
        } else {
          print("No images found for device $deviceId.");
        }
      } else {
        print(
            "Failed to fetch image for device $deviceId. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image for device $deviceId: $e");
    }
    return null; // Return null if image URL not found
  }

  /// Checks if a device exists in SharedPreferences
  Future<void> checkDeviceInStorage() async {
    deviceExists.value =
        await getDevice(); // Update the RxBool value based on result
  }

  /// Retrieves the stored device from SharedPreferences
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

  /// Navigates to the SelectDeviceView when a device is selected
  void onSelectDeviceTap() {
    Get.to(() => SelectDeviceView());
  }
}
