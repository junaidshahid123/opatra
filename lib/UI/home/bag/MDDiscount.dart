class MDDiscount {
  bool? success;
  String? message;
  String? discount;
  String? validTill;

  MDDiscount({this.success, this.message, this.discount, this.validTill});

  MDDiscount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    discount = json['discount'];
    validTill = json['valid_till'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['discount'] = this.discount;
    data['valid_till'] = this.validTill;
    return data;
  }
}