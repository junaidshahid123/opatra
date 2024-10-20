import 'package:get/get.dart';

import '../../../models/MDProductDetail.dart';

class BagController extends GetxController {
  RxInt quantity = 1.obs;

  var bagItems = <Product, int>{}.obs; // Product as key, quantity as value
  var quantities = <int>[].obs;   // Corresponding quantities for each product
  var initialBagItems;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     initialBagItems = getBagItems();

  }

  // Method to add a product to the bag
  void addProductToBag(Product product, int quantity) {
    if (bagItems.containsKey(product)) {
      // If the product already exists, update the quantity
      bagItems[product] = bagItems[product]! + quantity;
    } else {
      // Otherwise, add the new product with its quantity
      bagItems[product] = quantity;
    }
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

  // Method to get all products in the bag
  RxMap<Product, int> getBagItems() {
    return bagItems;
  }
}
