// class MDVideosByCategory {
//   bool? success;
//   Data? data;
//
//   MDVideosByCategory({this.success, this.data});
//
//   MDVideosByCategory.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['success'] = this.success;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? name;
//   String? description;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   List<Videos>? videos;
//
//   Data({
//     this.id,
//     this.name,
//     this.description,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.videos,
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//
//     if (json['videos'] != null && json['videos'] is List) {
//       videos = <Videos>[];
//       for (var v in json['videos']) {
//         if (v is Map<String, dynamic>) {
//           videos!.add(Videos.fromJson(v));
//         }
//       }
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.videos != null) {
//       data['videos'] = this.videos!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Videos {
//   int? id;
//   String? name;
//   String? description;
//   String? videoUrl;
//   String? thumbnail;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   int? categoryId;
//   Category? category;
//
//   Videos({
//     this.id,
//     this.name,
//     this.description,
//     this.videoUrl,
//     this.thumbnail,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//     this.categoryId,
//     this.category,
//   });
//
//   Videos.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     videoUrl = json['video_url'];
//     thumbnail = json['thumbnail'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     categoryId = json['category_id'];
//
//     // 👇 Fixed safely
//     if (json['category'] != null && json['category'] is Map<String, dynamic>) {
//       category = Category.fromJson(json['category']);
//     } else {
//       category = null;
//     }
//   }
//
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['video_url'] = this.videoUrl;
//     data['thumbnail'] = this.thumbnail;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['category_id'] = this.categoryId;
//     if (this.category != null) {
//       data['category'] = this.category!.toJson();
//     }
//     return data;
//   }
// }
//
// class Category {
//   int? id;
//   String? name;
//   String? description;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//
//   Category({
//     this.id,
//     this.name,
//     this.description,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Category.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     status = json['status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['status'] = this.status;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class CategoryModel {
  final int? id;
  final String? name;
  final String? description;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<VideoModel>? videos;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.videos,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      videos: json['videos'] != null
          ? (json['videos'] as List).map((video) => VideoModel.fromJson(video)).toList()
          : null,
    );
  }
}

class VideoModel {
  final int? id;
  final String? name;
  final String? description;
  final String? videoUrl;
  final String? thumbnail;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? categoryId;
  final CategoryShortModel? category;

  VideoModel({
    this.id,
    this.name,
    this.description,
    this.videoUrl,
    this.thumbnail,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.category,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnail: json['thumbnail'] is String ? json['thumbnail'] : null,
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      categoryId: json['category_id'],
      category: json['category'] != null ? CategoryShortModel.fromJson(json['category']) : null,
    );
  }
}

class CategoryShortModel {
  final int? id;
  final String? name;
  final String? description;
  final int? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryShortModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryShortModel.fromJson(Map<String, dynamic> json) {
    return CategoryShortModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}




