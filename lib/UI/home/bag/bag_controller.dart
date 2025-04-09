import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constant/AppLinks.dart';
import '../../../models/MDLatestProducts.dart';
import '../../../models/MDProductDetail.dart';
import 'MDDiscount.dart';

class BagController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool doneWithDiscount = false.obs;
  MDProductDetail? mdProductDetail;

  RxInt quantity = 1.obs;
  RxList<ProductA> cartItems = <ProductA>[].obs;
  RxDouble subTotal = 0.0.obs; // Observable double for subTotal
  RxDouble total = 0.0.obs;

  var bagItems = <ProductA, int>{}.obs; // Product as key, quantity as value
  var quantities = <int>[].obs; // Corresponding quantities for each product

  // New map to store total prices for each product
  RxMap<ProductsC, double> totalPrices = <ProductsC, double>{}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    init(); // Load the cart when the screen is initialized
  }

  Future<void> initStripePaymentSheet(
      BagController logic, String currency) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Calculate the total amount in cents (Stripe requires smallest currency unit)
      final amount = (logic.total.value * 100).toInt();

      // Convert and validate currency
      final stripeCurrency = _parseCurrency(currency);

      // 1. Create payment intent (client-side only - for testing)
      final paymentIntent = await _createPaymentIntent(amount, stripeCurrency);

      // 2. Initialize Stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Your App Name',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFFB7A06A),
            ),
          ),
        ),
      );

      // 3. Present the payment sheet with enhanced error handling
      try {
        await Stripe.instance.presentPaymentSheet();

        // Close loading dialog
        Get.back();

        // Payment successful
        Get.snackbar(
          'Success',
          'Payment completed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear cart or perform other success actions
        cartItems.clear();
      } on StripeException catch (e) {
        Get.back();
        _handleLocalizedErrorMessage(e.error);
      } on PlatformException catch (e) {
        Get.back();
        _handlePlatformPaymentError(e);
      } catch (e) {
        Get.back();
        _handleGenericPaymentError(e);
      }
    } catch (e) {
      Get.back();
      _handleGenericPaymentError(e);
    }
  }

  // New handler for LocalizedErrorMessage
  void _handleLocalizedErrorMessage(LocalizedErrorMessage error) {
    debugPrint('Stripe Localized Error: ${error.localizedMessage}');

    Get.snackbar(
      'Payment Failed',
      error.localizedMessage ?? 'Payment failed',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

// Add these new helper methods to handle different error types
  void _handleStripePaymentError(StripeError error) {
    String userMessage;
    String debugMessage = error.message ?? 'No error details';

    switch (error.code) {
      case 'failed':
        userMessage = 'Payment failed. Please try another payment method.';
        break;
      case 'canceled':
        userMessage = 'Payment was canceled.';
        break;
      case 'invalid_client_secret':
        userMessage = 'Payment configuration error. Please contact support.';
        debugMessage = 'Invalid client secret: $debugMessage';
        break;
      case 'timeout':
        userMessage = 'Payment timed out. Please try again.';
        break;
      case 'api_connection_error':
        userMessage = 'Network error. Please check your connection.';
        break;
      case 'api_error':
        userMessage = 'Payment service error. Please try again later.';
        break;
      case 'authentication_error':
        userMessage = 'Authentication error. Please contact support.';
        debugMessage = 'Auth error: $debugMessage';
        break;
      case 'rate_limit_error':
        userMessage = 'Too many requests. Please wait and try again.';
        break;
      default:
        userMessage = 'Payment failed. Please try again.';
    }

    // Log the detailed error for debugging
    debugPrint('Stripe Payment Error: $debugMessage');

    Get.snackbar(
      'Payment Failed',
      userMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handlePlatformPaymentError(PlatformException e) {
    debugPrint('Platform Error during payment: ${e.message}');

    Get.snackbar(
      'Payment Error',
      'A system error occurred. Please try again or contact support.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handleGenericPaymentError(dynamic e) {
    debugPrint('Generic Payment Error: ${e.toString()}');

    Get.snackbar(
      'Error',
      'An unexpected error occurred during payment: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  String _parseCurrency(String inputCurrency) {
    // Convert to lowercase
    final lowerCurrency = inputCurrency.toLowerCase();

    // Map common currency names to their ISO codes
    const currencyMap = {
      'pound': 'gbp',
      'euro': 'eur',
      'dollar': 'usd',
      'us dollars': 'usd',
      'euros': 'eur',
      'pounds': 'gbp',
      // Add more mappings as needed
    };

    // Return mapped value or original if already valid
    return currencyMap[lowerCurrency] ?? lowerCurrency;
  }

// WARNING: FOR TESTING ONLY - UNSAFE FOR PRODUCTION
  Future<Map<String, dynamic>> _createPaymentIntent(
      int amount, String currency) async
  {
    try {
      // First validate the currency is supported
      _validateCurrency(currency);

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
          'Bearer sk_test_51JrLuBSE6S1t50lC7SUzctTxvWLEjdQzzhqTSFPF2jrq5PtDIjJYavIMWOZHEnt8BeDAevWcoalM6rtkf31ILYEG00KMOfXPX7',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount.toString(),
          'currency': currency,
          'automatic_payment_methods[enabled]': 'true',
        },
      ).timeout(const Duration(seconds: 30)); // Add timeout for the request

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Payment intent created successfully
        return responseBody;
      } else {
        // Handle different Stripe API error codes
        final errorCode = responseBody['error']['code'] ?? 'unknown_error';
        final errorMessage = responseBody['error']['message'] ?? 'Unknown error occurred';

        switch (errorCode) {
          case 'amount_too_small':
            throw Exception('Payment failed: The amount is too small for this currency');
          case 'amount_too_large':
            throw Exception('Payment failed: The amount is too large');
          case 'invalid_currency':
            throw Exception('Payment failed: Invalid currency');
          case 'card_declined':
            throw Exception('Payment failed: Card was declined');
          case 'expired_card':
            throw Exception('Payment failed: Card has expired');
          case 'insufficient_funds':
            throw Exception('Payment failed: Insufficient funds');
          case 'processing_error':
            throw Exception('Payment failed: Processing error occurred');
          default:
            throw Exception('Payment failed: $errorMessage');
        }
      }
    } on SocketException {
      throw Exception('Payment failed: No internet connection');
    } on TimeoutException {
      throw Exception('Payment failed: Request timed out');
    } on http.ClientException catch (e) {
      throw Exception('Payment failed: Network error - ${e.message}');
    } on FormatException {
      throw Exception('Payment failed: Invalid response from server');
    } on StripeException catch (e) {
      // If you're using the Stripe SDK, you might get specific Stripe exceptions
      throw Exception('Payment failed: ${e.error.message}');
    } catch (e) {
      throw Exception('Payment failed: An unexpected error occurred - $e');
    }
  }
  void _validateCurrency(String currency) {
    const supportedCurrencies = [
      'usd', 'eur', 'gbp', 'cad', 'aud', 'jpy' // Add all needed currencies
    ];

    if (!supportedCurrencies.contains(currency)) {
      throw Exception(
          'Unsupported currency: $currency. Supported currencies: ${supportedCurrencies.join(', ')}');
    }
  }

  Future<List> getCartItemsFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? cartJsonList = prefs.getStringList('cartItems');

      if (cartJsonList != null) {
        // Decode JSON strings to list of maps
        return cartJsonList.map((item) => jsonDecode(item)).toList();
      }
    } catch (e) {
      print('Error retrieving cart items: $e');
    }
    return []; // Return an empty list if no items are found or an error occurs
  }

  Future<void> applyDiscount(String discountCode) async {
    String apiUrl = 'https://opatra.app/api/apply-discount'; // The API endpoint

    // Define the body data to be sent in the POST request
    Map<String, dynamic> body = {
      "discount_code": discountCode,
    };

    // Encode the body as JSON
    String jsonBody = json.encode(body);

    // Fetch the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Get the token from shared prefs

    // Set the headers
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token", // Add Bearer token to the headers
    };

    try {
      // Show loading dialog
      Get.dialog(
        Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false, // Prevent dismissing the loading dialog
      );

      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonBody,
      );

      // Dismiss the loading dialog
      if (Get.isDialogOpen!) {
        Get.back();
      }

      // Parse the response
      var responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Successful response
        MDDiscount discountResponse = MDDiscount.fromJson(responseBody);

        if (discountResponse.success == true &&
            discountResponse.discount != null) {
          double discountValue = double.parse(discountResponse.discount!);

          // Update subTotal
          subTotal.value = subTotal.value - discountValue;

          print("Discount Applied: $discountValue");
          print("New SubTotal: ${subTotal.value}");

          Get.snackbar(
            'Success',
            'Discount applied successfully! New subtotal: \£${subTotal.value.toStringAsFixed(2)}',
            backgroundColor: Colors.green,
          );
          doneWithDiscount.value = true;
          update();
        } else {
          Get.snackbar(
            'Error',
            discountResponse.message ?? 'Unable to apply discount.',
            backgroundColor: Colors.red,
          );
        }
      } else {
        // Unsuccessful response, handle different cases
        if (responseBody['message'] != null) {
          print("Error: ${responseBody['message']}");
          Get.snackbar(
            'Error',
            responseBody['message'],
            backgroundColor: Colors.red,
          );
        }

        // Handle specific errors in the "errors" field
        if (responseBody['errors'] != null &&
            responseBody['errors']['discount_code'] != null) {
          String errorMessage =
              responseBody['errors']['discount_code'].join(", ");
          print("Detailed Error: $errorMessage");
          Get.snackbar(
            'Invalid Discount Code',
            errorMessage,
            backgroundColor: Colors.orange,
          );
        }
      }
    } catch (e) {
      // Dismiss the loading dialog in case of an exception
      if (Get.isDialogOpen!) {
        Get.back();
      }

      // Handle network or other errors
      print("Exception: $e");
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again later.',
        backgroundColor: Colors.red,
      );
    }
  }

  void calculateSubtotal() {
    print('calculateSubtotal function called'); // Check if function is called

    // Initialize subtotal to zero before calculation
    double totalA = 0.0;
    print('Starting subtotal calculation...'); // Start message

    // Loop through each cart item to calculate total price
    for (var i = 0; i < cartItems.length; i++) {
      var item = cartItems[i];
      print(
          'Item $i - Price: ${item.price?.value}, Quantity: ${item.quantity?.value}'); // Log item details

      if (item.price != null && item.quantity != null) {
        // Multiply price by quantity and add to the running total
        double itemTotal = item.price!.value * item.quantity!.value;
        print('Item $i - Total for item: $itemTotal'); // Log item total
        totalA += itemTotal;
      } else {
        print(
            'Item $i has a null price or quantity, skipping...'); // Handle null cases
      }
    }

    // Store the calculated subtotal
    subTotal.value = totalA;
    total.value = totalA;
    print('Calculated subtotal: $total'); // Final subtotal
  }

