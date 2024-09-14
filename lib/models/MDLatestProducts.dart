// Model class for the latest products
class MDLatestProducts {
  List<Products> products;

  MDLatestProducts({required this.products});

  // JSON deserialization
  MDLatestProducts.fromJson(Map<String, dynamic> json)
      : products = (json['products'] as List)
      .map((v) => Products.fromJson(v))
      .toList();

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'products': products.map((v) => v.toJson()).toList(),
    };
  }
}

// Model class for Products
class Products {
  int id;
  String title;
  String? bodyHtml;  // Nullable field
  String vendor;
  String productType;
  String createdAt;
  String handle;
  String updatedAt;
  String publishedAt;
  String? templateSuffix;  // Nullable field
  String publishedScope;
  String tags;
  String status;
  String adminGraphqlApiId;
  List<Variants> variants;
  List<Options> options;
  List<Images> images;
  Images? image;  // Nullable field

  Products({
    required this.id,
    required this.title,
    this.bodyHtml, // Nullable field
    required this.vendor,
    required this.productType,
    required this.createdAt,
    required this.handle,
    required this.updatedAt,
    required this.publishedAt,
    this.templateSuffix, // Nullable field
    required this.publishedScope,
    required this.tags,
    required this.status,
    required this.adminGraphqlApiId,
    required this.variants,
    required this.options,
    required this.images,
    this.image,  // Nullable field
  });

  // JSON deserialization
  Products.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        title = json['title'] ?? '',
        bodyHtml = json['body_html'],
        vendor = json['vendor'] ?? 'Unknown vendor',
        productType = json['product_type'] ?? 'Unknown type',
        createdAt = json['created_at'] ?? '',
        handle = json['handle'] ?? '',
        updatedAt = json['updated_at'] ?? '',
        publishedAt = json['published_at'] ?? '',
        templateSuffix = json['template_suffix'],
        publishedScope = json['published_scope'] ?? '',
        tags = json['tags'] ?? '',
        status = json['status'] ?? '',
        adminGraphqlApiId = json['admin_graphql_api_id'] ?? '',
        variants = (json['variants'] as List)
            .map((v) => Variants.fromJson(v))
            .toList(),
        options = (json['options'] as List)
            .map((v) => Options.fromJson(v))
            .toList(),
        images = (json['images'] as List)
            .map((v) => Images.fromJson(v))
            .toList(),
        image = json['image'] != null
            ? Images.fromJson(json['image'])
            : null;

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'title': title,
      'body_html': bodyHtml,
      'vendor': vendor,
      'product_type': productType,
      'created_at': createdAt,
      'handle': handle,
      'updated_at': updatedAt,
      'published_at': publishedAt,
      'template_suffix': templateSuffix,
      'published_scope': publishedScope,
      'tags': tags,
      'status': status,
      'admin_graphql_api_id': adminGraphqlApiId,
      'variants': variants.map((v) => v.toJson()).toList(),
      'options': options.map((v) => v.toJson()).toList(),
      'images': images.map((v) => v.toJson()).toList(),
    };
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

// Model class for Variants
class Variants {
  int id;
  int productId;
  String title;
  String price;
  int position;
  String inventoryPolicy;
  String? compareAtPrice; // Nullable field
  String option1;
  String? option2; // Nullable field
  String? option3; // Nullable field
  String createdAt;
  String updatedAt;
  bool taxable;
  String? barcode; // Nullable field
  String fulfillmentService;
  int grams;
  String? inventoryManagement; // Nullable field
  bool requiresShipping;
  String sku;
  int weight;
  String weightUnit;
  int inventoryItemId;
  int inventoryQuantity;
  int oldInventoryQuantity;
  String adminGraphqlApiId;
  int? imageId; // Nullable field

  Variants({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.position,
    required this.inventoryPolicy,
    this.compareAtPrice, // Nullable field
    required this.option1,
    this.option2, // Nullable field
    this.option3, // Nullable field
    required this.createdAt,
    required this.updatedAt,
    required this.taxable,
    this.barcode, // Nullable field
    required this.fulfillmentService,
    required this.grams,
    this.inventoryManagement, // Nullable field
    required this.requiresShipping,
    required this.sku,
    required this.weight,
    required this.weightUnit,
    required this.inventoryItemId,
    required this.inventoryQuantity,
    required this.oldInventoryQuantity,
    required this.adminGraphqlApiId,
    this.imageId, // Nullable field
  });

