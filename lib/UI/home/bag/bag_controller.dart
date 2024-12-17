import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/MDLatestProducts.dart';
import '../../../models/MDProductDetail.dart';
import 'MDDiscount.dart';

class BagController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool doneWithDiscount = false.obs;

  RxInt quantity = 1.obs;
  List<ProductA> cartItems = [];
  RxDouble subTotal = 0.0.obs; // Observable double for subTotal
  double total = 0.0;

  var bagItems = <ProductA, int>{}.obs; // Product as key, quantity as value
  var quantities = <int>[].obs; // Corresponding quantities for each product

  // New map to store total prices for each product
  RxMap<ProductsC, double> totalPrices = <ProductsC, double>{}.obs;

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

        if (discountResponse.success == true && discountResponse.discount != null) {
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
          doneWithDiscount.value=true;
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
    double total = 0.0;
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
        total += itemTotal;
      } else {
        print(
            'Item $i has a null price or quantity, skipping...'); // Handle null cases
      }
    }

    // Store the calculated subtotal
    subTotal.value = total;
    print('Calculated subtotal: $total'); // Final subtotal
  }

// Method to add a product to the cart
  void addProductToBag(
      ProductA product, int quantity, String selectedCurrency) {
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

    // Optionally, if you want to log the entire cart after adding
    print('Current Cart Items:');
    cartItems.forEach((item) {
      print(
          'Product ID: ${item.id}, Title: ${item.title}, Quantity: ${item.quantity}');
    });
  }

  void tapOnDecrement(int index) {
    // Ensure the cart item at the given index exists and is valid
    if (index >= 0 && index < cartItems.length) {
      // Check if the quantity is greater than 1 to allow decrement
      if (cartItems[index].quantity!.value > 1) {
        // Decrement the quantity
        cartItems[index].quantity!.value -= 1;

        // Update the total product price based on the base price and quantity
        if (cartItems[index].basePrice != null) {
          double productBasePrice =
              cartItems[index].basePrice!.toDouble(); // Use the base price
          cartItems[index].price!.value =
              productBasePrice * cartItems[index].quantity!.value;
        }
        // Update subtotal by adding the base price
        if (cartItems[index].basePrice != null) {
          subTotal.value -= cartItems[index].basePrice!;
        }

        update(); // Update the UI
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
      cartItems[index].quantity = RxInt(0);
    }

    // Increment the quantity safely
    cartItems[index].quantity!.value += 1;

    // Update the product price using the base price
    if (cartItems[index].basePrice != null) {
      double priceToAdd = cartItems[index].basePrice!; // Use the base price
      cartItems[index].price!.value =
          priceToAdd * cartItems[index].quantity!.value;
    }
    // Update subtotal by adding the base price
    if (cartItems[index].basePrice != null) {
      subTotal.value += cartItems[index].basePrice!;
    }

    update(); // Update the UI
  }

  // Method to get all products in the cart
  List<ProductA> getCartItems() {
    return cartItems; // Return the list of cart items
  }
}
