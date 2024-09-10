class MDProductCategoryDetail {
  SmartCollection? smartCollection;

  MDProductCategoryDetail({this.smartCollection});

  MDProductCategoryDetail.fromJson(Map<String, dynamic> json) {
    smartCollection = json['smart_collection'] != null
        ? new SmartCollection.fromJson(json['smart_collection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.smartCollection != null) {
      data['smart_collection'] = this.smartCollection!.toJson();
    }
    return data;
  }
}

class SmartCollection {
  int? id;
  String? handle;
  String? title;
  String? updatedAt;
  String? bodyHtml;
  String? publishedAt;
  String? sortOrder;
  String? templateSuffix;
  int? productsCount;
  bool? disjunctive;
  List<Rules>? rules;
  String? publishedScope;
  String? adminGraphqlApiId;

  SmartCollection(
      {this.id,
      this.handle,
      this.title,
      this.updatedAt,
      this.bodyHtml,
      this.publishedAt,
      this.sortOrder,
      this.templateSuffix,
      this.productsCount,
      this.disjunctive,
      this.rules,
      this.publishedScope,
      this.adminGraphqlApiId});

  SmartCollection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    handle = json['handle'];
    title = json['title'];
    updatedAt = json['updated_at'];
    bodyHtml = json['body_html'];
    publishedAt = json['published_at'];
    sortOrder = json['sort_order'];
    templateSuffix = json['template_suffix'];
    productsCount = json['products_count'];
    disjunctive = json['disjunctive'];
    if (json['rules'] != null) {
      rules = <Rules>[];
      json['rules'].forEach((v) {
        rules!.add(new Rules.fromJson(v));
      });
    }
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
    data['products_count'] = this.productsCount;
    data['disjunctive'] = this.disjunctive;
    if (this.rules != null) {
      data['rules'] = this.rules!.map((v) => v.toJson()).toList();
    }
    data['published_scope'] = this.publishedScope;
    data['admin_graphql_api_id'] = this.adminGraphqlApiId;
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