  // JSON deserialization
  Variants.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        productId = json['product_id'] ?? 0,
        title = json['title'] ?? '',
        price = json['price'] ?? '',
        position = json['position'] ?? 0,
        inventoryPolicy = json['inventory_policy'] ?? '',
        compareAtPrice = json['compare_at_price'],
        option1 = json['option1'] ?? '',
        option2 = json['option2'],
        option3 = json['option3'],
        createdAt = json['created_at'] ?? '',
        updatedAt = json['updated_at'] ?? '',
        taxable = json['taxable'] ?? false,
        barcode = json['barcode'],
        fulfillmentService = json['fulfillment_service'] ?? '',
        grams = json['grams'] ?? 0,
        inventoryManagement = json['inventory_management'],
        requiresShipping = json['requires_shipping'] ?? false,
        sku = json['sku'] ?? '',
        weight = json['weight'] ?? 0,
        weightUnit = json['weight_unit'] ?? '',
        inventoryItemId = json['inventory_item_id'] ?? 0,
        inventoryQuantity = json['inventory_quantity'] ?? 0,
        oldInventoryQuantity = json['old_inventory_quantity'] ?? 0,
        adminGraphqlApiId = json['admin_graphql_api_id'] ?? '',
        imageId = json['image_id'];

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'product_id': productId,
      'title': title,
      'price': price,
      'position': position,
      'inventory_policy': inventoryPolicy,
      'compare_at_price': compareAtPrice,
      'option1': option1,
      'option2': option2,
      'option3': option3,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'taxable': taxable,
      'barcode': barcode,
      'fulfillment_service': fulfillmentService,
      'grams': grams,
      'inventory_management': inventoryManagement,
      'requires_shipping': requiresShipping,
      'sku': sku,
      'weight': weight,
      'weight_unit': weightUnit,
      'inventory_item_id': inventoryItemId,
      'inventory_quantity': inventoryQuantity,
      'old_inventory_quantity': oldInventoryQuantity,
      'admin_graphql_api_id': adminGraphqlApiId,
      'image_id': imageId,
    };
    return data;
  }
}

// Model class for Options
class Options {
  int id;
  int productId;
  String name;
  int position;
  List<String> values;

  Options({
    required this.id,
    required this.productId,
    required this.name,
    required this.position,
    required this.values,
  });

  // JSON deserialization
  Options.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        productId = json['product_id'] ?? 0,
        name = json['name'] ?? '',
        position = json['position'] ?? 0,
        values = List<String>.from(json['values'] ?? []);

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'position': position,
      'values': values,
    };
  }
}

// Model class for Images
class Images {
  int id;
  int productId;
  String? src; // Nullable field
  String createdAt;
  String updatedAt;
  int? position; // Nullable field
  List<int>? variantIds; // Nullable field
  String? adminGraphqlApiId; // Nullable field

  Images({
    required this.id,
    required this.productId,
    this.src, // Nullable field
    required this.createdAt,
    required this.updatedAt,
    this.position, // Nullable field
    this.variantIds, // Nullable field
    this.adminGraphqlApiId, // Nullable field
  });

  // JSON deserialization
  Images.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        productId = json['product_id'] ?? 0,
        src = json['src'],
        createdAt = json['created_at'] ?? '',
        updatedAt = json['updated_at'] ?? '',
        position = json['position'] != null ? json['position'].toInt() : null,
        variantIds = json['variant_ids'] != null ? List<int>.from(json['variant_ids']) : null,
        adminGraphqlApiId = json['admin_graphql_api_id'];

  // JSON serialization
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'id': id,
      'product_id': productId,
      'src': src,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'position': position,
      'variant_ids': variantIds,
      'admin_graphql_api_id': adminGraphqlApiId,
    };
    return data;
  }
}