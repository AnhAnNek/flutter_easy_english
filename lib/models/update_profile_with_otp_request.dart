import 'package:json_annotation/json_annotation.dart';

part 'update_profile_with_otp_request.g.dart';

@JsonSerializable()
class UpdateProfileWithOTPRequest {
  final String otp;

  UpdateProfileWithOTPRequest({
    required this.otp,
  });

  // From JSON
  factory UpdateProfileWithOTPRequest.fromJson(Map<String, dynamic> json) => _$UpdateProfileWithOTPRequestFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$UpdateProfileWithOTPRequestToJson(this);
}