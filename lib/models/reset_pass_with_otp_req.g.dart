// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_pass_with_otp_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResetPassWithOtpReq _$ResetPassWithOtpReqFromJson(Map<String, dynamic> json) =>
    ResetPassWithOtpReq(
      email: json['email'] as String,
      otp: json['otp'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ResetPassWithOtpReqToJson(
        ResetPassWithOtpReq instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
      'newPassword': instance.newPassword,
    };
