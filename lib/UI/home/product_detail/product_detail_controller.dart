import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constant/AppLinks.dart';
import '../../../models/MDProductDetail.dart';
import '../../../models/MDProductDetailImages.dart';
import '../bag/bag_controller.dart';
import '../bottom_bar_host/bottom_bar_host_model.dart';

class ProductDetailController extends GetxController {
  MDProductDetail? mdProductDetail;
  MDProductDetailImages? mdProductDetailImages;
  RxInt quantity = 1.obs;
  var productDetail = MDProductDetail().obs;
  var price;
  MDGetAppModules? mdGetAppModules;

  tapOnDecrement() {
    if (quantity.value > 1) {
      quantity.value--;
      update();
    }
  }

  tapOnIncrement() {
    quantity.value++;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAppModules();
    update();
  }

  Future<void> activeUser(int id) async {
    // Step 1: Preparing data to be sent
    Map<String, dynamic> data = {"app_module_id": id};
    print('Step 1: Data to be sent - $data');

    // Step 2: Retrieve the token from shared preferences
    print('Step 2: Retrieving token from SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // Step 3: Check if the token exists
    if (token == null) {
      print('Step 3: No token found. Make sure the user is logged in.');
      return;
    } else {
      print('Step 3: Token retrieved - $token');
    }

    // Step 4: Encoding data to JSON format
    String jsonBody = json.encode(data);
    print('Step 4: JSON-encoded data - $jsonBody');

    // Step 5: Preparing URL for the API endpoint
    final url = Uri.parse(ApiUrls.activeUser);
    print('Step 5: API endpoint URL - $url');

    try {
      // Step 6: Sending POST request to the server
      print('Step 6: Sending POST request to $url');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonBody,
      );

      // Step 7: Checking response status code
      print('Step 7: POST request completed. Status code - ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Step 7: Data sent successfully for App Modules!');
        print('Step 8: Server response - ${response.body}');
      } else {
        print('Step 7: Failed to send data. Status code - ${response.statusCode}');
        print('Step 8: Server error response - ${response.body}');
      }
    } catch (e) {
      // Step 9: Catching and logging any errors during the POST request
      print('Step 9: Error during POST request - $e');
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
      print('Step 6: GET request completed. Status code - ${response.statusCode}');

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

        // Step 10: Check for specific module ('Product Detail')
        final homeModule = data['data'].firstWhere(
                (module) => module['name'] == 'Product Details',
            orElse: () => null);
        if (homeModule != null) {
          int productDetailID = homeModule['id'];
          print('Step 10: Product Detail ID found - $productDetailID');

          // Step 11: Store Product Detail ID in SharedPreferences
          prefs.setInt('devicesID', productDetailID);
          print('Step 11: Product Detail ID stored in SharedPreferences');

          // Step 12: Call activeUser with Product Detail ID
          activeUser(productDetailID);
        } else {
          print('Step 10: Product Detail module not found in the response data');
        }
      } else {
        // Handle case where status code is not 200
        print('Step 6: Failed to load mdGetAppModules. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Step 13: Handle and log any errors that occur
      print('Step 13: Error during GET request - $e');
    }
  }

   addToBag(ProductA? product, String selectedCurrency) {
    print('addToBag called');

    // Ensure the product is not null
    if (product != null) {
      Get.find<BagController>()
          .addProductToBag(product, quantity.value, selectedCurrency);

      print('Product added to bag: ${product.id}, Quantity: ${quantity.value}');

      // Call calculateSubtotal to update the subtotal after adding the product
      Get.find<BagController>().calculateSubtotal();
    } else {
      print('Error: Product is null. Cannot add to bag.');
    }
  }

  Future<void> fetchProductDetail(int id) async {
    final url = Uri.parse('${ApiUrls.baseUrl}/product/${id}');

    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs
    // Ensure the token exists before proceeding
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
        // Successfully received data
        final data = jsonDecode(response.body);
        print('fetchProductDetail: $data');
        mdProductDetail = MDProductDetail.fromJson(data);
        print('mdProductDetail: ${mdProductDetail!.product!.image!.src}');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print(
            'Failed to load fetchProductDetail. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
