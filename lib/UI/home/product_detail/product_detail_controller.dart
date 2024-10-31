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
    Map<String, dynamic> data = {"app_module_id": id};
    print('Data to be sent: $data');

    // Get the token from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('No token found. Make sure the user is logged in.');
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
            (module) => module['name'] == 'Product Detail',
            orElse: () => null);
        if (homeModule != null) {
          int productDetailID = homeModule['id'];
          print('Devices ID: $productDetailID');
          prefs.setInt('devicesID', productDetailID); // Store home ID
          activeUser(productDetailID);
        }
      } else {
        print(
            'Failed to load mdGetAppModules. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void addToBag(ProductA? product, String selectedCurrency) {
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
