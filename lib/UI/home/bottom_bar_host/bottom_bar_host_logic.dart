import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant/AppColors.dart';
import '../../../constant/AppLinks.dart';
import '../../../models/MDAllBanners.dart';
import '../../../models/MDAllVideoCategories.dart';
import '../../../models/MDAllVideos.dart';
import '../../../models/MDCategories.dart';
import '../../../models/MDLatestProducts.dart';
import '../../../models/MDProducts.dart';
import '../../../models/MDProductsByCategory.dart';
import '../../../models/MDVideosByCategory.dart';
import '../../auth/login/login_view.dart';

class BottomBarHostController extends GetxController {
  RxBool noProductsMatched = false.obs;
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
  int currentIndex = 0;
  RxBool home = true.obs;
  RxBool product = true.obs;
  RxBool video = true.obs;
  RxBool skinCare = true.obs;
  RxBool devices = true.obs;
  RxInt selectedCategoryForSkinCare = 0.obs;
  RxInt selectedCategoryForDevice = 0.obs;
  RxInt selectedCategoryForVideo = 0.obs;
  RxInt selectedIndex = 0.obs;
  TextEditingController searchTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    home.value = true;
    product.value = false;
    video.value = false;
    selectedIndex.value = -1;
    skinCare.value = true;
    devices.value = false;
    _getUserName();
    _loadUserName(); // Load userName when the controller is initialized
    _loadUserEmail();
    fetchLatestProducts();
    fetchAllProducts();
    fetchProductCategories();
    selectedCurrency.value = 'Pound';
    fetchAllBanners();
    fetchVideoCategories();
    filteredProducts.value = mdProductsByCategory?.products ?? [];
  }

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ??
        'Guest'; // Default to 'Guest' if no value is found
  }

  void showDialogForCurrency(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFB7A06A),
          child: Material(
            type: MaterialType.transparency,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    color: Color(0xFFB7A06A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Text(
                          'Select Currency',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appWhiteColor),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                makeUsDollar();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: usd.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: usd.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'US Dollar',
                                    style: TextStyle(
                                      color: usd.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makeEuro();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: euro.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: euro.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Euro',
                                    style: TextStyle(
                                      color: euro.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                makePound();
                                Get.back();
                              },
                              child: Container(
                                height: 40, // Oval shape height
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: pound.value == true
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                          color: AppColors.appWhiteColor),
                                  borderRadius: BorderRadius.circular(20),
                                  // Slightly more circular
                                  color: pound.value == true
                                      ? AppColors.appWhiteColor
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    'Pound',
                                    style: TextStyle(
                                      color: pound.value == true
                                          ? Color(0xFFB7A06A)
                                          : AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Obx(() => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.only(left: 20, right: 20),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height /
                      2.5, // Adjusted height for new content
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Are you sure you want to Log Out?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.appPrimaryBlackColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // No button
                            InkWell(
                              onTap: () {
                                Get.back(); // Close the dialog
                                selectedIndex.value = -1;
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  // Grey color for "No" button
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appWhiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Yes button
                            InkWell(
                              onTap: () {
                                // Add your logout functionality here
                                logOut();
                              },
                              child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB7A06A),
                                    // Custom color for "Yes" button
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: isLoading.value == true
                                          ? SizedBox(
                                              width: 20.0, // Adjust the width
                                              height: 20.0, // Adjust the height
                                              child: CircularProgressIndicator(
                                                strokeWidth: 5,
                                                color: AppColors.appWhiteColor,
                                              ),
                                            )
                                          : Text(
                                              'Yes',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
      },
    );
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
    filteredProducts.value = [];
    print("Filtering products with query: '$query'");
    isLoading.value = true; // Start loading
    await Future.delayed(Duration(milliseconds: 500)); // Simulate delay

    // Retrieve all products
    var allProducts = mdProductsByCategory?.products ?? [];
    print("Total products available: ${allProducts.length}");

    if (query.isEmpty) {
      print("Query is empty, displaying all products.");
      filteredProducts.value = allProducts;
      noResultsFound.value = false;
    } else {
      // Filter products to only those where the title starts with the query
      var results = allProducts.where((product) {
        var title = product.title?.toLowerCase();
        bool matches = title != null && title.startsWith(query.toLowerCase());
        print(
            "Checking product '${product.title}': ${matches ? 'Match' : 'No Match'}");
        return matches;
      }).toList();

      filteredProducts.value = results;
      noResultsFound.value = results.isEmpty;

      // Print the names of the filtered products
      if (results.isNotEmpty) {
        print("Filtered products:");
        for (var product in results) {
          print("- ${product.title}");
        }
      } else {
        noProductsMatched.value = true;
        print("No products matched the query.");
      }
    }

    isLoading.value = false; // Stop loading
    print("Loading complete. No results found: ${noResultsFound.value}");
  }

  Future<void> logOut() async {
    isLoading.value = true;
    final url = Uri.parse(ApiUrls.logoutUrl);
    // Retrieve token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs

    //  Ensure the token exists before proceeding
    if (token == null || token.isEmpty) {
      isLoading.value = false;
      Get.snackbar('Error', 'No token found. Please log in again.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer $token", // Include the Bearer token in headers
    };

    try {
      final client = http.Client();
      final http.Response response = await client.post(
        url,
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false; // Stop loading spinner

        final Map<String, dynamic> responseData = json.decode(response.body);
        print('responseData========${responseData}');
        prefs.remove('token');
        Get.snackbar('Success', 'Log Out Successfully');
        Get.offAll(LoginView());
      } else {
        isLoading.value = false; // Stop loading spinner

        // Handle errors
        final Map<String, dynamic> responseData = json.decode(response.body);
        String errorMessage =
            responseData['message'] ?? 'Failed to log out user';

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((key, value) {
            errorMessage += '\n${value.join(', ')}';
          });
        }

        Get.snackbar('Error', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false; // Stop loading spinner
      Get.snackbar('Error', 'An error occurred: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchVideoByCategory(int id) async {
    searchQuery.value = '';
    isLoading.value = true;
    final url = Uri.parse('${ApiUrls.baseUrl}/video-category/${id}');

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
    mdProductsByCategory = null;
    searchQuery.value = '';
    isLoading.value = true;
    final url = Uri.parse('${ApiUrls.baseUrl}/category/${id}/products');

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
    final url = Uri.parse(ApiUrls.banner);

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
    final url = Uri.parse(ApiUrls.productCategory);

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
    final url = Uri.parse(ApiUrls.videoCategory);

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
        final data = jsonDecode(response.body);
        print('mdProducts: $data');
        mdProducts = MDProducts.fromJson(data);
        print('mdProducts: $mdProducts');
        update();
        for (int i = 0; i < mdProducts!.products!.length; i++) {
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
    final url = Uri.parse(ApiUrls.getLatestProducts);

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
