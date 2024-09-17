import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:opatra/models/MDProductCategoryDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/MDProductDetailImages.dart';

class ProductDetailController extends GetxController {
  MDProductCategoryDetail? mdProductCategoryDetail;
  MDProductDetailImages? mdProductDetailImages;

  @override
  void onInit() {
    super.onInit();
    update();
  }

  Future<void> fetchImages(int id) async {
    print('id======${id}');
    final url = Uri.parse(
        'https://opatra.fai-tech.online/api/product/${id}/images');

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
        print('Product Category Detail Images: $data');
        mdProductDetailImages = MDProductDetailImages.fromJson(data);
        print('mdProductDetailImages: $mdProductDetailImages');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print(
            'Failed to load product mdProductDetailImages . Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchProductDetail(int id) async {
    final url = Uri.parse(
        'https://opatra.fai-tech.online/api/product-category/${id}');

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
        print('Product Category Detail: $data');
        mdProductCategoryDetail = MDProductCategoryDetail.fromJson(data);
        print('mdProductCategoryDetail: $mdProductCategoryDetail');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print(
            'Failed to load product categories details. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
