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
    // Step 1: Define the URL for the API endpoint
    final url = Uri.parse(ApiUrls.appModules);
    print('Step 1: API endpoint URL - $url');

    // Step 2: Retrieve token from SharedPreferences
    print('Step 2: Retrieving token from SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Step 3: Check if token exists and is not empty
    if (token == null || token.isEmpty) {
      print('Step 3: No token found. Displaying error message.');
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    } else {
      print('Step 3: Token retrieved - $token');
    }

    // Step 4: Prepare headers for the GET request
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    print('Step 4: Headers prepared - $headers');

    try {
      // Step 5: Send GET request to fetch app modules
      print('Step 5: Sending GET request to $url');
      final response = await http.get(url, headers: headers);

      // Step 6: Check response status code
      print(
          'Step 6: GET request completed. Status code - ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Step 6: Data successfully fetched');

        // Step 7: Decode response body
        final data = jsonDecode(response.body);
        print('Step 7: Response body decoded - $data');

        // Step 8: Map JSON to mdGetAppModules object
        mdGetAppModules = MDGetAppModules.fromJson(data);
        print('Step 8: mdGetAppModules object created - $mdGetAppModules');

        // Step 9: Update UI or state
        update();

        // Step 10: Check for specific module ('Devices')
        final homeModule = data['data'].firstWhere(
            (module) => module['name'] == 'Device',
            orElse: () => null);
        if (homeModule != null) {
          int deviceId = homeModule['id'];
          print('Step 10: Devices ID found - $deviceId');

          // Step 11: Store Device ID in SharedPreferences
          prefs.setInt('devicesID', deviceId);
          print('Step 11: Devices ID stored in SharedPreferences');

          // Step 12: Call activeUser with Device ID
          activeUser(deviceId);
        } else {
          print('Step 10: Devices module not found in the response data');
        }
      } else {
        // Handle case where status code is not 200
        print(
            'Step 6: Failed to load mdGetAppModules. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Step 13: Handle and log any errors that occur
      print('Step 13: Error during GET request - $e');
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
    final url = Uri.parse("https://opatra.app/api/product/$deviceId/images");

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
