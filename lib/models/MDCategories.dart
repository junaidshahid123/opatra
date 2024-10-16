class MDCategories {
  List<SmartCollections>? smartCollections;

  MDCategories({this.smartCollections});

  MDCategories.fromJson(Map<String, dynamic> json) {
    if (json['smart_collections'] != null) {
      smartCollections = <SmartCollections>[];
      json['smart_collections'].forEach((v) {
        smartCollections!.add(new SmartCollections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.smartCollections != null) {
      data['smart_collections'] =
          this.smartCollections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SmartCollections {
  int? id;
  String? handle;
  String? title;
  String? updatedAt;
  String? bodyHtml;
  String? publishedAt;
  String? sortOrder;
  String? templateSuffix;
  bool? disjunctive;
  List<Rules>? rules;
  String? publishedScope;
  String? adminGraphqlApiId;
  Image? image;

  SmartCollections(
      {this.id,
        this.handle,
        this.title,
        this.updatedAt,
        this.bodyHtml,
        this.publishedAt,
        this.sortOrder,
        this.templateSuffix,
        this.disjunctive,
        this.rules,
        this.publishedScope,
        this.adminGraphqlApiId,
        this.image});

  SmartCollections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handle = json['handle'];
    title = json['title'];
    updatedAt = json['updated_at'];
    bodyHtml = json['body_html'];
    publishedAt = json['published_at'];
    sortOrder = json['sort_order'];
    templateSuffix = json['template_suffix'];
    disjunctive = json['disjunctive'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(new Rules.fromJson(v));
      });
    }
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
    data['disjunctive'] = this.disjunctive;
    if (this.rules != null) {
      data['rules'] = this.rules!.map((v) => v.toJson()).toList();
    }
    data['published_scope'] = this.publishedScope;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class Rules {
  String? column;
  String? relation;
  String? condition;

  Rules({this.column, this.relation, this.condition});

  Rules.fromJson(Map<String, dynamic> json) {
    column = json['column'];
    relation = json['relation'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['column'] = this.column;
    data['relation'] = this.relation;
    data['condition'] = this.condition;
    return data;
  }
}

class Image {
  String? createdAt;
  Null alt;
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