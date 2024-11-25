// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseRequest _$CourseRequestFromJson(Map<String, dynamic> json) =>
    CourseRequest(
      username: json['username'] as String?,
      favoriteId: (json['favoriteId'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      levelId: (json['levelId'] as num?)?.toInt(),
      topicId: (json['topicId'] as num?)?.toInt(),
      imagePreview: json['imagePreview'] as String?,
      videoPreview: json['videoPreview'] as String?,
      descriptionPreview: json['descriptionPreview'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      countView: (json['countView'] as num?)?.toInt() ?? 0,
      notice: json['notice'] as String?,
      status: $enumDecodeNullable(_$EStatusEnumMap, json['status']),
      ownerUsername: json['ownerUsername'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      categoryIds: (json['categoryIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      pageNumber: (json['pageNumber'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 8,
    );

Map<String, dynamic> _$CourseRequestToJson(CourseRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'favoriteId': instance.favoriteId,
      'id': instance.id,
      'title': instance.title,
      'levelId': instance.levelId,
      'topicId': instance.topicId,
      'imagePreview': instance.imagePreview,
      'videoPreview': instance.videoPreview,
      'descriptionPreview': instance.descriptionPreview,
      'description': instance.description,
      'duration': instance.duration,
      'countView': instance.countView,
      'notice': instance.notice,
      'status': _$EStatusEnumMap[instance.status],
      'ownerUsername': instance.ownerUsername,
      'price': instance.price,
      'rating': instance.rating,
      'categoryIds': instance.categoryIds,
      'pageNumber': instance.pageNumber,
      'size': instance.size,
    };

const _$EStatusEnumMap = {
  EStatus.PUBLISHED: 'PUBLISHED',
  EStatus.REJECTED: 'REJECTED',
  EStatus.PENDING_APPROVAL: 'PENDING_APPROVAL',
  EStatus.DRAFT: 'DRAFT',
  EStatus.DELETED: 'DELETED',
};
