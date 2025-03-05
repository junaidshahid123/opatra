class MDGetAppModules {
  bool? success;
  List<Data>? data;

  MDGetAppModules({this.success, this.data});

  MDGetAppModules.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;

  Data({this.id, this.name});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class MDSkinCareProducts {
  List<CustomCollections>? customCollections;

  MDSkinCareProducts({this.customCollections});

  MDSkinCareProducts.fromJson(Map<String, dynamic> json) {
    if (json['custom_collections'] != null) {
      customCollections = <CustomCollections>[];
      json['custom_collections'].forEach((v) {
        customCollections!.add(new CustomCollections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customCollections != null) {
      data['custom_collections'] =
          this.customCollections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomCollections {
  int? id;
  String? handle;
  String? title;
  String? updatedAt;
  String? bodyHtml;
  String? publishedAt;
  String? sortOrder;
  String? templateSuffix;
  String? publishedScope;
  String? adminGraphqlApiId;

  CustomCollections(
      {this.id,
        this.handle,
        this.title,
        this.updatedAt,
        this.bodyHtml,
        this.publishedAt,
        this.sortOrder,
        this.templateSuffix,
        this.publishedScope,
        this.adminGraphqlApiId});

  CustomCollections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handle = json['handle'];
    title = json['title'];
    updatedAt = json['updated_at'];
    bodyHtml = json['body_html'];
    publishedAt = json['published_at'];
    sortOrder = json['sort_order'];
    templateSuffix = json['template_suffix'];
    publishedScope = json['published_scope'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['handle'] = this.handle;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    data['body_html'] = this.bodyHtml;
    data['published_at'] = this.publishedAt;
    data['sort_order'] = this.sortOrder;
    data['template_suffix'] = this.templateSuffix;
    data['published_scope'] = this.publishedScope;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    return data;
  }
}

class MDDevicesProducts {
  List<CustomCollectionsA>? customCollections;

  MDDevicesProducts({this.customCollections});

  MDDevicesProducts.fromJson(Map<String, dynamic> json) {
    if (json['custom_collections'] != null) {
      customCollections = <CustomCollectionsA>[];
      json['custom_collections'].forEach((v) {
        customCollections!.add(new CustomCollectionsA.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.customCollections != null) {
      data['custom_collections'] =
          this.customCollections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomCollectionsA{
  int? id;
  String? handle;
  String? title;
  String? updatedAt;
  String? bodyHtml;
  String? publishedAt;
  String? sortOrder;
  String? templateSuffix;
  String? publishedScope;
  String? adminGraphqlApiId;
  Image? image;

  CustomCollectionsA(
      {this.id,
        this.handle,
        this.title,
        this.updatedAt,
        this.bodyHtml,
        this.publishedAt,
        this.sortOrder,
        this.templateSuffix,
        this.publishedScope,
        this.adminGraphqlApiId,
        this.image});

  CustomCollectionsA.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handle = json['handle'];
    title = json['title'];
    updatedAt = json['updated_at'];
    bodyHtml = json['body_html'];
    publishedAt = json['published_at'];
    sortOrder = json['sort_order'];
    templateSuffix = json['template_suffix'];
    publishedScope = json['published_scope'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['handle'] = this.handle;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    data['body_html'] = this.bodyHtml;
    data['published_at'] = this.publishedAt;
    data['sort_order'] = this.sortOrder;
    data['template_suffix'] = this.templateSuffix;
    data['published_scope'] = this.publishedScope;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Image {
  String? createdAt;
  String? alt;
  int? width;
  int? height;
  String? src;

  Image({this.createdAt, this.alt, this.width, this.height, this.src});

  Image.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    alt = json['alt'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['alt'] = this.alt;
    data['width'] = this.width;
    data['height'] = this.height;
    data['src'] = this.src;
    return data;
  }
}