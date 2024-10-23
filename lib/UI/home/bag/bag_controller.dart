import 'package:get/get.dart';

import '../../../models/MDProductDetail.dart';

class BagController extends GetxController {
  RxInt quantity = 1.obs;
  List<ProductA> cartItems = [];

  var bagItems = <ProductA, int>{}.obs; // Product as key, quantity as value
  var quantities = <int>[].obs; // Corresponding quantities for each product

  // New map to store total prices for each product
  RxMap<Product, double> totalPrices = <Product, double>{}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

// Method to add a product to the cart
  void addProductToBag(ProductA product, int quantity, String selectedCurrency) {
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
      cartItems[existingIndex].quantity = (cartItems[existingIndex].quantity ?? 0) + quantity;
      print('Updated Quantity for ${cartItems[existingIndex].title}: ${cartItems[existingIndex].quantity}');
    } else {
      // Otherwise, add the new product to the cart
      print('Adding new product to cart.');
      product.quantity = quantity; // Set the initial quantity
      cartItems.add(product);
      print('Product ${product.title} added with Quantity: $quantity');
    }

    // Optionally, if you want to log the entire cart after adding
    print('Current Cart Items:');
    cartItems.forEach((item) {
      print('Product ID: ${item.id}, Title: ${item.title}, Quantity: ${item.quantity}');
    });
  }

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

  // Method to get all products in the cart
  List<ProductA> getCartItems() {
    return cartItems; // Return the list of cart items
  }
}
