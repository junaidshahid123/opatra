class MDAllVideos {
  bool? success;
  List<Video>? data;

  MDAllVideos({this.success, this.data});

  MDAllVideos.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Video>[];
      json['data'].forEach((v) {
        data!.add(Video.fromJson(v));
      });
    }
  }
}

class Video {
  int? id;
  String? name;
  String? description;
  String? videoUrl;
  String? thumbnail;
  int? status;
  String? createdAt;
  String? updatedAt;

  Video(
      {this.id,
        this.name,
        this.description,
        this.videoUrl,
        this.thumbnail,
        this.status,
        this.createdAt,
        this.updatedAt});

  // Factory constructor to convert JSON data to Video object
  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    videoUrl = json['video_url']; // Correct JSON key
    thumbnail = json['thumbnail']; // Correct JSON key
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
