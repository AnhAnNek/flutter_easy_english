import 'package:json_annotation/json_annotation.dart';

part 'course_request.g.dart';

enum EStatus { PUBLISHED, REJECTED, PENDING_APPROVAL, DRAFT, DELETED }

@JsonSerializable(explicitToJson: true)
class CourseRequest {
  String? username;
  int? favoriteId;
  int? id;
  String? title;
  int? levelId;
  int? topicId;
  String? imagePreview;
  String? videoPreview;
  String? descriptionPreview;
  String? description;
  int? duration;
  int countView = 0;
  String? notice;
  EStatus? status;
  String? ownerUsername;
  double? price;
  double? rating;
  List<int>? categoryIds;
  int pageNumber = 0;
  int size = 8;

  CourseRequest({
    this.username,
    this.favoriteId,
    this.id,
    this.title,
    this.levelId,
    this.topicId,
    this.imagePreview,
    this.videoPreview,
    this.descriptionPreview,
    this.description,
    this.duration,
    this.countView = 0,
    this.notice,
    this.status,
    this.ownerUsername,
    this.price,
    this.rating,
    this.categoryIds,
    this.pageNumber = 0,
    this.size = 8,
  });

  // Factory constructor to create an instance from a JSON map
  factory CourseRequest.fromJson(Map<String, dynamic> json) =>
      _$CourseRequestFromJson(json);

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() => _$CourseRequestToJson(this);
}
