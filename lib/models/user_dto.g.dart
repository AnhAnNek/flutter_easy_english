// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      bio: json['bio'] as String,
      gender: $enumDecode(_$EGenderEnumMap, json['gender']),
      dob: DateTime.parse(json['dob'] as String),
      role: $enumDecodeNullable(_$ERoleEnumMap, json['role']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      avatarPath: json['avatarPath'] as String?,
    );

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
      'username': instance.username,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'bio': instance.bio,
      'gender': _$EGenderEnumMap[instance.gender]!,
      'dob': instance.dob.toIso8601String(),
      'role': _$ERoleEnumMap[instance.role],
      'createdAt': instance.createdAt.toIso8601String(),
      'avatarPath': instance.avatarPath,
    };

const _$EGenderEnumMap = {
  EGender.MALE: 'MALE',
  EGender.FEMALE: 'FEMALE',
  EGender.OTHER: 'OTHER',
};

const _$ERoleEnumMap = {
  ERole.STUDENT: 'STUDENT',
  ERole.TEACHER: 'TEACHER',
  ERole.ADMIN: 'ADMIN',
};
