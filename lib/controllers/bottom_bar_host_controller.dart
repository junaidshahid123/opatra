import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/MDAllBanners.dart';
import '../models/MDAllVideoCategories.dart';
import '../models/MDAllVideos.dart';
import '../models/MDCategories.dart';
import '../models/MDLatestProducts.dart';
import '../models/MDProducts.dart';
import '../models/MDProductsByCategory.dart';
import '../models/MDVideosByCategory.dart';

class BottomBarHostController extends GetxController {
  var userName = ''.obs; // RxString to hold the userName
  var userEmail = ''.obs; // RxString to hold the userEmail
  MDCategories? mdCategories;
  List<SmartCollections> skinCareCategories = [];
  List<SmartCollections> devicesCategories = [];
  MDAllBanners? mdAllBanners;
  MDAllVideoCategories? mdAllVideoCategories;
  MDVideosByCategory? mdVideosByCategory;
  List<Video>? mdAllVideos;
  List<MDVideosByCategory>? mdAllVideosByCategory;
  MDLatestProducts? mdLatestProducts;
  MDProducts? mdProducts;
  MDProductsByCategory? mdProductsByCategory;
  RxBool isLoading = false.obs;
  RxBool isCurrencyDropDown = false.obs;
  RxBool usd = false.obs;
  RxBool pound = false.obs;
  RxBool euro = false.obs;
  RxBool noResultsFound = false.obs; // State for no results found
  RxList<ProductsA> filteredProducts =
      <ProductsA>[].obs; // List of filtered products
  RxString searchQuery = ''.obs; // Observable search query
  RxString selectedCurrency = ''.obs; // Observable search query

  @override
  void onInit() {
    super.onInit();
    _loadUserName(); // Load userName when the controller is initialized
    _loadUserEmail();
    fetchLatestProducts();
    fetchAllProducts();
    fetchProductCategories();
    selectedCurrency.value = 'Pound';
    fetchAllBanners();
    fetchVideoCategories();
  }

  void makeUsDollar() {
    usd.value = true;
    euro.value = false;
    pound.value = false;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'US Dollar';
    update();
  }

  void makeEuro() {
    usd.value = false;
    euro.value = true;
    pound.value = false;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'Euro';
    update();
  }

  void makePound() {
    usd.value = false;
    euro.value = false;
    pound.value = true;
    isCurrencyDropDown.value = false;
    selectedCurrency.value = 'Pound';
    update();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    filterProducts(query);
  }

  void filterProducts(String query) async {
    isLoading.value = true; // Start loading
    await Future.delayed(Duration(milliseconds: 500)); // Simulate delay

    // If controller.mdProductsByCategory is a single object
    var allProducts = mdProductsByCategory?.products ?? [];

    if (query.isEmpty) {
      filteredProducts.value = allProducts;
      noResultsFound.value = false;
    } else {
      var results = allProducts
          .where((product) =>
              product.title != null &&
              product.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      filteredProducts.value = results;
      noResultsFound.value = results.isEmpty;
    }

    isLoading.value = false; // Stop loading
  }

  Future<void> fetchVideoByCategory(int id) async {
    searchQuery.value = '';
    isLoading.value = true;
    final url =
        Uri.parse('https://opatra.fai-tech.online/api/video-category/${id}');

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
        isLoading.value = false;
        final data = jsonDecode(response.body);
        print('mdVideosByCategory: $data');
        mdVideosByCategory = MDVideosByCategory.fromJson(data);
        print('mdVideosByCategory: $mdVideosByCategory');
        update();
        // filterProducts(searchQuery.value); // Filter with current query
      } else {
        isLoading.value = false;
        print(
            'Failed to load mdVideosByCategory. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }

  Future<void> fetchProductByCategory(int id) async {
    mdProductsByCategory=null;
    searchQuery.value = '';
    isLoading.value = true;
    final url =
        Uri.parse('https://opatra.fai-tech.online/api/category/${id}/products');

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
        print('mdProductsByCategory: $data');
        mdProductsByCategory = MDProductsByCategory.fromJson(data);
        print('mdProductsByCategory: $mdProductsByCategory');
        update();
      } else {
        isLoading.value = false;
        print(
            'Failed to load products by categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading.value = false;
      print('Error: $e');
    }
  }

  Future<void> fetchAllBanners() async {
    final url = Uri.parse('https://opatra.fai-tech.online/api/banner');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
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
        print('Banners: $data');
        mdAllBanners = MDAllBanners.fromJson(data);
        print(
            'mdAllVideos=========${mdAllBanners}'); // Set the fetched video list
      } else {
        print(
            'Failed to load mdAllBanners. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> fetchAllVideos() async {
    final url = Uri.parse('https://opatra.fai-tech.online/api/video');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
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
        print('Videos: $data');
        final allVideos = MDAllVideos.fromJson(data); // Parse JSON data
        mdAllVideos = allVideos.data;
        update();
        print(
            'mdAllVideos=========${mdAllVideos}'); // Set the fetched video list
      } else {
        print(
            'Failed to load mdAllVideos. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchProductCategories() async {
    final url =
        Uri.parse('https://opatra.fai-tech.online/api/product-category');

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
        print('Product Categories: $data');
        mdCategories = MDCategories.fromJson(data);
        print('mdCategories: $mdCategories');
        for (int i = 0; i < mdCategories!.smartCollections!.length; i++) {
          if (mdCategories!.smartCollections![i].title == 'ACCESSORIES') {
            devicesCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'ANTI-AGEING') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'ANTI-BLEMISH') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'ANTI-WRINKLE') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'BODY CARE') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'CLEANSING') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'DEVICES') {
            devicesCategories.add(mdCategories!.smartCollections![i]);
          }
          if (mdCategories!.smartCollections![i].title == 'DRY SKIN') {
            skinCareCategories.add(mdCategories!.smartCollections![i]);
          }
          print('title============${mdCategories!.smartCollections![i].title}');
        }

          fetchProductByCategory(skinCareCategories[0].id!);
          update();

        update();
      } else {
        print(
            'Failed to load product categories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchVideoCategories() async {
    final url = Uri.parse('https://opatra.fai-tech.online/api/video-category');

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
        print('Video Categories: $data');
        mdAllVideoCategories = MDAllVideoCategories.fromJson(data);
        print('mdAllVideoCategories: $mdAllVideoCategories');
        if (mdAllVideoCategories != null) {
          fetchVideoByCategory(mdAllVideoCategories!.data![0].id!);
          update();
        }
      } else {
        print(
            'Failed to load mdAllVideoCategories. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchAllProducts() async {
    final url = Uri.parse('https://opatra.fai-tech.online/api/products');

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
        print('mdProducts: $data');
        mdProducts = MDProducts.fromJson(data);
        print('mdProducts: $mdProducts');
        update();
        for(int i=0;i<mdProducts!.products!.length;i++){
          print('title============${mdProducts!.products![i].title}');

        }
      } else {
        print('Failed to load products. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchLatestProducts() async {
    final url = Uri.parse('https://opatra.fai-tech.online/api/latest-products');

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
        print('Product mdLatestProducts: $data');
        mdLatestProducts = MDLatestProducts.fromJson(data);
        print('mdLatestProducts: $mdLatestProducts');
        update();
      } else {
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