// Method to add a product to the cart and save to local storage
  void addProductToBag(
      ProductA product, int quantity, String selectedCurrency) async {
    print('addProductToBag called with:');
    print('Product ID: ${product.id}');
    print('Product Title: ${product.title}');
    print('Quantity to Add: $quantity');
    print('Selected Currency: $selectedCurrency');

    // Check if the product already exists in the cartItems list
    int existingIndex = cartItems.indexWhere((item) => item.id == product.id);

    if (existingIndex != -1) {
      // If the product already exists, update the quantity
      print('Product already in cart. Updating quantity.');
      cartItems[existingIndex].quantity!.value =
          (cartItems[existingIndex].quantity!.value ?? 0) + quantity;
      print(
          'Updated Quantity for ${cartItems[existingIndex].title}: ${cartItems[existingIndex].quantity}');
    } else {
      // Otherwise, add the new product to the cart
      print('Adding new product to cart.');
      product.quantity!.value = quantity; // Set the initial quantity
      cartItems.add(product);
      print('Product ${product.title} added with Quantity: $quantity');
    }

    // Save cart items to local storage
    await _saveCartToLocalStorage();

    // Optionally, if you want to log the entire cart after adding
    print('Current Cart Items:');
    cartItems.forEach((item) {
      print(
          'Product ID: ${item.id}, Title: ${item.title}, Quantity: ${item.quantity}');
    });
  }

