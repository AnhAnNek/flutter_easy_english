// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePasswordRequest _$UpdatePasswordRequestFromJson(
        Map<String, dynamic> json) =>
    UpdatePasswordRequest(
      username: json['username'] as String,
      newPassword: json['password'] as String,
      confirmPassword: json['confirmPassword'] as String,
    );

Map<String, dynamic> _$UpdatePasswordRequestToJson(
        UpdatePasswordRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.newPassword,
      'confirmPassword': instance.confirmPassword,
    };
