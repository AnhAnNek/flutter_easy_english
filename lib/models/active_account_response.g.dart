// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveAccountResponse _$ActiveAccountResponseFromJson(
        Map<String, dynamic> json) =>
    ActiveAccountResponse(
      message: json['message'] as String,
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActiveAccountResponseToJson(
        ActiveAccountResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };
