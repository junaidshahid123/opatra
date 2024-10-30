class MDGetDevices {
  bool? success;
  List<Data>? data;

  MDGetDevices({this.success, this.data});


  MDGetDevices.fromJson(Map<String, dynamic> json) {
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
  String? productId;
  String? productName;
  Null? time;
  int? userId;
  String? createdAt;
  String? updatedAt;
  List<Days>? days;
  String? imageUrl; // New attribute for storing image URL

  Data({
    this.id,
    this.productId,
    this.productName,
    this.time,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.days,
    this.imageUrl,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    productName = json['product_name'];
    time = json['time'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['days'] != null) {
      days = <Days>[];
      json['days'].forEach((v) {
        days!.add(Days.fromJson(v));
      });
    }
    imageUrl = json['image_url'] ?? ''; // Ensure correct key
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['time'] = time;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    data['image_url'] = imageUrl; // Ensure correct key
    return data;
  }
}


class Days {
  int? id;
  String? day;
  String? time;
  int? deviceScheduleId;
  String? createdAt;
  String? updatedAt;
  String? areas; // New attribute for storing areas

  Days({
    this.id,
    this.day,
    this.time,
    this.deviceScheduleId,
    this.createdAt,
    this.updatedAt,
    this.areas, // Include areas in the constructor
  });

  Days.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    day = json['day'];
    time = json['time'];
    deviceScheduleId = json['device_schedule_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    areas = json['areas']; // Deserialize areas from JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['day'] = this.day;
    data['time'] = this.time;
    data['device_schedule_id'] = this.deviceScheduleId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['areas'] = this.areas; // Serialize areas to JSON
    return data;
  }
}
