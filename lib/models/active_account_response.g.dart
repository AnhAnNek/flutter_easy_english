// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveAccountResponse _$ActiveAccountResponseFromJson(
        Map<String, dynamic> json) =>
    ActiveAccountResponse(
      message: json['message'] as String,
      userDTO: UserDTO.fromJson(json['userDTO'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActiveAccountResponseToJson(
        ActiveAccountResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'userDTO': instance.userDTO,
    };
