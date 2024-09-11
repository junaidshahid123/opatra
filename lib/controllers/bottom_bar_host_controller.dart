import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MDCategories.dart';
import '../models/MDLatestProducts.dart';
import '../models/MDProducts.dart';
import '../models/MDProductsByCategory.dart';

class BottomBarHostController extends GetxController {
  var userName = ''.obs; // RxString to hold the userName
  var userEmail = ''.obs; // RxString to hold the userEmail
  MDCategories? mdCategories;
  MDLatestProducts? mdLatestProducts;
  MDProducts? mdProducts;
  MDProductsByCategory? mdProductsByCategory;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName(); // Load userName when the controller is initialized
    _loadUserEmail();
    fetchLatestProducts();
    fetchAllProducts();
    fetchProductCategories();
    update();
  }

  Future<void> fetchProductByCategory(int id) async {
    isLoading.value = true;
    final url = Uri.parse(
        'https://opatra.meetchallenge.com/api/category/${id}/products');
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
        isLoading.value = false;

        // Successfully received data
        final data = jsonDecode(response.body);
        print('mdProductsByCategory: $data');
        mdProductsByCategory = MDProductsByCategory.fromJson(data);
        print('mdProductsByCategory: $mdProductsByCategory');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        isLoading.value = false;

        print(
            'Failed to load products by categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;

      print('Error: $e');
    }
  }

  Future<void> fetchProductCategories() async {
    final url =
        Uri.parse('https://opatra.meetchallenge.com/api/product-category');

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
        print('Product Categories: $data');
        mdCategories = MDCategories.fromJson(data);
        print('mdCategories: $mdCategories');
        fetchProductByCategory(mdCategories!.smartCollections![0].id!);
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print(
            'Failed to load product categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchAllProducts() async {
    final url = Uri.parse('https://opatra.meetchallenge.com/api/products');

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
        print('mdProducts: $data');
        mdProducts = MDProducts.fromJson(data);
        print('mdProducts: $mdProducts');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print('Failed to load products. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchLatestProducts() async {
    final url =
        Uri.parse('https://opatra.meetchallenge.com/api/latest-products');

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
        print('Product mdLatestProducts: $data');
        mdLatestProducts = MDLatestProducts.fromJson(data);
        print('mdLatestProducts: $mdLatestProducts');
        update();

        // You can further process the data here
      } else {
        // Handle errors
        print(
            'Failed to load latest products. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value =
        prefs.getString('userName') ?? 'Guest'; // Set default to 'Guest'
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    userEmail.value =
        prefs.getString('userEmail') ?? ''; // Set default to 'Guest'
  }
}
