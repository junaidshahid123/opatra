class MDProductDetailImages {
  List<Images>? images;

  MDProductDetailImages({this.images});

  MDProductDetailImages.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    } else {
      images = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
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
  List<int>? variantIds; // Replaced Null with int or your desired type

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
    if (json['variant_ids'] != null) {
      variantIds = List<int>.from(json['variant_ids']);
    } else {
      variantIds = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    if (variantIds != null) {
      data['variant_ids'] = variantIds;
    }
    return data;
  }
}