// Method to save cart items to local storage
  Future<void> _saveCartToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert cartItems to a list of JSON objects
    List<String> cartJsonList = cartItems.map((item) {
      return jsonEncode(item.toJson()); // Convert product to JSON string
    }).toList();

    // Save the list of cart items in SharedPreferences
    await prefs.setStringList('cartItems', cartJsonList);
  }

  init() async {
    isLoading.value = true; // Show loader
    await loadCartFromLocalStorage();
    isLoading.value = false; // Hide loader
    if (cartItems.isEmpty) {
      subTotal.value = 0;
      total.value = 0;
    }
    update(); // Notify UI
  }

  // Method to load cart and return cart items
  Future<void> loadCart() async {
    isLoading.value = true;
    try {
      cartItems.value = await loadCartFromLocalStorage(); // Fetch cart items
    } finally {
      isLoading.value = false;
    }
    update(); // Notify the UI
  }

  Future<List<ProductA>> loadCartFromLocalStorage() async {
    print('Step 1: Initiating cart loading process...');
    isLoading.value = true; // Step 2: Display loader while processing

    // List<ProductA> fetchedCartItems = []; // To store cart items

    try {
      // Step 3: Fetch SharedPreferences instance
      print('Step 3: Accessing SharedPreferences...');
      final prefs = await SharedPreferences.getInstance();

      // Step 4: Retrieve cart items stored as JSON strings
      print('Step 4: Retrieving cart items from local storage...');
      List<String>? cartJsonList = prefs.getStringList('cartItems');

      // Step 5: Retrieve the selected currency for price calculation
      print('Step 5: Fetching selected currency from local storage...');
      String selectedCurrency = prefs.getString('selectedCurrency') ?? 'Pound';
      print('Selected currency: $selectedCurrency');

      // Step 6: Check if there are any cart items stored
      if (cartJsonList != null && cartJsonList.isNotEmpty) {
        print('Step 6: Converting cart JSON strings to ProductA objects...');
        cartItems.value = cartJsonList.map((jsonString) {
          print('Parsing JSON string: $jsonString');
          return ProductA.fromJson(jsonDecode(jsonString));
        }).toList();

        // Step 7: Initialize variables for calculations
        double calculatedSubTotal = 0.0;
        double calculatedTotal = 0.0;

        print('Step 7: Iterating through cart items for price calculations...');
        for (var item in cartItems) {
          print('Processing cart item with Product ID: ${item.id}');

          // Step 8: Fetch product details for the current cart item
          print('Fetching product details...');
          await fetchProductDetail(item.id!);

          // Step 9: Determine price based on the selected currency
          int? priceIndex;
          if (selectedCurrency == 'Pound') {
            priceIndex = 0;
          } else if (selectedCurrency == 'Euro') {
            priceIndex = 4;
          } else if (selectedCurrency == 'US Dollar') {
            priceIndex = 6;
          }

          if (priceIndex != null &&
              priceIndex >= 0 &&
              priceIndex < mdProductDetail!.product!.variants!.length) {
            item.price!.value = double.parse(
                mdProductDetail!.product!.variants![priceIndex].price!);

            print(
                'Assigned price for ${selectedCurrency}: ${item.price!.value}');
            update();
          } else if (mdProductDetail!.product!.variants![0].title ==
              'Default Title') {
            item.price!.value =
                double.parse(mdProductDetail!.product!.variants![0].price!);

            print('Default price assigned: ${item.price!.value}');
          } else {
            print('Error: Invalid index or no variant for selected currency.');
            continue; // Skip this item if invalid
          }

          // Step 10: Calculate total for this item
          if (item.price != null && item.quantity != null) {
            double itemTotal = item.price!.value * item.quantity!.value;
            calculatedSubTotal += itemTotal;
            calculatedTotal += itemTotal;

            print(
                'Item total: $itemTotal. Updated SubTotal: $calculatedSubTotal, Total: $calculatedTotal');
          }
        }

        // Step 11: Update observable values for UI
        subTotal.value = calculatedSubTotal;
        total.value = calculatedTotal;

        print('Step 12: Saving updated cart data to local storage...');
        await saveCartToLocalStorage(cartItems);

        print('Final SubTotal in $selectedCurrency: ${subTotal.value}');
        print('Final Total in $selectedCurrency: ${total.value}');
        update();
      } else {
        print('No cart items found in local storage.');
      }
    } catch (e) {
      // Step 13: Handle any errors encountered
      print('Error while loading cart: $e');
    } finally {
      // Step 14: Hide loader and finish process
      print('Hiding loader and completing cart loading process...');
      isLoading.value = false;
      update();
    }

    return cartItems; // Return the cart items
  }

  Future<void> fetchProductDetail(int id) async {
    final url = Uri.parse('${ApiUrls.baseUrl}/product/${id}');
    print(id);
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
        print('mdProductDetail Variants:');
        mdProductDetail!.product!.variants!.forEach((variant) {
          print('Variant: ${variant.title}');
        });
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

  Future<void> saveCartToLocalStorage(List<ProductA> updatedCart) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = updatedCart.map((item) {
      return jsonEncode(item.toJson());
    }).toList();
    await prefs.setStringList('cartItems', cartJsonList);
  }

