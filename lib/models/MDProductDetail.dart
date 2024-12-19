import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MDProductDetail {
  ProductB? product;

  MDProductDetail({this.product});

  MDProductDetail.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? ProductB.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class ProductB {
  int? id;
  String? title;
  String? bodyHtml;
  String? vendor;
  String? productType;
  String? createdAt;
  String? handle;
  String? updatedAt;
  String? publishedAt;
  String? templateSuffix;
  String? publishedScope;
  String? tags;
  String? status;
  String? adminGraphqlApiId;
  List<Variants>? variants;
  List<Options>? options;
  List<Images>? images;
  Images? image;

  ProductB({
    this.id,
    this.title,
    this.bodyHtml,
    this.vendor,
    this.productType,
    this.createdAt,
    this.handle,
    this.updatedAt,
    this.publishedAt,
    this.templateSuffix,
    this.publishedScope,
    this.tags,
    this.status,
    this.adminGraphqlApiId,
    this.variants,
    this.options,
    this.images,
    this.image,
  });

  ProductB.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    bodyHtml = json['body_html'];
    vendor = json['vendor'];
    productType = json['product_type'];
    createdAt = json['created_at'];
    handle = json['handle'];
    updatedAt = json['updated_at'];
    publishedAt = json['published_at'];
    templateSuffix = json['template_suffix'];
    publishedScope = json['published_scope'];
    tags = json['tags'];
    status = json['status'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    if (json['variants'] != null) {
      variants =
          (json['variants'] as List).map((v) => Variants.fromJson(v)).toList();
    }
    if (json['options'] != null) {
      options =
          (json['options'] as List).map((v) => Options.fromJson(v)).toList();
    }
    if (json['images'] != null) {
      images = (json['images'] as List).map((v) => Images.fromJson(v)).toList();
    }
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['body_html'] = bodyHtml;
    data['vendor'] = vendor;
    data['product_type'] = productType;
    data['created_at'] = createdAt;
    data['handle'] = handle;
    data['updated_at'] = updatedAt;
    data['published_at'] = publishedAt;
    data['template_suffix'] = templateSuffix;
    data['published_scope'] = publishedScope;
    data['tags'] = tags;
    data['status'] = status;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class Variants {
  int? id;
  int? productId;
  String? title;
  String? price;
  int? position;
  String? inventoryPolicy;
  String? compareAtPrice;
  String? option1;
  String? option2;
  String? option3;
  String? createdAt;
  String? updatedAt;
  bool? taxable;
  String? barcode;
  String? fulfillmentService;
  int? grams;
  String? inventoryManagement;
  bool? requiresShipping;
  String? sku;
  int? weight;
  String? weightUnit;
  int? inventoryItemId;
  int? inventoryQuantity;
  int? oldInventoryQuantity;
  String? adminGraphqlApiId;
  String? imageId;

  Variants({
    this.id,
    this.productId,
    this.title,
    this.price,
    this.position,
    this.inventoryPolicy,
    this.compareAtPrice,
    this.option1,
    this.option2,
    this.option3,
    this.createdAt,
    this.updatedAt,
    this.taxable,
    this.barcode,
    this.fulfillmentService,
    this.grams,
    this.inventoryManagement,
    this.requiresShipping,
    this.sku,
    this.weight,
    this.weightUnit,
    this.inventoryItemId,
    this.inventoryQuantity,
    this.oldInventoryQuantity,
    this.adminGraphqlApiId,
    this.imageId,
  });

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'];
    price = json['price'];
    position = json['position'];
    inventoryPolicy = json['inventory_policy'];
    compareAtPrice = json['compare_at_price'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxable = json['taxable'];
    barcode = json['barcode'];
    fulfillmentService = json['fulfillment_service'];
    grams = json['grams'];
    inventoryManagement = json['inventory_management'];
    requiresShipping = json['requires_shipping'];
    sku = json['sku'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    inventoryItemId = json['inventory_item_id'];
    inventoryQuantity = json['inventory_quantity'];
    oldInventoryQuantity = json['old_inventory_quantity'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    imageId = json['image_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['title'] = title;
    data['price'] = price;
    data['position'] = position;
    data['inventory_policy'] = inventoryPolicy;
    data['compare_at_price'] = compareAtPrice;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['taxable'] = taxable;
    data['barcode'] = barcode;
    data['fulfillment_service'] = fulfillmentService;
    data['grams'] = grams;
    data['inventory_management'] = inventoryManagement;
    data['requires_shipping'] = requiresShipping;
    data['sku'] = sku;
    data['weight'] = weight;
    data['weight_unit'] = weightUnit;
    data['inventory_item_id'] = inventoryItemId;
    data['inventory_quantity'] = inventoryQuantity;
    data['old_inventory_quantity'] = oldInventoryQuantity;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    data['image_id'] = imageId;
    return data;
  }
}

class Options {
  int? id;
  int? productId;
  String? name;
  int? position;
  List<String>? values;

  Options({
    this.id,
    this.productId,
    this.name,
    this.position,
    this.values,
  });

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    position = json['position'];
    values = (json['values'] as List?)?.map((e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['product_id'] = productId;
    data['name'] = name;
    data['position'] = position;
    data['values'] = values;
    return data;
  }
}

class Images {
  int? id;
  String? alt;
  int? position;
  int? productId;
  String? createdAt;
  String? updatedAt;
  String? adminGraphqlApiId;
  int? width;
  int? height;
  String? src;
  List<int>? variantIds;

  Images({
    this.id,
    this.alt,
    this.position,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.adminGraphqlApiId,
    this.width,
    this.height,
    this.src,
    this.variantIds,
  });

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alt = json['alt'];
    position = json['position'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
    variantIds = (json['variant_ids'] as List?)?.map((e) => e as int).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['alt'] = alt;
    data['position'] = position;
    data['product_id'] = productId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    data['width'] = width;
    data['height'] = height;
    data['src'] = src;
    data['variant_ids'] = variantIds;
    return data;
  }
}

class ProductA {
  int? id;
  String? title;
  Images? image;
  RxDouble? price; // Observable price that updates
  double? basePrice; // Fixed base price
  RxInt? quantity;
  String? selectedCurrency;

  ProductA({
    this.id,
    this.title,
    this.image,
    double? price,
    int? quantity,
    this.selectedCurrency,
  }) {
    this.price = price != null ? RxDouble(price) : RxDouble(0);
    this.basePrice = price; // Keep the original price
    this.quantity = quantity != null ? RxInt(quantity) : RxInt(0);
  }

  ProductA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'] != null ? Images.fromJson(json['image']) : null;
    price = RxDouble(json['price']?.toDouble() ?? 0);
    basePrice = json['price']?.toDouble(); // Set base price from JSON
    quantity = RxInt(json['quantity'] ?? 0);
    selectedCurrency = json['selectedCurrency'];
  }

  // Convert ProductA to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image?.toJson(), // Assuming Images has toJson method
      'price': price?.value,
      'basePrice': basePrice,
      'quantity': quantity?.value,
      'selectedCurrency': selectedCurrency,
    };
  }
}
