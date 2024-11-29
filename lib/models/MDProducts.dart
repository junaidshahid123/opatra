class MDProducts {
  List<Products>? products;
  MDProducts({this.products});
  MDProducts.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
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
  List<VariantsA>? variants;
  List<Options>? options;
  List<Images>? images;
  Images? image;

  Products(
      {this.id,
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
        this.image});

  Products.fromJson(Map<String, dynamic> json) {
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
      variants = <VariantsA>[];
      json['variants'].forEach((v) {
        variants!.add(new VariantsA.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['body_html'] = this.bodyHtml;
    data['vendor'] = this.vendor;
    data['product_type'] = this.productType;
    data['created_at'] = this.createdAt;
    data['handle'] = this.handle;
    data['updated_at'] = this.updatedAt;
    data['published_at'] = this.publishedAt;
    data['template_suffix'] = this.templateSuffix;
    data['published_scope'] = this.publishedScope;
    data['tags'] = this.tags;
    data['status'] = this.status;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    if (this.variants != null) {
      data['variants'] = this.variants!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class VariantsA {
  int? id;
  int? productId;
  String? title;
  String? price;
  int? position;
  String? inventoryPolicy;
  String? compareAtPrice;
  String? option1;
  Null option2;
  Null option3;
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
  Null imageId;

  VariantsA(
      {this.id,
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
        this.imageId});

  VariantsA.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['price'] = this.price;
    data['position'] = this.position;
    data['inventory_policy'] = this.inventoryPolicy;
    data['compare_at_price'] = this.compareAtPrice;
    data['option1'] = this.option1;
    data['option2'] = this.option2;
    data['option3'] = this.option3;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['taxable'] = this.taxable;
    data['barcode'] = this.barcode;
    data['fulfillment_service'] = this.fulfillmentService;
    data['grams'] = this.grams;
    data['inventory_management'] = this.inventoryManagement;
    data['requires_shipping'] = this.requiresShipping;
    data['sku'] = this.sku;
    data['weight'] = this.weight;
    data['weight_unit'] = this.weightUnit;
    data['inventory_item_id'] = this.inventoryItemId;
    data['inventory_quantity'] = this.inventoryQuantity;
    data['old_inventory_quantity'] = this.oldInventoryQuantity;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    data['image_id'] = this.imageId;
    return data;
  }
}

class Options {
  int? id;
  int? productId;
  String? name;
  int? position;
  List<String>? values;

  Options({this.id, this.productId, this.name, this.position, this.values});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    name = json['name'];
    position = json['position'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['position'] = this.position;
    data['values'] = this.values;
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
  List<VariantsA>? variantIds;

  Images(
      {this.id,
        this.alt,
        this.position,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.adminGraphqlApiId,
        this.width,
        this.height,
        this.src,
        this.variantIds});

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
    if (json['variant_ids'] != null) {
      variantIds = <VariantsA>[];
      json['variant_ids'].forEach((v) {
        variantIds!.add(new VariantsA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alt'] = this.alt;
    data['position'] = this.position;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    data['width'] = this.width;
    data['height'] = this.height;
    data['src'] = this.src;
    if (this.variantIds != null) {
      data['variant_ids'] = this.variantIds!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