// // Method to add a product to the cart
//   void addProductToBag(ProductA product, int quantity,
//       String selectedCurrency) {
//     print('addProductToBag called with:');
//     print('Product ID: ${product.id}');
//     print('Product Title: ${product.title}');
//     print('Quantity to Add: $quantity');
//     print('Selected Currency: $selectedCurrency');
//
//     // Check if the product already exists in the cartItems list
//     int existingIndex = cartItems.indexWhere((item) => item.id == product.id);
//
//     if (existingIndex != -1) {
//       // If the product already exists, update the quantity
//       print('Product already in cart. Updating quantity.');
//       cartItems[existingIndex].quantity!.value =
//           (cartItems[existingIndex].quantity!.value ?? 0) + quantity;
//       print(
//           'Updated Quantity for ${cartItems[existingIndex]
//               .title}: ${cartItems[existingIndex].quantity}');
//     } else {
//       // Otherwise, add the new product to the cart
//       print('Adding new product to cart.');
//       product.quantity!.value = quantity; // Set the initial quantity
//       cartItems.add(product);
//       print('Product ${product.title} added with Quantity: $quantity');
//     }
//
//     // Optionally, if you want to log the entire cart after adding
//     print('Current Cart Items:');
//     cartItems.forEach((item) {
//       print(
//           'Product ID: ${item.id}, Title: ${item.title}, Quantity: ${item
//               .quantity}');
//     });
//   }

  void updateCartInLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // Convert cartItems to a list of JSON strings
    List<String> cartJsonList = cartItems.map((product) {
      return jsonEncode(product.toJson()); // Convert ProductA to JSON string
    }).toList();

    // Store the updated cart items in SharedPreferences
    await prefs.setStringList('cartItems', cartJsonList);
    print('Cart data updated in local storage');
  }

  void tapOnDelete(int index) {
    // Ensure the cart item at the given index exists and is valid
    if (index >= 0 && index < cartItems.length) {
      // Get the item to be removed
      var itemToRemove = cartItems[index];

      // Remove the item from the cart
      cartItems.removeAt(index);

      // Update the subtotal by subtracting the base price of the removed item
      subTotal.value -= itemToRemove.basePrice!;
      total.value -= itemToRemove.basePrice!;

      // Update the cart data in local storage
      updateCartInLocalStorage();

      // Update the UI
      update();
    } else {
      print('Invalid index: $index');
    }
  }

  void tapOnDecrement(int index) {
    // Ensure the cart item at the given index exists and is valid
    if (index >= 0 && index < cartItems.length) {
      // Check if the quantity is greater than 1 to allow decrement
      if (cartItems[index].quantity!.value > 1) {
        // Decrement the quantity safely
        cartItems[index].quantity!.value -= 1;

        // Ensure the product price reflects only the base price
        if (cartItems[index].basePrice != null) {
          double basePrice =
              cartItems[index].basePrice!.toDouble(); // Use the base price
          cartItems[index].price!.value = basePrice; // Keep price as base price
        }

        // Update subtotal by subtracting the base price
        if (cartItems[index].basePrice != null) {
          subTotal.value -=
              cartItems[index].basePrice!; // Subtract base price from subtotal
        }

        // Update the total (can be similar to subtotal in your case)
        total.value =
            subTotal.value; // Assuming total is the same as subTotal for now

        // Update the cart data in local storage
        updateCartInLocalStorage();

        // Update the UI
        update();
      } else {
        print('Quantity cannot be less than 1');
      }
    } else {
      print('Invalid index: $index');
    }
  }

  void tapOnIncrement(int index) {
    // Ensure the quantity is initialized
    if (cartItems[index].quantity == null) {
      cartItems[index].quantity =
          RxInt(1); // Initialize to 1 to avoid zero or invalid quantity
    }

    // Increment the quantity safely
    cartItems[index].quantity!.value += 1;

    // Update the product price using the base price (not the total price)
    if (cartItems[index].basePrice != null) {
      double basePrice = cartItems[index].basePrice!; // Use the base price
      cartItems[index].price!.value =
          basePrice; // Set the price to the base price only
    }

    // Update subtotal by adding the base price for this item
    if (cartItems[index].basePrice != null) {
      subTotal.value +=
          cartItems[index].basePrice!; // Add base price to subtotal
    }

    // Update the total (can be similar to subtotal in your case)
    total.value =
        subTotal.value; // Assuming total is the same as subTotal f or now

    // Update the cart data in local storage
    updateCartInLocalStorage();

    // Update the UI
    update();
  }
}
