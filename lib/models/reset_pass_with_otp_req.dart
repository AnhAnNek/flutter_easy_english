import 'package:json_annotation/json_annotation.dart';

part 'reset_pass_with_otp_req.g.dart';

@JsonSerializable()
class ResetPassWithOtpReq {
  final String email;
  final String otp;
  final String newPassword;

  ResetPassWithOtpReq({
    required this.email,
    required this.otp,
    required this.newPassword,
  });

  // From JSON
  factory ResetPassWithOtpReq.fromJson(Map<String, dynamic> json) => _$ResetPassWithOtpReqFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$ResetPassWithOtpReqToJson(this);
}